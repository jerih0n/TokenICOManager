// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

library Conversion {
    function weiToEth(uint256 amount) external pure returns (uint256) {
        return amount / 10**18;
    }

    function ethToWei(uint256 amount) external pure returns (uint256) {
        return amount * (10**18);
    }
}
