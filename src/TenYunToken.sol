pragma solidity ^0.4.11;

import './OwnableToken.sol';
import './DateTimeLib.sol';

contract TenYunToken is OwnableToken {

    string public constant symbol = "TYC";

    string public constant name = "TenYun Coin";

    uint8 public constant decimals = 8;

    function TenYunToken() public payable {
        owner = 0x0;
        balances[owner] = 1500000000 * 10 ** 8;

        publicOfferingHolder = 0x0;
        balances[publicOfferingHolder] = 0x0;
        baseExchangeRate = 8500;
        earlyExchangeRate = 9445;
        earlyEndTime = 1516291200;

        teamReservedHolder = 0x0;
        teamReservedBalance = 300000000 * 10 ** 8;
        balances[teamReservedHolder] = 0x0;
        teamReservedFrozenDates =
        [
        DateTimeLib.toTimestamp(2018, 4, 25),
        DateTimeLib.toTimestamp(2018, 7, 25),
        DateTimeLib.toTimestamp(2018, 10, 25),
        DateTimeLib.toTimestamp(2019, 1, 25),
        DateTimeLib.toTimestamp(2019, 4, 25),
        DateTimeLib.toTimestamp(2019, 7, 25),
        DateTimeLib.toTimestamp(2019, 10, 25),
        DateTimeLib.toTimestamp(2020, 1, 25)
        ];
        teamReservedFrozenLimits =
        [
        teamReservedBalance,
        teamReservedBalance - (teamReservedBalance / 8) * 1,
        teamReservedBalance - (teamReservedBalance / 8) * 2,
        teamReservedBalance - (teamReservedBalance / 8) * 3,
        teamReservedBalance - (teamReservedBalance / 8) * 4,
        teamReservedBalance - (teamReservedBalance / 8) * 5,
        teamReservedBalance - (teamReservedBalance / 8) * 6,
        teamReservedBalance - (teamReservedBalance / 8) * 7
        ];
    }

    // fallback function can be used to buy tokens
    function() public payable {
        buy(msg.sender, msg.value);
    }

    function ethBalanceOf(address _owner) public constant returns (uint256){
        return _owner.balance;
    }

    function totalSupply() public constant returns (uint256 totalSupply) {
        return _totalSupply;
    }
}