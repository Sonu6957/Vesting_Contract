// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // We get the contract to deploy
  const ERC20contract = await hre.ethers.getContractFactory("NewToken");
  const ERC20deploy = await ERC20contract.deploy();
  

  await ERC20deploy.deployed();
  const Vestingcontract = await hre.ethers.getContractFactory("Vesting");
  const Vestingdeploy = await Vestingcontract.deploy(ERC20deploy.address);
  await Vestingdeploy.deployed();

  console.log("ERC20 token deployed to:", ERC20deploy.address);
  console.log("Vesting Contract deployed to:", Vestingdeploy.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
