// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../enums/CrowdfundingStatus.sol";

interface ITimeBasedCrowdfunding {
    //try start the start the ICO. If ICO already started returns in PROGRESS status
    function start() external returns (CrowdfundingStatus);

    //end the ICO
    function end() external returns (CrowdfundingStatus);
}
