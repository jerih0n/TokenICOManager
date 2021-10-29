// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../base/CrowdfundingBase.sol";
import "../implementations/ERC20Handlers/OpenZeppelinERC20TokenHandler.sol";
import "../interfaces/IERC20TokenHandler.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract TestBasicCrowdFunding is CrowdfundingBase {
    using SafeMath for uint256;

    OpenZeppelingERC20TokenHandler internal _handler;

    constructor(address _tokenAddress) CrowdfundingBase(_tokenAddress) {
        _handler = new OpenZeppelingERC20TokenHandler(
            _tokenAddress,
            _getSender()
        );
    }

    function test_getRate(uint256 ethAmount) public view returns (uint256) {
        return _getRate(ethAmount);
    }

    function test_getERC20TokenHandler(address _tokenAddress)
        public
        view
        returns (IERC20TokenHandler)
    {
        return _getERC20TokenHandler(_tokenAddress);
    }

    function test_getTokenAmount(uint256 ethAmount) public returns (uint256) {
        uint256 tokenAmount = super._getTokenAmount(ethAmount);
        return tokenAmount;
    }

    function _getRate(uint256 ethAmount)
        internal
        view
        virtual
        override
        returns (uint256 tokenAmount)
    {
        return 1000; //1 eth for 1000;
    }

    function _getERC20TokenHandler(address _tokenAddress)
        internal
        view
        override
        returns (IERC20TokenHandler)
    {
        return _handler;
    }

    function getSender() public view returns (address) {
        return super._getSender();
    }
}
