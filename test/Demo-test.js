const { expect } = require("chai")
const { ethers } = require("hardhat")

//testov apacucum enq vor interface karanq sarqenq hatuk obyekt u dra mijocov kanchenq mer anhrajesht funkcianery
describe("Demo", function () {
  let owner 
  let demo // stegh enq dnum vor bolor testeric hasaneli lini

  beforeEach(async function () {
    [owner] = await ethers.getSigners() // arajin addresin enq spasum hhati

    const Logger = await ethers.getContractFactory("Logger", owner)
    const logger = await Logger.deploy()
    await logger.deployed() //es pahin unenq deploy arac Loger contracty

    const Demo = await ethers.getContractFactory("Demo", owner)
    demo = await Demo.deploy(logger.address) // argumentum talis enq logger hascen
    await demo.deployed() //es pahin unenq deploy arac Demo contracty
    //console.log(demo) // eqa obyekta demo-n
  })
// skzbic recivy stugenq heto tenanq vor karogh enq stanal te che
  it("allows to pay and get payment info", async function() {
    const sum = 100

    const txData = { 
      value: sum,
      to: demo.address
    }

    const tx = await owner.sendTransaction(txData) //ugharkum enq transakcia verevi tverov qani vor recievy pti ynduni inch ga aranc funkcia nshelu enq grum

    await tx.wait() // spasum enq lini tx-n

    //console.log(tx)
    await expect(tx) 
      .to.changeEtherBalance(demo, sum) // aknkalum enq tvyal kontracti vra tvyal chapi gumari popoxutyun

    const amount = await demo.payment(owner.address, 0) // interfaci payment funkciayin enq dimum vcharoghi hasceyi 0-indexov vcharman masin info

    expect(amount).to.eq(sum) //pti lini havasar a100
  })
})