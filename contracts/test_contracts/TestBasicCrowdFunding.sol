// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../base/TokenOwnerCrowdfundingContract.sol";
import "../base/TokenOwnerCrowdfundingContract.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract TestBasicCrowdFunding is CrowdfundingBase {
    using SafeMath for uint256;

    constructor(address _tokenAddress) CrowdfundingBase(_tokenAddress, 100) {}

    function test_getRate(uint256 ethAmount) public view returns (uint256) {
        return _getRate(ethAmount);
    }

    function test_getTokenAmount(uint256 ethAmount)
        public
        view
        returns (uint256)
    {
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

    function getSender() public view returns (address) {
        return super._getSender();
    }
}
