// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../interfaces/ICrowdfunding.sol";
import "../interfaces/IERC20TokenHandler.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

//Declare the base logic for ICO contract
abstract contract CrowdfundingBase is ICrowdfunding {
    using SafeMath for uint256;

    address payable private owner;
    CrowdfundingStatus private status;
    uint256 private startDateTimestamp; //startDate of the ICO in second
    uint256 private endDateTimestamp; //end Date of the ICO in second
    uint256 private blockTimeStamp; //The block time stamp at the moment of deploy.
    address internal tokenAddress;
    uint256 private _tokenSupply;

    modifier onlyOwner() {
        require(msg.sender == owner, "Access Denied");
        _;
    }
    modifier started() {
        require(
            status == CrowdfundingStatus.InProgress,
            "The ICO is not started yet!"
        );
        _;
    }

    modifier icoCanExpire() {
        require(
            block.timestamp >= endDateTimestamp,
            "ICO Cannot be ended earlier"
        );
        _;
    }

    modifier notStarted() {
        require(
            status == CrowdfundingStatus.NotStarted,
            "The ICO is either in progress or finished"
        );
        _;
    }

    modifier canPay(address _sender, uint256 _amount) {
        require(_sender != address(0), "Cannot use Zero address");
        require(_sender.balance > _amount, "Insufficient balance");
        _;
    }

    constructor(
        uint256 _startDateTimestamp,
        uint256 _endDateTimeStamp,
        address _tokenAddress
    ) {
        //On Deploy the ICO is NOT Started
        status = CrowdfundingStatus.NotStarted;
        owner = payable(msg.sender); //setting the owner of the ICO
        blockTimeStamp = block.timestamp; //set the last block timestamp

        //basic validation of the dates
        require(
            blockTimeStamp <= startDateTimestamp,
            "The ICO cannot start in the past"
        );
        require(
            _startDateTimestamp < _endDateTimeStamp,
            "Start date must be before End Date"
        );

        startDateTimestamp = _startDateTimestamp;
        endDateTimestamp = _endDateTimeStamp;

        IERC20TokenHandler tokenHandler = _setERC20TokenHandler(_tokenAddress);

        require(
            tokenHandler.isERC20Token(),
            "Given address is not ERC20 Token or the owner of the contract is not the ICO creator"
        );
        tokenAddress = _tokenAddress;
    }

    function buy()
        public
        payable
        virtual
        override
        started
        canPay(msg.sender, msg.value)
        returns (bool)
    {
        uint256 tokensToBeSend = _getTokenAmount(msg.value);

        require(tokensToBeSend > 0, "Not Enought EHT amount for 1 token");

        owner.transfer(msg.value); // transfering the amount to token address

        //transafer token to sender address

        IERC20TokenHandler tokenHandler = _setERC20TokenHandler(tokenAddress);

        require(
            tokenHandler.transferTo(msg.sender, tokensToBeSend),
            "Error On Transfer. Reverting"
        );

        return true;
    }

    function start()
        public
        virtual
        override
        onlyOwner
        notStarted
        returns (CrowdfundingStatus)
    {
        status = CrowdfundingStatus.InProgress;

        emit IcoStart(startDateTimestamp, endDateTimestamp);

        return status;
    }

    function getStatus() public virtual override returns (CrowdfundingStatus) {
        return status;
    }

    function end()
        public
        virtual
        override
        onlyOwner
        icoCanExpire
        returns (CrowdfundingStatus)
    {
        status = CrowdfundingStatus.Finished;

        emit IcoEnd(endDateTimestamp);

        return status;
    }

    function _getTokenAmount(uint256 ethAmount)
        internal
        view
        virtual
        returns (uint256 tokenAmount)
    {
        return _getRate(ethAmount); // default 1:1 -> 1 eth for one ERC20 token
    }

    //Implement the required IERC20TokenHandler
    function _setERC20TokenHandler(address _tokenAddress)
        internal
        view
        virtual
        returns (IERC20TokenHandler);

    //Implement logic for calculating the rate for exchanging ETH to Token
    function _getRate(uint256 ethAmount)
        internal
        view
        virtual
        returns (uint256 tokenAmount);

    event IcoStart(uint256 _start, uint256 _end);
    event IcoEnd(uint256 _end);
    event TransferEthereum(address _from, uint256 _value);
    event TransferToken(address _to, uint256 _value, address _tokenAddress);
}
