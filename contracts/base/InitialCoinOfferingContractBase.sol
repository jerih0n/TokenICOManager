// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../interfaces/IInicialCoinOffering.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

//Declare the base logic for ICO contract
abstract contract InitialCoinOfferingConractBase is IInicialCoinOffering {

    using SafeMath for uint256;


    address payable private owner;
    InitialCoinOfferingStatus private status;
    uint256 private startDateTimestamp; //startDate of the ICO in second
    uint256 private endDateTimestamp; //end Date of the ICO in second
    uint256 private blockTimeStamp; //The block time stamp at the moment of deploy.
    address internal contractAddress;
    uint256 private _tokenSupply;

    modifier onlyOwner {
        require(msg.sender == owner, "Access Denied");
        _;
    }
    modifier started {
        require(status == InitialCoinOfferingStatus.InProgress, "The ICO is not started yet!");
        _;
    }

    modifier icoCanExpire{
        require(block.timestamp >= endDateTimestamp,"ICO Cannot be ended earlier");
        _;
    }

    modifier notStarted {
        require(status == InitialCoinOfferingStatus.NotStarted , "The ICO is either in progress or finished");
        _;
    }

    modifier canPay(address _sender, uint256 _amount) {
        require(_sender != address(0), "Cannot use Zero address");
        require(_sender.balance > _amount, "Insufficient balance");
        _;
    }
    constructor (uint256 _startDateTimestamp, uint256 _endDateTimeStamp, address _contractAddress) {

        //On Deploy the ICO is NOT Started
        status = InitialCoinOfferingStatus.NotStarted; 
        owner = payable(msg.sender); //setting the owner of the ICO 
        blockTimeStamp = block.timestamp; //set the last block timestamp

        //basic validation of the dates
        require(blockTimeStamp <= startDateTimestamp, "The ICO cannot start in the past");
        require(_startDateTimestamp < _endDateTimeStamp, "Start date must be before End Date");

        startDateTimestamp = _startDateTimestamp;
        endDateTimestamp = _endDateTimeStamp;

        //TODO: check if the address is ERC20 

        require(_isERC20Token(_contractAddress), "Given address is not ERC20 Token or the owner of the contract is not the ICO creator");

        contractAddress = _contractAddress;
    }

    
    function buy() public payable virtual override started canPay(msg.sender, msg.value) returns(bool) {      
        
        uint256 tokensToBeSend = getTokenAmount(msg.value);
        require(tokensToBeSend > 0, "Not Enought EHT amount for 1 token");

        owner.transfer(msg.value); // transfering the amount to token address

        //transafer token to sender address

        
        return false;
    }

    function start() public virtual override onlyOwner notStarted returns(InitialCoinOfferingStatus) {

        status = InitialCoinOfferingStatus.InProgress;

        emit IcoStart(startDateTimestamp, endDateTimestamp);

        return status;
    }

    function getStatus() public virtual override returns(InitialCoinOfferingStatus) {

        return status;
    }

    function end() public virtual override onlyOwner icoCanExpire returns(InitialCoinOfferingStatus) {

        status = InitialCoinOfferingStatus.Finished;

        emit IcoEnd(endDateTimestamp);

        return status;
    }

    function getTokenAmount(uint256 ethAmount) internal virtual view returns(uint256 tokenAmount) {

        return getRate(ethAmount); // default 1:1 -> 1 eth for one ERC20 token
    }

    //check if token is ERC20 competible.
    //the default check will check if the _address is ERC20 token by OpenZeppelin implementation
    //override to perform different check
    function _isERC20Token(address _address) internal virtual view returns(bool) {
        IERC20 token  = IERC20(_address);
        uint256 balance = token.balanceOf(owner);

        if(balance == 0) {
            return true;
        }
        return false;
    }


    function transferToken(address _tokenAddress, address _to, uint256 _amount) internal virtual{
        //
        IERC20 token  = IERC20(_tokenAddress);

        token.transfer(_to, _amount);
        emit TransferToken(_to, _amount, _tokenAddress);
    }
    function getOwner() internal view returns(address) {
        return owner;
    }
    //Implement logic for calculating the rate for exchanging ETH to Token
    function getRate(uint256 ethAmount) internal virtual view returns(uint256 tokenAmount);

    
    event IcoStart(uint256 _start, uint256 _end);
    event IcoEnd(uint256 _end);
    event TransferEthereum(address _from, uint256 _value); 
    event TransferToken(address _to, uint256 _value, address _tokenAddress);
}