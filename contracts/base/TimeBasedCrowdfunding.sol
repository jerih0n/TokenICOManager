// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./CrowdfundingBase.sol";
import "../interfaces/ICrowdfunding.sol";
import "../interfaces/IERC20TokenHandler.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "../interfaces/ITimeBasedCrowdfunding.sol";

abstract contract TimeBasedCrowdfunding is
    CrowdfundingBase,
    ITimeBasedCrowdfunding
{
    uint256 private startDate; //startDate of the ICO in second
    uint256 private endDate; //end Date of the ICO in second
    uint256 private blockDateTime;

    modifier started() {
        require(
            status == CrowdfundingStatus.InProgress,
            "The ICO is not started yet!"
        );
        _;
    }

    modifier icoCanExpire() {
        require(block.timestamp >= endDate, "ICO Cannot be ended earlier");
        _;
    }

    modifier notStarted() {
        require(
            status == CrowdfundingStatus.NotStarted,
            "The ICO is either in progress or finished"
        );
        _;
    }

    event IcoStart(uint256 _start, uint256 _end);
    event IcoEnd(uint256 _end);

    constructor(
        uint256 _startDate,
        uint256 _endDate,
        address _tokenAddress,
        address _tokenHandlerAddress
    ) CrowdfundingBase(_tokenAddress, _tokenHandlerAddress) {
        //basic validation of the dates
        blockDateTime = block.timestamp;

        require(
            blockDateTime <= _startDate,
            "The ICO cannot start in the past"
        );
        require(_startDate < _endDate, "Start date must be before End Date");

        startDate = _startDate;
        endDate = _endDate;
    }

    function buy()
        public
        payable
        virtual
        override
        started
        canPay(msg.sender, msg.value)
        returns (bool)
    {
        return super.buy();
    }

    function start()
        public
        virtual
        override
        onlyOwner
        notStarted
        returns (CrowdfundingStatus)
    {
        status = CrowdfundingStatus.InProgress;

        emit IcoStart(startDate, endDate);

        return status;
    }

    function end()
        public
        virtual
        override
        onlyOwner
        icoCanExpire
        returns (CrowdfundingStatus)
    {
        status = CrowdfundingStatus.Finished;

        emit IcoEnd(endDate);

        return status;
    }
}
