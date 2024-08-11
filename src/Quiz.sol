// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Quiz{
    struct Quiz_item {
      uint id;
      string question;
      string answer;
      uint min_bet;
      uint max_bet;
   }
    
    mapping(address => uint256)[] public bets;
    uint public vault_balance;

    mapping(address => uint256) public isSolved;
    Quiz_item[] quizzes;


    constructor () {
        Quiz_item memory q;
        q.id = 1;
        q.question = "1+1=?";
        q.answer = "2";
        q.min_bet = 1 ether;
        q.max_bet = 2 ether;
        addQuiz(q);
    }

    function addQuiz(Quiz_item memory q) public {
        require(msg.sender != address(1));
        bets.push();
        quizzes.push(q);
    }

    function getAnswer(uint quizId) public view returns (string memory){
        return quizzes[quizId - 1].answer;
    }

    function getQuiz(uint quizId) public view returns (Quiz_item memory) {
        Quiz_item memory q = quizzes[quizId - 1];
        q.answer = "";
        return q;
    }

    function getQuizNum() public view returns (uint){
        return quizzes.length;
    }
    
    function betToPlay(uint quizId) public payable {
        require(msg.value <= quizzes[quizId - 1].max_bet && msg.value >= quizzes[quizId - 1].min_bet);

        bets[quizId - 1 ][msg.sender] += msg.value;
    }

    function solveQuiz(uint quizId, string memory ans) public returns (bool) {
        if(keccak256(bytes(quizzes[quizId -1].answer)) == keccak256(bytes(ans))) {
            isSolved[msg.sender] = quizId;
            return true;
        }
        else {
            vault_balance += bets[quizId - 1 ][msg.sender];
            bets[quizId - 1][msg.sender] = 0;
            return false;
        }
    }

    function claim() public {
        if(isSolved[msg.sender] > 0) {
            address(msg.sender).call{value : bets[isSolved[msg.sender] - 1 ][msg.sender] * 2}("");
        }
    }

    receive() external payable {}

}
