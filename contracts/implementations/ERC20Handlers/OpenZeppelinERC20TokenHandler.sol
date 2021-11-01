// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../../interfaces/IERC20TokenHandler.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../../lib/Calculations.sol";

contract OpenZeppelingERC20TokenHandler is IERC20TokenHandler {
    address private owner;
    address private callerAddress;
    address private tokenAddress;
    bool private isAmountLoaded;

    modifier canLoad() {
        require(!isAmountLoaded, "Amount Already Loaded");
        _;
    }
    modifier onlyOwner() {
        require(msg.sender == owner, "Access Denied");
        _;
    }

    modifier betweenZeroAndHundread(uint8 _totalSupplyPersents) {
        require(
            _totalSupplyPersents > 1 && _totalSupplyPersents <= 100,
            "Invalid persents! Value should be between 1 and 100"
        );
        _;
    }

    modifier wrapped() {
        require(
            tokenAddress != address(0),
            "No token address provided. wrap function call required"
        );
        _;
    }

    constructor() {
        //ERC20 token = ERC20(_tokenAddress);
        isAmountLoaded = false;
        owner = msg.sender;
    }

    function wrap(address _address) public override {
        require(_address != address(0), "Cannot set to that address address");
        tokenAddress = _address;
    }

    function unwrap() public override wrapped {
        tokenAddress = address(0);
    }

    function isERC20Token() public view override wrapped returns (bool) {
        ERC20 token = ERC20(tokenAddress);
        require(
            token.balanceOf(callerAddress) > 0,
            "ERROR. Provided address is not ERC20 token or caller address cannot operate with the amount"
        );
        return true;
    }

    function getDecimals() public view override wrapped returns (uint8) {
        ERC20 token = ERC20(tokenAddress);

        return token.decimals();
    }

    function getTotalSupply() public view override wrapped returns (uint256) {
        ERC20 token = ERC20(tokenAddress);
        return token.totalSupply();
    }

    function getSymbol() public view override wrapped returns (string memory) {
        ERC20 token = ERC20(tokenAddress);
        return token.symbol();
    }

    function getBalance(address _address)
        public
        view
        override
        wrapped
        returns (uint256)
    {
        ERC20 token = ERC20(tokenAddress);
        return token.balanceOf(_address);
    }

    //call after initialization of the smart contract
    //pass the % of the total amount that are be used for ICO
    function loadBalance(uint8 _totalSupplyPersents, uint128 _scale)
        public
        onlyOwner
        canLoad
        betweenZeroAndHundread(_totalSupplyPersents)
        wrapped
    {
        ERC20 token = ERC20(tokenAddress);

        uint256 tokenSupply = token.totalSupply();

        uint256 tokensForDistribution = Calculations.mulScale(
            tokenSupply,
            _totalSupplyPersents,
            _scale
        );

        require(
            tokensForDistribution >= tokenSupply,
            "Tokens for distribution should be less or equal to max supply"
        );

        token.transfer(callerAddress, tokensForDistribution);
    }
}
