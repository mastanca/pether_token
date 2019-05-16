pragma solidity ^0.5.8;

import "./ERC20Interface.sol";
import "./Owned.sol";
import "./SafeMath.sol";

contract Pether is ERC20Interface, Owned {
    using SafeMath for uint;

    string public symbol;
    string public  name;
    uint8 public decimals;
    uint _totalSupply;

    mapping(address => uint) balances;

    constructor() public {
        symbol = "PET";
        name = "Pether";
        decimals = 18;
        _totalSupply = 1000000 * 10**uint(decimals);
        balances[owner] = _totalSupply;
        emit Transfer(address(0), owner, _totalSupply);
    }
}
