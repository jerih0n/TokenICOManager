// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./CrowdfundingBase.sol";
import "../security/ERC20SecureApproval.sol";
import "../enums/CrowdfundingStatus.sol";
import "../interfaces/ITokenOwnerCrowdfundingContract.sol";

/**
Default implementation of the crowdfunding contract. The contract is the OWNER of the tokens. 
 */

abstract contract TokenOwnerCrowdfundingContract is
    CrowdfundingBase,
    ITokenOwnerCrowdfundingContract
{
    bool private isInited;

    modifier inited() {
        require(isInited, "Crowdfunding not inited inited");
        _;
    }
    modifier notInited() {
        require(!isInited, "Crowdfunding already inited");
        _;
    }

    modifier _canStart() {
        require(
            status == CrowdfundingStatus.NotStarted,
            "You cannot start this crowdfunding"
        );
        require(
            isInited,
            "You cannot start this crowdfunding. Please first initialze it"
        );
        _;
    }

    constructor(
        address _tokenAddress,
        uint8 _percentOfTotalSupplyToBeDistributed
    ) CrowdfundingBase(_tokenAddress, _percentOfTotalSupplyToBeDistributed) {
        isInited = false;
        //ERC20SecureApproval(_tokenAddress).approve(spender, amount);
    }

    function initCrowdsaleContract()
        public
        virtual
        override
        onlyOwner
        notInited
        returns (bool)
    {
        isInited = true;
        ERC20SecureApproval(tokenAddress).transfer(
            payable(address(this)),
            maxTokenAmountToBeDestributed
        );

        return true;
    }

    function _performTokenBuy(uint256 amount)
        internal
        virtual
        override
        inited
        returns (bool)
    {
        ERC20SecureApproval token = ERC20SecureApproval(tokenAddress);
        token.transfer(super._getSender(), amount);
    }

    function start() public virtual override inited canStart returns (bytes32) {
        return super.start();
    }

    function end() public virtual override canEnd returns (bytes32) {
        return super.end();
    }

    function getTokenBalance() public view override returns (uint256) {
        ERC20SecureApproval token = ERC20SecureApproval(tokenAddress);
        return token.balanceOf(address(this));
    }

    function getMaxTokenAmountToBeDestributed()
        public
        view
        override
        returns (uint256)
    {
        return maxTokenAmountToBeDestributed;
    }
}
