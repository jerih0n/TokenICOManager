// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

library Calculations {
    function calculatetTokenAmount(
        uint256 ethAmount,
        uint8 tokenDecimals,
        uint256 tokenToEthRate
    ) external pure returns (uint256) {
        return ((ethAmount * (10**tokenDecimals)) / 1 ether) * tokenToEthRate;
    }
}
