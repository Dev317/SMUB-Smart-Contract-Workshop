// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.11;

interface IERC20 {
    // returns total token supply
    function totalSupply() external view returns(uint256);

    // returns the number of tokens hold by a particular address
    function balanceOf(address _owner) external view returns(uint256 balance);

    // Transfers _value amount of tokens to address _to, and MUST fire the Transfer event. 
    // The function SHOULD throw if the message caller’s account balance does not have enough tokens to spend.
    function transfer(address _to, uint256 _value) external returns(bool success);

    // once approved, it is used to transfer tokens to spender, return true if the transaction is successful
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);

    // owner approves a spender to use the token, return true if the approval is successful
    function approve(address _spender, uint256 _value) external returns(bool success);

    
    // Returns the amount which _spender is still allowed to withdraw from _owner.
    function allowance(address _owner, address _spender) external view returns(uint256 remaining);

    // Used for logging
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

}

contract SMUBToken is IERC20 {
    mapping (address => uint256) _balances;

    // approval mapping
    mapping (address => mapping(address => uint256)) _allowed;

    // name, symbol, decimal
    
    string public name = "SMUBToken";
    string public symbol = "SBT";
    uint public decimals = 10;

    // initial supply
    uint256 private _totalSupply;

    // owner address
    address public _contractOwner;

    constructor() {
        _contractOwner = msg.sender;
        _totalSupply = 10000;
        _balances[_contractOwner] = _totalSupply;
    }

    function totalSupply() external view returns(uint256) {
        return _totalSupply;
    }

    function balanceOf(address _owner) external view returns(uint256 balance) {
        return _balances[_owner];
    }
 
    function transfer(address _to, uint256 _value) external returns(bool success) {
        require(_value > 0, "Value should not be zero!");
        require(_balances[msg.sender] >= _value, "Insufficient balance!");

        _balances[_to] += _value;
        _balances[msg.sender] -= _value;
        _totalSupply -= _value;

        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) external returns(bool success) {
        require(_value > 0, "Value should not be zero!");
        require(_balances[msg.sender] >= _value, "Insufficient balance!");

        _allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success) {
        require(_value > 0, "Value should not be zero!");
        require(_balances[_from] >= _value, "Insufficient balance!");
        require(_allowed[_from][_to] >= _value, "Insufficient allowance!");

        _balances[_to] += _value;
        _balances[_from] -= _value;
        _allowed[_from][_to] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }

    function allowance(address _owner, address _spender) external view returns(uint256 remaining) {
        return _allowed[_owner][_spender];
    }

    function resupply() public payable{
        if (_balances[_contractOwner] == 0) {
            _totalSupply += 10000;
            _balances[_contractOwner] += 10000;
        }
    }
}