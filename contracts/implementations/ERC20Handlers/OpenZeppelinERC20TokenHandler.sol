// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../../interfaces/IERC20TokenHandler.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract OpenZeppelingERC20TokenHandler is IERC20TokenHandler {
    address private callerAddress;
    address private tokenAddress;

    constructor(address _tokenAddress, address _callerAddress) {
        ERC20 token = ERC20(_tokenAddress);
        require(
            token.balanceOf(_callerAddress) > 0,
            "ERROR. Provided address is not ERC20 token or caller address cannot operate with the amount"
        );
        tokenAddress = _tokenAddress;
        callerAddress = _callerAddress;
    }

    function isERC20Token() public view override returns (bool) {
        ERC20 token = ERC20(tokenAddress);
        require(
            token.balanceOf(callerAddress) > 0,
            "ERROR. Provided address is not ERC20 token or caller address cannot operate with the amount"
        );
        return true;
    }
    function getDecimals() public view override returns(uint8) {
        ERC20 token = ERC20(tokenAddress);

        return token.decimals();
    }

    function transferTo(address _to, uint256 _amount)
        public
        payable
        override
        returns (bool)
    {
        ERC20 token = ERC20(tokenAddress);
        require(token.transfer(_to, _amount),"ERROR.");
        return true;
    }

    function getTotalSupply() public view override returns (uint256) {
        ERC20 token = ERC20(tokenAddress);
        return token.totalSupply();
    }

    function getSymbol() public view override returns (string memory) {
        ERC20 token = ERC20(tokenAddress);
        return token.symbol();
    }
    function getBalance(address _address) public view override returns (uint256) {
         ERC20 token = ERC20(tokenAddress);
         return token.balanceOf(_address);

    }
}
