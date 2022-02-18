// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.11;

contract Voting {

    struct Degen {
        string _name;
        address _address;
    }
    mapping (address => bool) public _degenTracking;

    address _contractOwner;
    string public _decisionName; 
    int8 public _countYesVote;
    mapping (address => bool) public _voters;
    uint256 public _fundingAmount;

    constructor(string memory _decision) {
        _contractOwner = msg.sender;
        _decisionName = _decision;
        _countYesVote = 0;
    }

    modifier onlyOwner {
      require(msg.sender == _contractOwner);
      _;
    }

    function getDecisionName() public view returns(string memory decision) {
        return _decisionName;
    }

    function setDecisionName(string memory _newDecisionName) public onlyOwner {
        _decisionName = _newDecisionName;
    }

    function allowVoter(address _member) public onlyOwner {
        // do some checkings
        _voters[_member] = true;
    }

    // payable function needs non-zero eth value and will be transfered to contract balance
    function voteYesDecision() public payable {
        require(_voters[msg.sender] == true, "Not an allowed member");
        require(msg.value > 1, "Insufficient ammount!");

        _countYesVote += 1;
        _fundingAmount += msg.value;
    }

    function getContractBalance() public view returns (uint256 ) {
       return address(this).balance;
    }

    modifier banDegens {
        require(_degenTracking[msg.sender] == false);
        _;
    }

    function listDegen(address _address, string memory _name) public {
        Degen memory _newDegen = Degen(_name, _address);
        _degenTracking[_newDegen._address] = true;
    }
}