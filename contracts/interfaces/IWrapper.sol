pragma solidity ^0.8.0;

interface IWrapper {
    function wrap(address _address) external;

    function unwrap() external;
}
