// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../../interfaces/IERC20TokenHandler.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract OppenZeppelingERC20TokenHandler is IERC20TokenHandler {

    ERC20 private token;
    address private callerAddress;

    constructor(address _tokenAddress, address _callerAddress) {
        token = ERC20(_tokenAddress);
        callerAddress = _callerAddress;
    }

    function isERC20Token() public view override returns(bool) {
        require(token.balanceOf(callerAddress) > 0, "ERROR. Provided address is not ERC20 token or caller address cannot operate with the amount");
        return true;
    }

    function getDecimals() public view override returns(uint256) {
        require(isERC20Token(),"ERROR. Provided address is not ERC20 token or caller address cannot operate with the amount");
        return token.decimals();
    }

    function transfer(address _to, uint256 _amount) public payable override returns(bool) {
        require(token.balanceOf(callerAddress) > 0, "ERROR. Provided address is not ERC20 token or caller address cannot operate with the amount");
        require(token.transfer(_to, _amount),"ERROR.");
        return true;
        
    }

    function getTotalSupply() public view override returns(uint256) {
        require(token.balanceOf(callerAddress) > 0, "ERROR. Provided address is not ERC20 token");
        return token.totalSupply();
    }

    function getSymbol() public view override returns(string memory) {
        require(token.balanceOf(callerAddress) > 0, "ERROR. Provided address is not ERC20 token or caller address cannot operate with the amount");
        return token.symbol();
    }
}