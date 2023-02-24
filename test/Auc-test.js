const { expect } = require("chai")
const { ethers } = require("hardhat")

describe("AucEngine", function () {
  let owner // hanum enq arajin ereq hhat acc
  let seller
  let buyer
  let auct

  beforeEach(async function () {
    [owner, seller, buyer] = await ethers.getSigners()

    const AucEngine = await ethers.getContractFactory("AucEngine", owner)
    auct = await AucEngine.deploy()
    await auct.deployed()
  })

  it("sets owner", async function() { // ardyoq chisht owner a deploy eghel
    const currentOwner = await auct.owner()
    expect(currentOwner).to.eq(owner.address)
    //console.log(currentOwner)
  })

  //konkret block numberi bn-timestampna hanum
  async function getTimestamp(bn) {
    return (//vobshe takinov karam blokic lyuboy info stanam, stegh menak timestamp a
      await ethers.provider.getBlock(bn) //provider special objekt v ethers vori mijocov kpnum enq konkret blockchainin
    ).timestamp
  }

  //verevi globali tak local describe konkret createAuction prosto tramabanaka xmbavorman hamar  
  describe("createAuction", function () {
    //stugum enq ardyoq aukcion chisht steghcvuma u steghcvuma chisht parametrerov
    it("creates auction correctly", async function() {
      const duration = 60
      const tx = await auct.createAuction(
        ethers.utils.parseEther("0.0001"),// parseEther -gorciqov argumentum grum enq ether-ov inqy chisht wei a sarqum
        3, //vayrkayanum esqan wei a korcnum
        "fake item",
        duration
      )

      const cAuction = await auct.auctions(0) // Promise, bolor es tx-neri, steghcumneri, u kardacumneri hamar partadir pti await grel demy  
      expect(cAuction.item).to.eq("fake item")
      //console.log(cAuction)
      //console.log(tx)
      const ts = await getTimestamp(tx.blockNumber)//timestamp pti konkret blokchainic kardacvi u dra hamar steghcvum a 24 toghi getTimestamp func-y
      expect(cAuction.endsAt).to.eq(ts + duration)
    })
  })

  // veradardznum a nor promis ayn milis vor pti spasi
  function delay(ms) {
    return new Promise(resolve => setTimeout(resolve, ms))
  }

  //gnum 
  describe("buy", function () {
    it("allows to buy", async function() {
      await auct.connect(seller).createAuction(// qani vor amen angam norna bacum stegh stipvac noric aukcion enq steghcum
        ethers.utils.parseEther("0.0001"),
        3,
        "fake item",
        60
      )

      this.timeout(5000) // 5s, anum enq nrahamar mer testirovaniayi frameworky mocha-n poqr timeout uni u sxal chta timouti patcharov(qani vor auction 60 v. timer enq drel) this-konkret testna, timeoutnel asum 5v, avelic trnuma eli 
      await delay(1000) // uzum em spasem 1 v minchev testi i8akanacumy

      const buyTx = await auct.connect(buyer). //urish accountic
        buy(0, {value: ethers.utils.parseEther("0.0001")}) //gnum enq tx-ov

      const cAuction = await auct.auctions(0) //noric enq kardum aukciony
      const finalPrice = cAuction.finalPrice //verjnakan giny gtnelu hamar
      await expect(() => buyTx).
        to.changeEtherBalance( //waffle-ov
          seller, finalPrice - Math.floor((finalPrice * 10) / 100)
        )
        // waffle ic, uzum em stugem emit eghac event-i tvyalnery
      await expect(buyTx)
        .to.emit(auct, 'AuctionEnded')
        .withArgs(0, finalPrice, buyer.address)

      //sxal-y stugum ete apranqy arnvela dranic heto nuyn apranqy el hnaravor chi arnel u kta stopped
        await expect(
        auct.connect(buyer).
          buy(0, {value: ethers.utils.parseEther("0.0001")})
      ).to.be.revertedWith('stopped!')
    })
  })
})
