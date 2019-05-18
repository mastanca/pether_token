pragma solidity ^0.5.8;

import "./Owned.sol";

contract ROFEXStyle is Owned {
    uint transactionCount;

    constructor() public {
        transactionCount = 0;
    }

    function ejecutarRegresion() public view {
        require(transactionCount >= 4);
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

}
