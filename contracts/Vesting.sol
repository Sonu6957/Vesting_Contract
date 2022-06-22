// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
contract Vesting{

    struct Investor{
        address investoraddress;
        string role;              //i.e. Advisor,Partnerships,Mentor  
        uint investedTokens;     //equivalent token invested for the amount.
        uint maturity;          //expiration
        uint token_claimed;     //claimed tokens
    }

    uint cliff=60 days;
    uint reclaimDuration = 22*30 days;

    IERC20 token;
    uint public totalSupply;

    uint public priceOfToken = 1000;
    
    address admin;

    constructor(IERC20 tokenaddress){
        token = tokenaddress;
        admin = msg.sender;
        totalSupply = token.totalSupply();
        reserveforAdvisor = (5*(totalSupply)/100);                  //Initial reserve during TGE
        reserveforPartnerships = (10*(totalSupply)/100);
        reserveforMentors = (7*(totalSupply)/100);
    }

    mapping(address=>Investor) public investors;
    uint public reserveforAdvisor;    
    uint public reserveforPartnerships;
    uint public reserveforMentors;

    function tokenCalculator(uint amount) public view returns(uint){            //To calculate the no. of tokens 
        return amount/priceOfToken;                                             // for a given amount
    }

    function balanceReserveAmount(string memory role,uint amount) private{              //for balancing the reserve Amount(after a claim)
        if(keccak256(bytes(role))==keccak256(bytes("Advisor")))
            reserveforAdvisor-=amount;
        else if(keccak256(bytes(role))==keccak256(bytes("Partnerships")))
            reserveforPartnerships-=amount;
        else
            reserveforMentors-=amount; 
    }    

    function selectionOfreserve(string memory role) public view returns(uint){              //selection of reserve 
        if(keccak256(bytes(role))==keccak256(bytes("Advisor")))                             //based on role
            return reserveforAdvisor;
        else if(keccak256(bytes(role))==keccak256(bytes("Partnerships")))
            return reserveforPartnerships;
        else
            return reserveforMentors; 
    }

    function  Invest(string memory role) payable public {                   //Invest function
        uint amount_invested = msg.value;
        require(msg.sender!= admin,"Admin cannot invest");
        require(amount_invested!=0,"Amount not specified");
        uint equivalentTokens = tokenCalculator(amount_invested);
        investors[msg.sender]=Investor(msg.sender,role,equivalentTokens,block.timestamp+cliff,0);
    }

    function claim() public{                                                                 //to claim
        require(investors[msg.sender].investedTokens!=0,"You are not an investor");
        Investor storage investor = investors[msg.sender];
        string memory role = investor.role;
        uint reserve = selectionOfreserve(role);
        require(reserve>0,"No token left");
        uint presentTime=block.timestamp;
        require(presentTime>investor.maturity,"Your amount is locked");
        uint claimableAmount;
        if(presentTime>(investor.maturity+reclaimDuration)){
            claimableAmount=investor.investedTokens;
        }
        else{
            claimableAmount=(investor.investedTokens)*((presentTime-investor.maturity)/(reclaimDuration));
            }        
        token.transfer(msg.sender,claimableAmount);
        investor.token_claimed+=claimableAmount;
        investor.investedTokens-=claimableAmount;
        balanceReserveAmount(investor.role,claimableAmount);
    }

    
    
}