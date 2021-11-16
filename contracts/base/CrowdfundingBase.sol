// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../interfaces/ICrowdfunding.sol";
import "../lib/Calculations.sol";
import "../security/ERC20SecureApproval.sol";

//Declare the base logic for ICO contract
abstract contract CrowdfundingBase is ICrowdfunding {
    using SafeMath for uint256;

    uint256 constant DEFAULT_PERCENTAGE_SCALE = 100;

    CrowdfundingStatus internal status;
    address payable internal owner;
    address internal tokenAddress;
    uint256 internal maxTokenAmountToBeDestributed;
    mapping(address => uint256) internal contributers;

    modifier onlyOwner() {
        require(_getSender() == owner, "Access Denied");
        _;
    }

    modifier canPay(address _sender, uint256 _amount) {
        require(_sender != address(0), "Cannot use Zero address");
        require(_sender.balance > _amount, "Insufficient balance");
        _;
    }

    modifier canStart() {
        require(
            status == CrowdfundingStatus.NotStarted,
            "The crowdfund cannot start"
        );
        _;
    }
    modifier canEnd() {
        require(
            status == CrowdfundingStatus.InProgress,
            "The crowdfund is already finished"
        );
        _;
    }
    event TransferEthereum(address _from, uint256 _value);
    event TransferToken(address _to, uint256 _value, address _tokenAddress);
    event ContractInitialized(address _self, CrowdfundingStatus status);

    constructor(
        address _tokenAddress,
        uint8 _percentOfTotalSupplyToBeDistributed
    ) {
        //On Deploy the ICO is NOT Started
        status = CrowdfundingStatus.NotStarted;
        owner = payable(_getSender()); //setting the owner of the ICO
        tokenAddress = _tokenAddress;

        ERC20SecureApproval token = ERC20SecureApproval(_tokenAddress);
        require(
            token.balanceOf(owner) > 0,
            "Provided Address is either not ERC20 or caller cannot distribute the token"
        );
        require(
            _percentOfTotalSupplyToBeDistributed > 0 &&
                _percentOfTotalSupplyToBeDistributed <= 100,
            "Invalid Percents Presented"
        );

        maxTokenAmountToBeDestributed = Calculations.mulScale(
            token.totalSupply(),
            _percentOfTotalSupplyToBeDistributed,
            _getPercentageScale()
        );

        emit ContractInitialized(address(this), status);
    }

    //TODO:
    function buy()
        public
        payable
        virtual
        override
        canPay(msg.sender, msg.value)
        returns (bool)
    {
        require(_buy(), "Transaction Failed");
    }

    function _getTokenAmount(uint256 ethAmount)
        internal
        view
        virtual
        returns (uint256 tokenAmount)
    {
        ERC20SecureApproval token = ERC20SecureApproval(tokenAddress);

        return
            Calculations.calculatetTokenAmount(
                ethAmount,
                token.decimals(),
                _getRate(ethAmount)
            );
    }

    function getStatus() public view virtual override returns (bytes32) {
        return _getStatusAsString(status);
    }

    function getEthBalance() public view override onlyOwner returns (uint256) {
        return address(this).balance;
    }

    function _getSender() internal view returns (address) {
        return msg.sender;
    }

    function _getSenderValue() internal view returns (uint256) {
        return msg.value;
    }

    function _getPercentageScale() internal pure virtual returns (uint256) {
        return DEFAULT_PERCENTAGE_SCALE;
    }

    function _buy() internal returns (bool) {
        ERC20SecureApproval token = ERC20SecureApproval(tokenAddress);

        uint256 tokenAmount = _getTokenAmount(_getSenderValue());

        _beforeEtereumTransfer(); //Hook Call

        require(tokenAmount > 0, "Not Enought EHT amount for 1 token");

        emit TransferEthereum(_getSender(), _getSenderValue());

        require(_performTokenBuy(tokenAmount), "Transfer failed");

        owner.transfer(_getSenderValue()); // transfering the amount to token address

        _afterEthereumTransfer(); //Hook Call

        _beforeTokenTransfer(); //Hook Call
        //transafer token to sender address
        token.approve(_getSender(), tokenAmount);

        token.transferFrom(owner, _getSender(), tokenAmount);

        emit TransferToken(_getSender(), msg.value, owner);

        _afterTokenTransfer(); //Hook Call
        return true;
    }

    function start() public virtual override canStart returns (bytes32) {
        status = CrowdfundingStatus.InProgress;
        return getStatus();
    }

    function end() public virtual override canEnd returns (bytes32) {
        status = CrowdfundingStatus.Finished;
        return getStatus();
    }

    function _performTokenBuy(uint256 amount) internal virtual returns (bool) {}

    /**
    @dev Hooks
    defined virtual hooks to be called before and efter transaction happends

     */

    function _beforeEtereumTransfer() internal virtual {}

    function _afterEthereumTransfer() internal virtual {}

    function _beforeTokenTransfer() internal virtual {}

    function _afterTokenTransfer() internal virtual {}

    //Implement logic for calculating the rate for exchanging ETH to Token
    function _getRate(uint256 ethAmount)
        internal
        view
        virtual
        returns (uint256 tokenAmount);

    function _getStatusAsString(CrowdfundingStatus _status)
        private
        pure
        returns (bytes32)
    {
        if (_status == CrowdfundingStatus.NotStarted) {
            return bytes32("Not Started");
        } else if (_status == CrowdfundingStatus.InProgress) {
            return bytes32("In Progress");
        } else {
            return bytes32("Finished");
        }
    }
}
