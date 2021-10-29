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

    function mulScale(
        uint256 x,
        uint256 y,
        uint128 scale
    ) external pure returns (uint256) {
        uint256 a = x / scale;
        uint256 b = x % scale;
        uint256 c = y / scale;
        uint256 d = y % scale;

        return a * c * scale + a * d + b * c + (b * d) / scale;
    }
}
