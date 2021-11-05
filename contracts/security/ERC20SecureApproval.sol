// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
pragma solidity ^0.8.0;

contract ERC20SecureApproval is ERC20 {
    /**
    @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
    
    This method is a wrapper for approce fuction of standart ERC20 tokne in order to prevent vector attack with combination of approve and transferFrom calls
    see this issue for more information
    https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     */
    address private _owner;

    constructor(string memory _name, string memory _symbol)
        ERC20(_name, _symbol)
    {
        _owner = msg.sender;
    }

    function secureApprove(
        address _spender,
        uint256 _amount,
        uint256 _currentAmount
    ) internal returns (bool) {
        if (_currentAmount == _amount) {
            //update values
            super.approve(_spender, _amount);
            return true;
        }
        return false;
    }

    function approve(address spender, uint256 amount)
        public
        virtual
        override
        returns (bool)
    {
        uint256 approvedAmount = super.allowance(_owner, spender);
        return secureApprove(spender, amount, approvedAmount);
    }
}
