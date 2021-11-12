// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../security/ERC20SecureApproval.sol";

/**
    Very simple ERC20 Token build with OpenZeppelin in order to perfomr tests on the ICO logic
 */
contract TestToken is ERC20SecureApproval {
    address payable internal _owner;

    constructor() ERC20SecureApproval("TestToken", "TT") {
        _mint(msg.sender, 10000000000000000000000000);
        _owner = payable(msg.sender);
    }

    // THIS IS JUST FOR PLAYING !
    function decimals() public pure override returns (uint8) {
        return 18;
    }
}
