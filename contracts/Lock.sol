// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.27; // Solidity 컴파일러 버전을 지정합니다. (^0.8.27 이므로 해당 버전 이상을 사용해야 합니다.)

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract Lock {
    uint public unlockTime; // 잠금 해제 시간
    address payable public owner; // 컨트랙트 소유자 주소

    event Withdrawal(uint amount, uint when); // 이벤트: 출금 시 발생하며, 출금 금액(amount)와 시점(when)을 기록

		// 생성자(컨트랙트 배포 시 실행 됨): 입력 값으로 _unlockTiem(잠금 해제 시간)을 받습니다.
    constructor(uint _unlockTime) payable {
        require( // require(조건): 
            block.timestamp < _unlockTime, // _unlockTiem이 현재시간(block.timestampe)보다 미래의 시간이여야 합니다.
            "Unlock time should be in the future"
        );

        unlockTime = _unlockTime; // unlockTime 저장
        owner = payable(msg.sender); // 컨트랙트 배포 주소(msg.sender)를 소유자로 설정하며 payable 키워드를 통해 컨트랙트 배포 시 이더를 받을 수 있도록 허용합니다.
    }

		// 출금 함수: 
    function withdraw() public {
        // Uncomment this line, and the import of "hardhat/console.sol", to print a log in your terminal
        // console.log("Unlock time is %o and block timestamp is %o", unlockTime, block.timestamp);

        require(block.timestamp >= unlockTime, "You can't withdraw yet"); // 조건: 현재시간이 unlockTime 이상이어얗
        require(msg.sender == owner, "You aren't the owner"); // 호출자가 컨트랙트의 소유자(owner) 여야 함

        emit Withdrawal(address(this).balance, block.timestamp); // 이벤트 발생: 이벤트 호출을 통해 출금 금액과 시간을 기록

        owner.transfer(address(this).balance); // 컨트랙트 잔액을 소유자(owner)에게 전달
    }
}