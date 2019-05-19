pragma solidity ^0.5.8;

import "./ERC20Interface.sol";
import "./ROFEXStyle.sol";

contract Pether is ERC20Interface, ROFEXStyle {

    string public symbol;
    string public  name;
    uint8 public decimals;
    uint _totalSupply;
    uint price;

    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;

    constructor() public {
        symbol = "PET";
        name = "Pether";
        decimals = 18;
        _totalSupply = 1000000 * 10**uint(decimals);
        balances[owner] = _totalSupply;
        price = 1;
        emit Transfer(address(0), owner, _totalSupply);
    }

    function totalSupply() public view returns (uint) {
        return _totalSupply.sub(balances[address(0)]);
    }

    function balanceOf(address tokenOwner) public view returns (uint balance) {
        return balances[tokenOwner];
    }

    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }

    function transfer(address to, uint tokens) public returns (bool success) {
        balances[msg.sender] = balances[msg.sender].sub(tokens);
        balances[to] = balances[to].add(tokens);
        emit Transfer(msg.sender, to, tokens);
        return true;
    }

    function approve(address spender, uint tokens) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }

    function transferFrom(address from, address to, uint tokens) public returns (bool success) {
        balances[from] = balances[from].sub(tokens);
        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
        balances[to] = balances[to].add(tokens);
        emit Transfer(from, to, tokens);
        return true;
    }

    // TODO: Save date and price
    function buyPethers(uint amount) public payable {
        require(amount.mul(price) == msg.value);
        require(balanceOf(owner) >= amount);
        require(transfer(msg.sender, amount));
        alterPriceUp();
        transactionCount++;
        recordNewTransaction(price);
    }

    // TODO: Save date and price
    function sellPethers(uint amount) public {
        require(balances[msg.sender] >= amount);
        require(transfer(owner, amount)); // Check if this works ok
        uint amountEther = amount.mul(price).div(10**uint(decimals));
        msg.sender.transfer(amountEther);
        alterPriceDown();
        transactionCount++;
        recordNewTransaction(price);
    }

    function alterPriceUp() private {
        price++;
    }

    function alterPriceDown() private {
        if (price > 0) {
            price--;
        }
    }

}
