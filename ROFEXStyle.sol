pragma solidity ^0.5.8;

import "./Owned.sol";
import "./SafeMath.sol";

contract ROFEXStyle is Owned {
    using SafeMath for uint;

    struct Transaction {
        uint dateCreated;
        uint price;
    }

    uint transactionCount;
    uint m;
    uint b;
    Transaction[] lastTransactions;

    constructor() public {
        transactionCount = 0;
    }

    function ejecutarRegresion() public {
        require(transactionCount >= 4);
        // y is price, t is dateCreated
        // y = b+m*t
        uint t = 0;
        uint y = 0;
        uint ty = 0;
        uint tt = 0;
        Transaction[] memory lastFourTransactions = getLastFourTransactions();
        for (uint index = 0; index < lastFourTransactions.length; index++) {
            t = t.add(lastTransactions[index].dateCreated);
            y = y.add(lastTransactions[index].price);
            ty = ty.add(lastTransactions[index].dateCreated.mul(lastTransactions[index].price));
            tt = tt.add(lastTransactions[index].dateCreated.mul(lastTransactions[index].dateCreated));
        }
        m = (lastFourTransactions.length.mul(ty).sub((t.mul(y)))).div((lastFourTransactions.length.mul(tt)).sub((t.mul(t))));
        b = y.sub((b.mul(t))).div(lastFourTransactions.length);
    }

    function calcularValorFuturo(uint fecha) public view {

    }

    function comprarMonedaFutura(uint fecha, uint cantidad) public payable {

    }

    function consultarMisComprasFuturas() public view {

    }

    function consultarTodasLasComprasFuturas() public view onlyOwner {

    }

    function ejecutarMisContratos() public {

    }

    function ejecutarTodosLosContratos() public onlyOwner {

    }

    function recordNewTransaction(uint price) internal {
        // We need the last 4 transactions
        // but want to use push on the array
        // which fixed size ones don't have
        lastTransactions.push(Transaction(now, price));
    }

    function getLastFourTransactions() private view returns (Transaction[] memory) {
        uint j = 0;
        Transaction[] memory lastFourTransactions = new Transaction[](4);
        for (uint index = lastTransactions.length.sub(4); index < lastTransactions.length; index++) {
            lastFourTransactions[j] = lastTransactions[index];
            j++;
        }
        return lastFourTransactions;
    }

}
