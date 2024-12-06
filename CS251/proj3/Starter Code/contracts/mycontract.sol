// SPDX-License-Identifier: UNLICENSED

// DO NOT MODIFY BELOW THIS
pragma solidity ^0.8.17;

import "hardhat/console.sol";

contract Splitwise {
// DO NOT MODIFY ABOVE THIS

// ADD YOUR CONTRACT CODE BELOW
    mapping (address => mapping (address => uint32)) debt;
    mapping (address => mapping (address => bool)) connected;
    mapping (address => address[]) neighbors;
    
    address[] private users;
    mapping (address => bool) joined;
    mapping (address => uint32) totalOwed;
    mapping (address => uint) lastActive;

    function getAddress() public view returns (address) {
        return msg.sender;
    }

    function getUsers() public view returns(address[] memory) {
        return users;
    }

    function getTotalOwed(address user) public view returns(uint32) {
        return totalOwed[user];
    }

    function getLastActive(address user) public view returns(uint) {
        return lastActive[user];
    }

    function getNeighbors(address user) public view returns(address [] memory) {
        return neighbors[user];
    }

    function lookup(address debtor, address creditor) public view returns (uint32) {
        return debt[debtor][creditor];
    }

    function add_IOU(address creditor, uint32 amout, address[] memory cycle) external {
        address debtor = msg.sender;
        lastActive[debtor] = block.timestamp;
        lastActive[creditor] = block.timestamp;

        if (!joined[debtor]) {
            users.push(debtor);
            joined[debtor] = true;
        }

        if (!joined[creditor]) {
            users.push(creditor);
            joined[creditor] = true;
        }

        require(debtor != creditor);

        debt[debtor][creditor] += amout;

        if (!connected[debtor][creditor]) {
            neighbors[debtor].push(creditor);
            connected[debtor][creditor] = true;
        }

        require(cycle.length > 0);

        uint32 minDebt = debt[debtor][creditor];
        for (uint i = 1; i < cycle.length; ++i) {
            address _debtor = cycle[i - 1];
            address _creditor = cycle[i];
            if (minDebt > debt[_debtor][_creditor])
                minDebt = debt[_debtor][_creditor];
        }

        debt[debtor][creditor] -= minDebt;
        for (uint i = 1; i < cycle.length; ++i) {
            address _debtor = cycle[i - 1];
            address _creditor = cycle[i];
            debt[_debtor][_creditor] -= minDebt;
        }
    }
}
