pragma solidity ^0.4.11;

import './LockableToken.sol';

contract TradeableToken is LockableToken {

    address public publicOfferingHolder;

    uint256 internal baseExchangeRate;

    uint256 internal earlyExchangeRate;

    uint internal earlyEndTime;

    function TradeableToken() public payable {

    }

    function buy(address _beneficiary, uint256 _weiAmount) internal {
        require(_beneficiary != 0x0);
        require(publicOfferingHolder != 0x0);
        require(earlyEndTime != 0x0 && baseExchangeRate != 0x0 && earlyExchangeRate != 0x0);
        require(_weiAmount != 0x0);

        uint256 rate = baseExchangeRate;
        if (now <= earlyEndTime) {
            rate = earlyExchangeRate;
        }
        uint256 exchangeToken = _weiAmount.mul(rate);
        exchangeToken = exchangeToken.div(1 * 10 ** 10);

        publicOfferingHolder.transfer(_weiAmount);
        super.transferInternal(publicOfferingHolder, _beneficiary, exchangeToken);
    }
}