// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

contract hotelRoom {
enum RoomState{
    Available,
    Booked,
    Paid,
    Checkedin,
    Checkedout,
    Refunded,
    CancelledAfterCheckin, 
    CancelledBeforeCheckin
}

event RoomBooked(address indexed customer);
event RoomPaid(address indexed customer);
event RoomCheckedin(address indexed customer);
event RoomCheckedOut(address indexed customer);
event RoomRefunded (address indexed customer);
event RoomCancelledAfterCheckIn (address indexed customer);
event RoomCancelledBeforeCheckIn (address indexed customer);



uint256 public roomPrice = .5 ether;
address public owner = msg.sender;
address public customer;
RoomState public roomState;

modifier onlyOwner() {
    require(msg.sender == owner,"Only owner can call this function");
    _;
}

modifier onlyCustomer() {
    require(msg.sender == customer,"Only customer can call this function");
    _;
}


constructor() {
    roomState = RoomState.Available;
}




function bookRoom() external payable onlyOwner {
require (roomState == RoomState.Available, "people fucking in this one rn");
require (msg.value >= roomPrice, "if you broke dont book");

roomState = RoomState.Booked;
customer = msg.sender;

emit RoomBooked(msg.sender);

}



function payForRoom() external payable onlyCustomer {
    require (roomState == RoomState.Booked, "people fucking in this one rn");
    require (msg.value >= roomPrice, "if you broke dont book");

    roomState = RoomState.Paid;

emit RoomPaid(msg.sender);

}


function checkIn() external onlyCustomer {
    require (roomState == RoomState.Paid, "people fucking in this one rn");

    roomState = RoomState.Checkedin;

    emit RoomCheckedin(msg.sender);

}



function checkedOut() external onlyCustomer {
    require (roomState == RoomState.Checkedin, "people fucking in this one rn");
    
    roomState = RoomState.Checkedout;
    
    emit RoomCheckedOut(msg.sender);

}



 function refund() external onlyOwner {
require (roomState == RoomState.Paid || roomState == RoomState.Checkedin, "Room is Non-eligible for Refund GET IN THE ROOM");

roomState = RoomState.Refunded;
payable (customer).transfer(roomPrice);

emit RoomRefunded(msg.sender);
 
 }
 
 
 
 
 function CancelledAfterCheckin() external onlyCustomer {
    require (roomState == RoomState.Checkedin || roomState == RoomState.Paid, "Room is Non-eligible for cancellation before check-in");
    
    roomState = RoomState.CancelledAfterCheckin;
    payable(customer).transfer(roomPrice);

    emit RoomCancelledAfterCheckIn(msg.sender);

 }

 function CancelledBeforeCheckIn() external onlyCustomer{
    require (roomState == RoomState.Checkedin, "Room is Non-eligible for cancellation before check-in");

    roomState = RoomState.CancelledBeforeCheckin;
    payable(customer).transfer(roomPrice);

    emit RoomCancelledBeforeCheckIn(msg.sender);

 }
 
 
}
