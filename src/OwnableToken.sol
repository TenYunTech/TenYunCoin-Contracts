pragma solidity ^0.4.11;

import './TradeableToken.sol';

contract OwnableToken is TradeableToken {

    address internal owner;

    uint internal _totalSupply = 1500000000 * 10 ** 8;

    function OwnableToken() public payable {

    }

    /*
     *  Modifiers
     */
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address _newOwner) onlyOwner public {
        require(_newOwner != address(0));
        owner = _newOwner;
        OwnershipTransferred(owner, _newOwner);
    }

    function lock(address _owner, uint256 _value, uint _releaseTime) public payable onlyOwner returns (uint releaseTime, uint256 limit) {
        require(_owner != 0x0 && _value > 0x0 && _releaseTime >= now);
        _value = lockedBalance[_owner].add(_value);
        _releaseTime = _releaseTime >= timeRelease[_owner] ? _releaseTime : timeRelease[_owner];
        lockedBalance[_owner] = _value;
        timeRelease[_owner] = _releaseTime;
        Lock(_owner, _value, _releaseTime);
        return (_releaseTime, _value);
    }

    function unlock(address _owner) public payable onlyOwner returns (bool) {
        require(_owner != 0x0);
        uint256 _value = lockedBalance[_owner];
        lockedBalance[_owner] = 0x0;
        timeRelease[_owner] = 0x0;
        UnLock(_owner, _value);
        return true;
    }

    function transferAndLock(address _to, uint256 _value, uint _releaseTime) public payable onlyOwner returns (bool success) {
        require(_to != 0x0);
        require(_value > 0);
        require(_releaseTime >= now);
        require(_value <= balances[msg.sender]);

        super.transfer(_to, _value);
        lock(_to, _value, _releaseTime);
        return true;
    }

    function setBaseExchangeRate(uint256 _baseExchangeRate) public payable onlyOwner returns (bool success) {
        require(_baseExchangeRate > 0x0);
        baseExchangeRate = _baseExchangeRate;
        BaseExchangeRateChanged(baseExchangeRate);
        return true;
    }

    function setEarlyExchangeRate(uint256 _earlyExchangeRate) public payable onlyOwner returns (bool success) {
        require(_earlyExchangeRate > 0x0);
        earlyExchangeRate = _earlyExchangeRate;
        EarlyExchangeRateChanged(earlyExchangeRate);
        return true;
    }

    function setEarlyEndTime(uint256 _earlyEndTime) public payable onlyOwner returns (bool success) {
        require(_earlyEndTime > 0x0);
        earlyEndTime = _earlyEndTime;
        EarlyEndTimeChanged(earlyEndTime);
        return true;
    }

    function burn(uint256 _value) public payable onlyOwner returns (bool success) {
        require(_value > 0x0);
        require(_value <= balances[msg.sender]);

        balances[msg.sender] = balances[msg.sender].sub(_value);
        _totalSupply = _totalSupply.sub(_value);
        Burned(_value);
        return true;
    }

    function setPublicOfferingHolder(address _publicOfferingHolder) public payable onlyOwner returns (bool success) {
        require(_publicOfferingHolder != 0x0);
        publicOfferingHolder = _publicOfferingHolder;
        return true;
    }

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event BaseExchangeRateChanged(uint256 baseExchangeRate);
    event EarlyExchangeRateChanged(uint256 earlyExchangeRate);
    event EarlyEndTimeChanged(uint256 earlyEndTime);
    event Burned(uint256 value);
}