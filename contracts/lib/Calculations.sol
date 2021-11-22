// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

library Calculations {
    function calculatetTokenAmount(
        uint256 ethAmount, //100000000000000 * 10000
        uint8 tokenDecimals, // 18
        uint256 tokenToEthRate //1000
    ) external pure returns (uint256) {
        return ((ethAmount * (10**tokenDecimals)) / 1 ether) * tokenToEthRate;
    }

    function mulScale(
        uint256 x,
        uint256 y,
        uint256 scale
    ) external pure returns (uint256) {
        uint256 a = x / scale;
        uint256 b = x % scale;
        uint256 c = y / scale;
        uint256 d = y % scale;

        return a * c * scale + a * d + b * c + (b * d) / scale;
    }
}
