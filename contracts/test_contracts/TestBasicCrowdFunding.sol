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

    function _getRate(uint256 ethAmount)
        internal
        view
        virtual
        override
        returns (uint256 tokenAmount)
    {
        return 1000; //1 eth for 1000;
    }

    function _setERC20TokenHandler(address _tokenAddress)
        internal
        view
        override
        returns (IERC20TokenHandler)
    {
        return _handler;
    }
}
