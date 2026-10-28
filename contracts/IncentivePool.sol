// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/access/Ownable.sol";

contract IncentivePool is Ownable {
    mapping(address => uint256) public rewards;

    event Funded(address indexed from, uint256 amount);
    event RewardAssigned(address indexed to, uint256 amount);
    event RewardClaimed(address indexed to, uint256 amount);

    receive() external payable {
        emit Funded(msg.sender, msg.value);
    }

    function assignReward(address to, uint256 amount) external onlyOwner {
        rewards[to] += amount;
        emit RewardAssigned(to, amount);
    }

    function claimReward() external {
        uint256 amt = rewards[msg.sender];
        require(amt > 0, "IncentivePool: no rewards");
        rewards[msg.sender] = 0;
        (bool ok, ) = msg.sender.call{value: amt}("");
        require(ok, "IncentivePool: transfer failed");
        emit RewardClaimed(msg.sender, amt);
    }

    function deposit() external payable {}
}
