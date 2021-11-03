// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../enums/CrowdfundingStatus.sol";

interface ICrowdfunding {
    // declare the most important ability of all - the ability to buy token with ETH
    function buy() external payable returns (bool);

    //return the status of ICO
    function getStatus() external returns (CrowdfundingStatus);

    function getEthBalance() external view returns (uint256);
}
