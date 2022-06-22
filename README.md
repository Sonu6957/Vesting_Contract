# Vesting Contract

Vesting, also called token lockup period, refers to a period of time in which the tokens sold in the pre-sale of ICO stage are prevented from being sold for a specific period of time.

This project demonstrates a basic Vesting process. It comes with a sample contract, deployment script that deploys that contract which also acts as an example of a task implementation, which simply displays the address of the contract deployment.
## Steps to Interact with the project
1. Clone Repo
2. Install hardhat using npm
3. Read more about Hardhat here: https://hardhat.org/

## Compiling & Running the script
```
npx hardhat compile
npx hardhat run scripts/deploy.js 
```
## Steps for testing
### Assumptions in the contract(which can be changed as per the requirement).  
  Assumption 1. We followed the linear vesting approach.  
Assumption 2. Investors are divided into 3 categories:- Advisors, Partnerships and mentors.  
Assumption 3. Cliff duration is 2 months.  
Assumption 4. Vesting duration is 22 months.  
### Testing
1. Deploy NewToken contract 
2. Deploy the Vesting contract using the address of deployed NewToken contract
3. Using different account(since admin cannot invest) buy tokens using invest function.
4. After the cliff period gets over, start claiming your tokens. 
