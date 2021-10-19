pragma solidity ^0.8.0;

import "../interfaces/IInicialCoinOffering.sol";

abstract contract InitialCoinOfferingConractBase is IInicialCoinOffering {

    address private _owner;
    InitialCoinOfferingStatus private status;
    uint256 private startDateTimestamp; //startDate of the ICO in second
    uint256 private endDateTimestamp; //end Date of the ICO in second
    uint256 private blockTimeStamp; //The block time stamp at the moment of deploy.
    address private contractAddress;

    constructor(uint256 _startDateTimestamp, uint256 _endDateTimeStamp, address _contractAddress) {
        //On Deploy the ICO is NOT Started
        status = InitialCoinOfferingStatus.NotStarted; 
        _owner = msg.sender; //setting the owner of the ICO 
        blockTimeStamp = block.timestamp; //set the last block timestamp

        //Perform basic validation for the start and end date of the ICO
        require(blockTimeStamp <= startDateTimestamp, "The ICO cannot start in the past");
        require(_startDateTimestamp < _endDateTimeStamp, "Start date must be before End Date");

        startDateTimestamp = _startDateTimestamp;
        endDateTimestamp = _endDateTimeStamp;
        //TODO: check if the address is ERC20 
        contractAddress = _contractAddress;
    }

    modifier started {
        require(status == InitialCoinOfferingStatus.InProgress, "The ICO is not started yet!");
        _;
    }

    modifier notStarted {
        require(status == InitialCoinOfferingStatus.NotStarted , "The ICO is either in progress or finished");
        _;
    }
    function buy() public virtual override payable started returns(bool) {
        return false;
    }

    function start() public virtual override notStarted returns(InitialCoinOfferingStatus) {
        return status;
    }

    function getStatus() public virtual override returns(InitialCoinOfferingStatus) {
        return status;
    }
        
}