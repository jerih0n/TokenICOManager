// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../interfaces/ICrowdfunding.sol";
import "../interfaces/IERC20TokenHandler.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

//Declare the base logic for ICO contract
abstract contract CrowdfundingBase is ICrowdfunding {
    using SafeMath for uint256;

    CrowdfundingStatus internal status;
    address payable private owner;

    uint256 private startDateTimestamp; //startDate of the ICO in second
    uint256 private endDateTimestamp; //end Date of the ICO in second
    uint256 private blockTimeStamp; //The block time stamp at the moment of deploy.
    address internal tokenAddress;
    uint256 private _tokenSupply;

    modifier onlyOwner() {
        require(msg.sender == owner, "Access Denied");
        _;
    }

    modifier canPay(address _sender, uint256 _amount) {
        require(_sender != address(0), "Cannot use Zero address");
        require(_sender.balance > _amount, "Insufficient balance");
        _;
    }

    event IcoStart(uint256 _start, uint256 _end);
    event IcoEnd(uint256 _end);
    event TransferEthereum(address _from, uint256 _value);
    event TransferToken(address _to, uint256 _value, address _tokenAddress);

    constructor(address _tokenAddress) {
        //On Deploy the ICO is NOT Started
        status = CrowdfundingStatus.NotStarted;
        owner = payable(msg.sender); //setting the owner of the ICO
        blockTimeStamp = block.timestamp; //set the last block timestamp

        IERC20TokenHandler tokenHandler = _setERC20TokenHandler(_tokenAddress);

        require(
            tokenHandler.isERC20Token(),
            "Given address is not ERC20 Token or the owner of the contract is not the ICO creator"
        );
        tokenAddress = _tokenAddress;
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
        uint256 tokensToBeSend = _getTokenAmount(msg.value);

        require(tokensToBeSend > 0, "Not Enought EHT amount for 1 token");

        emit TransferEthereum(msg.sender, msg.value);

        owner.transfer(msg.value); // transfering the amount to token address

        //transafer token to sender address

        IERC20TokenHandler tokenHandler = _setERC20TokenHandler(tokenAddress);

        //tokenHandler.transfer(msg.sender, msg.value);

        emit TransferToken(msg.sender, msg.value, owner);

        return true;
    }

    function _getTokenAmount(uint256 ethAmount)
        internal
        view
        virtual
        returns (uint256 tokenAmount)
    {
        IERC20TokenHandler tokenHandler = _setERC20TokenHandler(tokenAddress);
        return
            ((ethAmount * (10**tokenHandler.getDecimals())) / 1 ether) *
            _getRate(ethAmount);
    }

    //Implement the required IERC20TokenHandler
    function _setERC20TokenHandler(address _tokenAddress)
        internal
        view
        virtual
        returns (IERC20TokenHandler);

    //Implement logic for calculating the rate for exchanging ETH to Token
    function _getRate(uint256 ethAmount)
        internal
        view
        virtual
        returns (uint256 tokenAmount);

    function getStatus() public virtual override returns (CrowdfundingStatus) {
        return status;
    }
}
