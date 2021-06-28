pragma solidity ^0.8.4;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/math/SafeMath.sol";

contract SharedWallet is Allowance {
    
    using SafeMath for uint;
    
    event MoneySent(address indexed _beneficiary, uint _amount);
    event MoneyReceived(address indexed _from, uint _amount);

    function withdrawTokens(address payable _to, uint _amount) public ownerAndAllowed(_amount) {
        require(_amount <= address(this).balance);
        if (isOwner()) {
            reduceAllowance(msg.sender, _amount);
        }
        emit MoneySent(_to, _amount);
        _to.transfer(_amount);
    }
    
    function renounceOwnership() public override onlyOwner {
        revert("Can't do that here");
    }
    
    receive() external payable {
        emit MoneyReceived(msg.sender, msg.value);

    }
    
}