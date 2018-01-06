pragma solidity ^0.4.11;

import './StandardToken.sol';

contract LockableToken is StandardToken {

    mapping(address => uint256) internal lockedBalance;

    mapping(address => uint) internal timeRelease;

    address internal teamReservedHolder;

    uint256 internal teamReservedBalance;

    uint [8] internal teamReservedFrozenDates;

    uint256 [8] internal teamReservedFrozenLimits;

    function LockableToken() public payable {

    }

    function lockInfo(address _address) public constant returns (uint timeLimit, uint256 balanceLimit) {
        return (timeRelease[_address], lockedBalance[_address]);
    }

    function teamReservedLimit() internal returns (uint256 balanceLimit) {
        uint time = now;
        for (uint index = 0; index < teamReservedFrozenDates.length; index++) {
            if (teamReservedFrozenDates[index] == 0x0) {
                continue;
            }
            if (time > teamReservedFrozenDates[index]) {
                teamReservedFrozenDates[index] = 0x0;
            } else {
                return teamReservedFrozenLimits[index];
            }
        }
        return 0;
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        return transferInternal(msg.sender, _to, _value);
    }

    function transferInternal(address _from, address _to, uint256 _value) internal returns (bool success) {
        require(_to != 0x0 && _value > 0x0);
        if (_from == teamReservedHolder) {
            uint256 reservedLimit = teamReservedLimit();
            require(balances[_from].sub(reservedLimit) >= _value);
        }
        var (timeLimit, lockLimit) = lockInfo(_from);
        if (timeLimit <= now && timeLimit != 0x0) {
            timeLimit = 0x0;
            timeRelease[_from] = 0x0;
            lockedBalance[_from] = 0x0;
            UnLock(_from, lockLimit);
            lockLimit = 0x0;
        }
        if (timeLimit != 0x0 && lockLimit > 0x0) {
            require(balances[_from].sub(lockLimit) >= _value);
        }
        return super.transferInternal(_from, _to, _value);
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        return transferFromInternal(_from, _to, _value);
    }

    function transferFromInternal(address _from, address _to, uint256 _value) internal returns (bool success) {
        require(_to != 0x0 && _value > 0x0);
        if (_from == teamReservedHolder) {
            uint256 reservedLimit = teamReservedLimit();
            require(balances[_from].sub(reservedLimit) >= _value);
        }
        var (timeLimit, lockLimit) = lockInfo(_from);
        if (timeLimit <= now && timeLimit != 0x0) {
            timeLimit = 0x0;
            timeRelease[_from] = 0x0;
            lockedBalance[_from] = 0x0;
            UnLock(_from, lockLimit);
            lockLimit = 0x0;
        }
        if (timeLimit != 0x0 && lockLimit > 0x0) {
            require(balances[_from].sub(lockLimit) >= _value);
        }
        return super.transferFrom(_from, _to, _value);
    }

    event Lock(address indexed owner, uint256 value, uint releaseTime);
    event UnLock(address indexed owner, uint256 value);
}