pragma solidity ^0.8.4;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/math/SafeMath.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract Allowance is Ownable{
    
    using SafeMath for uint;
    
    event AllowanceChanged(address indexed _forWho, address indexed fromWhom, uint _oldAmount, uint _newAmount);
    
    mapping(address => uint) public allowance;

    function isOwner() internal view returns(bool) {
        return owner() == msg.sender;
    }
    
    modifier ownerAndAllowed(uint _amount) {
        require(isOwner() || allowance[msg.sender] >= _amount);
        _;
    }
    
    function addAllowance(address _who, uint _amount) public onlyOwner {
        emit AllowanceChanged(_who, msg.sender, allowance[_who], _amount);
        allowance[_who] = _amount;
    }
    
    function reduceAllowance(address _who, uint _amount) internal {
        emit AllowanceChanged(_who, msg.sender, allowance[_who], allowance[_who].sub(_amount));
        allowance[_who] = allowance[_who].sub(_amount);
    }
}