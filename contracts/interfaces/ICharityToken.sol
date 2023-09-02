// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface ICharityToken is IERC20 {
    function mint(address _to, uint256 _amount) external;

    function burn(address _from, uint256 _amount) external;
}
