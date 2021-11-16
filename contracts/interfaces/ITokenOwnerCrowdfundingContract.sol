// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface ITokenOwnerCrowdfundingContract {
    function getTokenBalance() external view returns (uint256);

    function initCrowdsaleContract() external returns (bool);

    function getMaxTokenAmountToBeDestributed() external view returns (uint256);
}
