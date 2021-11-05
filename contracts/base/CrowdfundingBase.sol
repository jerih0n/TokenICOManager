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
    address payable private owner;
    address internal tokenAddress;
    uint256 internal maxTokenAmountToBeDestributed;
    mapping(address => uint256) internal contributers;

    modifier onlyOwner() {
        require(msg.sender == owner, "Access Denied");
        _;
    }

    modifier canPay(address _sender, uint256 _amount) {
        require(_sender != address(0), "Cannot use Zero address");
        require(_sender.balance > _amount, "Insufficient balance");
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

    function getStatus() public virtual override returns (CrowdfundingStatus) {
        return status;
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

    //Implement logic for calculating the rate for exchanging ETH to Token
    function _getRate(uint256 ethAmount)
        internal
        view
        virtual
        returns (uint256 tokenAmount);

    function _getPercentageScale() internal pure virtual returns (uint256) {
        return DEFAULT_PERCENTAGE_SCALE;
    }

    function _buy() internal virtual returns (bool) {
        ERC20SecureApproval token = ERC20SecureApproval(tokenAddress);

        uint256 tokenAmount = _getTokenAmount(_getSenderValue());

        require(tokenAmount > 0, "Not Enought EHT amount for 1 token");

        emit TransferEthereum(_getSender(), _getSenderValue());

        owner.transfer(_getSenderValue()); // transfering the amount to token address

        //transafer token to sender address
        token.approve(_getSender(), tokenAmount);

        token.transferFrom(owner, _getSender(), tokenAmount);

        emit TransferToken(_getSender(), msg.value, owner);

        return true;
    }
}
