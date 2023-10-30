// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

import {Operatable} from "../utilities/Operatable.sol";

import {ICharityToken} from "../interfaces/ICharityToken.sol";

contract CharityToken is ICharityToken, ERC20, Operatable {
    constructor() ERC20("Charity Token", "CHR") {}

    function mint(address _to, uint256 _amount) external onlyOperator {
        _mint(_to, _amount);
    }

    function burn(address _from, uint256 _amount) external onlyOperator {
        _burn(_from, _amount);
    }
}
