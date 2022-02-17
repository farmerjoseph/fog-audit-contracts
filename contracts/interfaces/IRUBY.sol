// SPDX-License-Identifier: MIT

pragma solidity ^0.8.11;

interface IRUBY {
  function mint(address to, uint256 amount) external;
  function burn(address from, uint256 amount) external;
  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}