// dasic deploy uzum enq metamaski het hamagorcakcutyuny stugenq
// https://www.youtube.com/watch?v=igPcdziCkWU&list=PLWlFXymvoaJ_0ok740kLXTn5qn-i1UnYr&index=13  1jam 15ropeyic nayel

// arecinq npx hardhat node miacrecinq hardhat local blokchayne node-y
// heto erkrord wsl-um arecinq npx hardhat run scripts/deploydasic.js
// berec hetevyal erku hascenery 0x5FbDB2315678afecb367f032d93F642f64180aa3   
// 0xa16E02E87b7454126E5E10d957A927A7F5B5d2be -sa erc token-i hascena
// bacum enq meta masky cancy dnum enq localhost 8545
//heto import enq anum hashiv hardhati nodic privat key dnelov chisht teghum metamaski vra berum a 10000 eth

const hre = require('hardhat')
const ethers = hre.ethers

async function main() {
  const [signer] = await ethers.getSigners()

  const Erc = await ethers.getContractFactory('MShop', signer)
  const erc = await Erc.deploy()
  await erc.deployed()
  console.log(erc.address)
  console.log(await erc.token())
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });