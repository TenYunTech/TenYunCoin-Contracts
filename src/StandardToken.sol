pragma solidity ^0.4.11;

import './IERC20.sol';
import './SafeMathLib.sol';

contract StandardToken is IERC20 {

    using SafeMathLib for uint256;

    mapping(address => uint256) balances;

    mapping(address => mapping(address => uint256)) allowed;

    function StandardToken() public payable {

    }

    function balanceOf(address _owner) public constant returns (uint256 balance) {
        return balances[_owner];
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        return transferInternal(msg.sender, _to, _value);
    }

    function transferInternal(address _from, address _to, uint256 _value) internal returns (bool success) {
        require(_value > 0 && balances[_from] >= _value);
        balances[_from] = balances[_from].sub(_value);
        balances[_to] = balances[_to].add(_value);
        Transfer(_from, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value > 0 && allowed[_from][msg.sender] >= _value && balances[_from] >= _value);
        balances[_from] = balances[_from].sub(_value);
        balances[_to] = balances[_to].add(_value);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
        Transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address _spender, uint256 _value);
}