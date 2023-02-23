const { expect } = require("chai")
const { ethers } = require("hardhat")

describe("Demo", function () {
  let owner
  let other_addr
  let demo

  beforeEach(async function () {
    [owner, other_addr] = await ethers.getSigners()

    const DemoContract = await ethers.getContractFactory("Demo", owner)
    demo = await DemoContract.deploy()
    await demo.deployed()
  })

  async function sendMoney(sender) {//prosto send money anunov funkcia vor mi qani tegh kanchenq 
    const amount = 100
    const txData = { // //stugum enq recieve dra hamar el funkciayi anuny chenq dnum
      to: demo.address,
      value: amount
    } 

    const tx = await sender.sendTransaction(txData)
    await tx.wait();
    return [tx, amount]
  }

  it("shound allow to send money", async function() {
    const [sendMoneyTx, amount] = await sendMoney(other_addr)

    await expect(() => sendMoneyTx) // waffle -ic
      .to.changeEtherBalance(demo, amount);// stugum enq ardyoq demo balancy poxvel a amount chapov

    const timestamp = (   
      await ethers.provider.getBlock(sendMoneyTx.blockNumber)
    ).timestamp //blockchainic stanum enq info transakciayi timestampi masin amboghjov u veragrum enq timstamp popoxakanin

    await expect(sendMoneyTx) //stegh stugum enq ardyoq paid event a emit a linum chisht argumentacayov 
      .to.emit(demo, "Paid")
      .withArgs(other_addr.address, amount, timestamp)
      console.log(sendMoneyTx) // karanq hanenq ughaki cuyc talu hamar manramasnery
  })

  // takiny stugum a kara vladelecy withdraw any contracti poghery
  it("shound allow owner to withdraw funds", async function() {
    const [_, amount] = await sendMoney(other_addr) // en arajin argument ( _ ) -y inqy tx-na vory es testum mez chin hetaqrqrum

    const tx = await demo.withdraw(owner.address)

    await expect(() => tx)
      .to.changeEtherBalances([demo, owner], [-amount, amount]) // stugum a contracti (demo) balansic gumary pakasel a -amount chapov i ogut deploy anoghi (owner) hashvin amount chapov
  })

  // ardyoq urish mek chi kara withdraw ani 
  it("shound not allow other accounts to withdraw funds", async function() {
    await sendMoney(other_addr) // kariq chka {amen angam ugharkum enq poghery qani vor amen angam noric a sagh test anum u pti contracti balancin pogh lini misht} qani vor inqy voch mi gumar pti chta ayl andzi

    await expect(
      demo.connect(other_addr).withdraw(other_addr.address) // conect other_addr anum a vor defaolt owner i poxeren ayl addresic kanchi
    ).to.be.revertedWith("you are not an owner!") //spasum enq merjum funkciayi mejim textov
  })
})