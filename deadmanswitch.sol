pragma solidity ^0.6.0;
contract DeadManSwitch
{
    address payable private beneficiary;
    uint256 private blockNumber;
    address payable private owner;
    constructor(address payable _to) public payable
    {
        owner=msg.sender;
        beneficiary=_to;
        blockNumber=block.number;
    }
    
    function checkIn() public ownership payable
    {
        blockNumber=block.number;
        address(this).call.value(msg.sender.balance);
    }
    
    function changeOwnership(address payable newOwner) public ownership
    {
        owner=newOwner;
    }
    
    function changeBeneficiary(address payable _change) public ownership
    {
        beneficiary=_change;
    }
    
    function getBalance() public view ownership returns(uint)
    {
        //address payable self = address(this);
        uint256 bal = address(this).balance;
        return bal;
    }
    
    function claimOwnership() public 
    {
        require((blockNumber+10)<block.number);
        require(msg.sender==beneficiary);
        owner=beneficiary;
    }
    
    function emptyFunds(address payable heir) public payable ownership
    {
        heir.transfer(address(this).balance);
    }
    
    function sendFunds(address payable destination,uint amount) public payable ownership
    {
        require(amount<=address(this).balance);
        destination.transfer(amount);
    }
    
    modifier ownership()
    {
        require(msg.sender==owner);
        _;
    }
}
