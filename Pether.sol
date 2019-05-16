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
}
