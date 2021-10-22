// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../enums/CrowdfundingStatus.sol";
import "./IERC20TokenHandler.sol";

interface ICrowdfunding {

    // declare the most important ability of all - the ability to buy token with ETH
    function buy() external payable returns(bool);

    //try start the start the ICO. If ICO already started returns in PROGRESS status 
    function start() external returns(CrowdfundingStatus);

    //return the status of ICO
    function getStatus() external returns(CrowdfundingStatus);

    //end the ICO
    function end() external returns(CrowdfundingStatus);

    function getERC20TokenHandler() external view returns(IERC20TokenHandler);

}

