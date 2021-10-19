pragma solidity ^0.8.0;

import "../enums/InitialCoinOfferingStatus.sol";

interface IInicialCoinOffering {

    // declare the most important ability of all - the ability to buy token with ETH
    function buy() external payable returns(bool);

    //try start the start the ICO. If ICO already started returns in PROGRESS status 
    function start() external returns(InitialCoinOfferingStatus);

    //return the status of ICO
    function getStatus() external returns(InitialCoinOfferingStatus);



}

