pragma solidity >=0.4.22 <0.6.0;

contract ChoiHo {
    enum HoState {SETUP, JOINING, VOTING}
    HoState currentState = HoState.SETUP;
    uint balance;
    uint numberOfUser;
    uint currentNumberUser = 0;
    uint numberOfVoted = 0;
    uint maxVoted = 0;
    
    mapping(address => uint) addressToId;
    mapping(uint => address payable) idToAddress;
    mapping(uint => uint) userState;
    mapping(uint => string) userMessage;
    mapping(uint => uint) voteNumber;
    
    function setup(uint _balance, uint _numberOfUser) public {
        require(currentState == HoState.SETUP);
        balance = _balance;
        numberOfUser = _numberOfUser;
        currentState = HoState.JOINING;
    }

    function getCurrentState() public view returns (HoState, uint, uint) {
        return (currentState, balance, numberOfUser);
    }
   
    function join(string memory _message) public  {
        require(currentState == HoState.JOINING);
        addressToId[msg.sender] = currentNumberUser;
        userMessage[currentNumberUser] = _message;
        idToAddress[currentNumberUser] = msg.sender;
        currentNumberUser++;
        if (currentNumberUser == numberOfUser) {
            currentState = HoState.VOTING;
        }
    }
    
    function currentVotable() public view returns (uint[] memory) {
        uint[] memory users;
        uint num = 0;
        for(uint i = 0; i < numberOfUser; i++) {
            if (userState[i] == 1) {
                users[num] = i;
                num++;
            }
        }
        return users;
    }
    
    function vote(uint _userId) public payable {
        require(userState[_userId] == 1);
        voteNumber[_userId]++;
        if (voteNumber[_userId] > voteNumber[maxVoted])
            maxVoted = _userId;
        numberOfVoted++;
        if (numberOfVoted == numberOfUser) {
            payWin();
        }
    }
    
    function payWin() private {
        idToAddress[maxVoted].transfer(balance * numberOfUser);
        currentNumberUser--;
        userState[maxVoted] = 2;
        clearVote();
    }
    
    function clearVote() private {
        numberOfVoted = 0;
        maxVoted = 0;
        for(uint i = 0; i < numberOfUser; i++) {
            voteNumber[i] = 0;
        }
        if (currentNumberUser == 0) clearAll();
    }
    
    function clearAll() private {
        for(uint i = 0; i < numberOfUser; i++) {
            userState[i] = 0;
            userMessage[i] = "";
            voteNumber[i] = 0;
        }
        balance = 0;
        numberOfUser = 0;
        currentNumberUser = 0;
        currentState = HoState.SETUP;
    }
}
