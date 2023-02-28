const { expect } = require("chai")
const { ethers } = require("hardhat")
const tokenJSON = require("../artifacts/contracts/Erc.sol/MCSToken.json") // abi-n dostup enq stanum

describe("MShop", function () {
    let owner
    let buyer
    let shop
    let erc20 // contract vor block chain um deploy arvac um nkatmamb karanq kanchenq bolor en funkcianer vornq kan abi -um nayir nerqev erb arjeq a stanum

    beforeEach(async function() {
      [owner, buyer] = await ethers.getSigners() //arajin hashivner

      const MShop = await ethers.getContractFactory("MShop", owner)
      shop = await MShop.deploy() // argument chka qani vor constructorum arg chka
      await shop.deployed() //deploy arvac prcaca

      //contract vor block chain um deploy arvac um nkatmamb karanq kanchenq bolor en funkcianer vornq kan abi -um
      erc20 = new ethers.Contract(await shop.token(), tokenJSON.abi, owner)
    })

    it("should have an owner and a token", async function() {
      expect(await shop.owner()).to.eq(owner.address) //stugum enq chish hascen deploy eghela

      expect(await shop.token()).to.be.properAddress // stugum enq chisht token obyekty, verjiny asuma stugi ardyoq inch vor hasce ka vortev tokeni chshgrit hascen djvar voroshel
      
    })

    // ardyoq karum enq arnenq
    it("allows to buy", async function() {
      const tokenAmount = 3

      const txData = {
        value: tokenAmount,
        to: shop.address
      }

      const tx = await buyer.sendTransaction(txData) //steghcum enq tranzakcia kanchum enq
      await tx.wait() //spasum enq lini

      expect(await erc20.balanceOf(buyer.address)).to.eq(tokenAmount) //ogtagorcum enq abi um funkcian, tx-ugharkeluc heto stugum em ardyoq arajacel en dranq ira balancum 

      await expect(() => tx).
        to.changeEtherBalance(shop, tokenAmount) //stugum enq xanuti hascein pogh nstec te che

      await expect(tx)
        .to.emit(shop, "Bought") // sob anuny
        .withArgs(tokenAmount, buyer.address) // ardyoq sobit cnvec es argumentic
    }) 
// ardyoq karum enq caxel
    it("allows to sell", async function() { 
      const tx = await buyer.sendTransaction({ //qani vor maqur teghic a mihat skzbic arnum enq 3 token
        value: 3,
        to: shop.address
      })
      await tx.wait()

      const sellAmount = 2 //vor caxenq

      const approval = await erc20.connect(buyer).approve(shop.address, sellAmount) //uzum enq vor bayery caxi aprove stana

      await approval.wait()// spasuum enq dobro

      const sellTx = await shop.connect(buyer).sell(sellAmount) //caxum enq

      expect(await erc20.balanceOf(buyer.address)).to.eq(1) //balance stugum pti lini 1= 3-2

      await expect(() => sellTx).
        to.changeEtherBalance(shop, -sellAmount) // xanuti balasic hanum enq 2

      await expect(sellTx)
        .to.emit(shop, "Sold")
        .withArgs(sellAmount, buyer.address) // es el emity stugum enq
    })
})
