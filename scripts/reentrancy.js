const hre = require('hardhat')
const ethers = hre.ethers

async function main() {
  const [bidder1, bidder2, hacker] = await ethers.getSigners() //vercnum enq hardhati arjin ereq addr-neru u anun denum

  const ReentrancyAuction = await ethers.getContractFactory("ReentrancyAuction", bidder1) //compil bidder 1-i anunic aukciony
  const auction = await ReentrancyAuction.deploy() // ugharkum enq deployi u anun enq dnum
  await auction.deployed()  // deploy araca arden

  const ReentrancyAttack = await ethers.getContractFactory("ReentrancyAttack", hacker) // hachkeri addresic 
  const attack = await ReentrancyAttack.deploy(auction.address)
  await attack.deployed() // ReentrancyAttack arden deploy egaca

  const txBid = await auction.bid({value: ethers.utils.parseEther("4.0")}) // bider1(default) 4 etheri chisht parse arac wei-i chap bid anum
  await txBid.wait() //spasum a tx-y teghi unena

  const txBid2 = await auction.connect(bidder2). //spasum a auctiony kpni bidder2-in
    bid({value: ethers.utils.parseEther("8.0")}) //8 ether poxancum a
  await txBid2.wait() //tx eghav

  const txBid3 = await attack.connect(hacker). // hima hackery spasum a kpni ira addr-ov attack contracti u 
    proxyBid({value: ethers.utils.parseEther("1.0")}) // u stavka anum 1 ether
  await txBid3.wait() //tx -eghav

  console.log("Auction balance", await ethers.provider.getBalance(auction.address)) // tenanq inchqan pogh ka es pahi drutyamb

  const doAttack = await attack.connect(hacker).attack() // kpnun enq attack contracti attack funkciayin u 
  await doAttack.wait() // skasum enq attacky

  console.log("Auction balance", await ethers.provider.getBalance(auction.address))
  console.log("Attacker balance", await ethers.provider.getBalance(attack.address))
  console.log("Bidder2 balance", await ethers.provider.getBalance(bidder2.address)) // stugum enq balancnery
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })