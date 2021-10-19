pragma solidity ^0.8.0;

import "../interfaces/IInicialCoinOffering.sol";

abstract contract InitialCoinOfferingConractBase is IInicialCoinOffering {

    address private _owner;
    InitialCoinOfferingStatus private status;
    uint256 private startDateTimestamp; //startDate of the ICO in second
    uint256 private endDateTimestamp; //end Date of the ICO in second
    uint256 private blockTimeStamp; //The block time stamp at the moment of deploy.
    
    constructor(uint256 _startDateTimestamp, uint256 _endDateTimeStamp) {
        //On Deploy the ICO is NOT Started
        status = InitialCoinOfferingStatus.NotStarted; 
        _owner = msg.sender; //setting the owner of the ICO 
        blockTimeStamp = block.timestamp;
        require(blockTimeStamp <= startDateTimestamp, "The ICO cannot start in the past");
        require(_startDateTimestamp < _endDateTimeStamp, "Start date must be before End Date");

        startDateTimestamp = _startDateTimestamp;
        endDateTimestamp = _endDateTimeStamp;

        
    }

    function buy() public virtual override payable returns(bool) {
        return false;
    }

    function start() public virtual override returns(InitialCoinOfferingStatus) {
        return status;
    }

    function getStatus() public virtual override returns(InitialCoinOfferingStatus) {
        return status;
    }
        
}