// SPDX-License-Identifier: MIT

/*
    Describes all the functions required for ERC20Token handlers
    ERC20Token handlers are mediator between ICO contract and ERC20 token contract communication
    Default Implementation will be for OppenZeppelin ERC20 token
*/
pragma solidity ^0.8.0;

interface IERC20TokenHandler {
    function isERC20Token() external view returns (bool);

    function getTotalSupply() external view returns (uint256);

    function getDecimals() external view returns (uint8);

    function getSymbol() external view returns (string memory);

    function getBalance(address _address) external view returns (uint256);
}
