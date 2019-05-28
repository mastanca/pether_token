pragma solidity ^0.5.8;
// To return array of futureTransactions to client
pragma experimental ABIEncoderV2;

import "./Owned.sol";
import "./SafeMath.sol";

contract ROFEXStyle is Owned {
    using SafeMath for uint;

    struct Transaction {
        uint dateCreated;
        uint price;
    }

    struct FutureTransaction {
        uint price;
        uint qty;
        uint date;
        bool ready;
        bool executed;
        address buyer;
    }

    uint transactionCount;
    uint m;
    uint b;
    Transaction[] lastTransactions;
    FutureTransaction[] futureTransactions;

    constructor() public {
        transactionCount = 0;
        m = 0;
        b = 0;
    }

    function ejecutarRegresion() public {
        require(
            transactionCount >= 4,
            "Not enough transactions"
            );
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

    function calcularValorFuturo(uint fecha) public view returns (uint) {
        return b.add(m.mul(fecha));
    }

    function comprarMonedaFutura(uint fecha, uint cantidad) public payable {
        require(
            fecha < now.add(90 days),
            "Can't buy more than 90 days ahead"
            );
        require(
            fecha > now,
            "Parameter 'fecha' must be in the future"
        );
        uint futurePrice = calcularValorFuturo(fecha);
        futureTransactions.push(FutureTransaction(futurePrice, cantidad, fecha, false, false, msg.sender));
    }

    function consultarMisComprasFuturas() public view returns (FutureTransaction[] memory){
        FutureTransaction[] memory futures = getFuturesFor(msg.sender);
        for (uint index = 0; index < futures.length; index++) {
            if (futures[index].date < now) {
                futures[index].ready = true;
            }
        }
        return futures;
    }

    /**
        Ok so, solidity doesn't allow us to return dynamic sized arrays
        we have to loop the first time to get the actual size of the returned array
        and then another time to build it.
        Also there's is no push for local arrays, so we need the reset of count.
        Would love to use a mapping(address => FutureTransaction[]) but we need all of them
        for the owner to execute consultarTodasLasComprasFuturas.
     */
    function getFuturesFor(address buyer) private view returns (FutureTransaction[] memory) {
        uint count = 0;
        for (uint index = 0; index < futureTransactions.length; index++) {
            if (futureTransactions[index].buyer == buyer) {
                count++;
            }
        }
        FutureTransaction[] memory futures = new FutureTransaction[](count);
        count = 0;
        for (uint index = 0; index < futureTransactions.length; index++) {
            if (futureTransactions[index].buyer == buyer) {
                futures[count++] = futureTransactions[index];
            }
        }
        return futures;
    }

    /**
     * Similar to getFuturesFor(...), but holded transactions are the ones
     * ready but not yet executed
    */
    function getHoldedFor(address owner) private view returns (FutureTransaction[] memory) {
        uint count = 0;
        for (uint index = 0; index < futureTransactions.length; index++) {
            FutureTransaction memory ft = futureTransactions[index];
            if (ft.buyer == owner && ft.date < now && !ft.executed) {
                count++;
            }
        }
        FutureTransaction[] memory futures = new FutureTransaction[](count);
        count = 0;
        for (uint index = 0; index < futureTransactions.length; index++) {
            FutureTransaction memory ft = futureTransactions[index];
            if (ft.buyer == owner && ft.date < now && !ft.executed) {
                futures[count++] = futureTransactions[index];
            }
        }
        return futures;
    }
    
    function consultarTodasLasComprasFuturas() public view onlyOwner returns (FutureTransaction[] memory) {
        return getHoldedFor(msg.sender);
    }

    function ejecutarMisContratos() public {
        FutureTransaction[] memory transactions = getHoldedFor(msg.sender);
        for (uint i = 0; i < transactions.length; i++) {
            // TODO: execute transaction (how??)
        }
    }

    function ejecutarTodosLosContratos() public onlyOwner {
        // TODO: Implement me
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

