// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Dappcord is ERC721 {
    uint256 public totalSupply = 0;
    uint256 public totalChannels = 0;
    address public owner;

    //defining the channel
    struct Channel {
        uint256 id;
        string name;
        uint256 cost;
    }
    //created a mapping which gives every key a unique value
    mapping(uint256 => Channel) public channels;
    mapping(uint256 => mapping(address => bool)) public hasJoined;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    constructor(
        string memory _name,
        string memory _symbol
    ) ERC721(_name, _symbol) {
        owner = msg.sender;
    }

    function createChannel(
        string memory _name,
        uint256 _cost
    ) public onlyOwner {
        require(msg.sender == owner);
        //created a channel using struct
        //using mapping giving a unique key to the channel created by struct
        totalChannels++;
        //dynamically giving the unique key to the channels by creating a total channels
        //which count the total number of channels created
        channels[totalChannels] = Channel(totalChannels, _name, _cost);
    }

    function mint(uint256 _id) public payable {
        require(_id != 0);
        require(_id <= totalChannels);
        require(hasJoined[_id][msg.sender] == false);
        require(msg.value >= channels[_id].cost);
        //join channel
        hasJoined[_id][msg.sender] = true;
        //mint nft
        totalSupply++;
        _safeMint(msg.sender, totalSupply);
    }

    function getChannel(uint256 _id) public view returns (Channel memory) {
        return channels[_id];
    }

    function withdraw() public onlyOwner {
        (bool success, ) = owner.call{value: address(this).balance}("");
        require(success, "Withdrawal failed");
    }
}
