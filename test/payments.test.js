const { expect } = require("chai")
const { ethers } = require("hardhat")
//nkaragrum enq mer kontracty ev funkcian vori mej testery grvuma
describe("Payments", function(){
    let acc1 // obyavlayem vor mnacac testeric el hasaneli linen
    let acc2
    let payments
//cankacac testic araj qani vor HHati jamanakavor blockchaynum a grveluvory linelu qani testa anum u jnjvuma
    beforeEach(async function(){
        [acc1, acc2] = await ethers.getSigners() //massivum teghavorum enq (20hatic) arajin erku Hhati demo accountnery = signer  
        const Payments = await ethers.getContractFactory("Payments", acc1) // stanum enq compile eghac smart contracti masin eghac info u arajin hashveham Hhatic vori anunic el deploy enq anelu ed contracty
        payments = await Payments.deploy()// deployi enq ugharkum. payments -um pahum enq hatuk obyekt vori mijocov smart-i het kshpvenq
        await payments.deployed() // spasum enq minchev deploy ani
        console.log(payments.address)
    })
//takiny arden bun testna, funkciayi mej grum enq inch vor test enq uzum anenq 
    it("should be deployed", async function(){
        expect(payments.address).to.be.properAddress;// stugum enq addresi chshtutyuny. waffle enq ogtagorcum https://ethereum-waffle.readthedocs.io/en/latest/matchers.html
    })
// hima stugum enq vor deployed arac contracti currentBalance funkcian chishta u es pahin ira mej 0 eth a    

    it("should have 0 ether by default", async function(){
        const balance = await payments.currentBalance()//kokret funkciayi chisht anuny
        expect(balance).to.eq(0)// asum enq vor balancy pti o lini u ancnuma sagh
        console.log(balance)       
    })
// stugum enq pay funkcian
    it("should be possible to send funds", async function(){
        //const tx= await payments.pay("hello Sergey", { value: 100}) //ugharkum enq acc1-ic by default tx u massage 100wei-ov
        const tx= await payments.connect(acc2).pay("hello Sergey", { value: 100}) //ugharkum enq acc2-ic qani vor arajiny contractna deploy arel
        

        await expect(() => tx)
        .to.changeEtherBalances([acc2,payments],[-100,100]) // waffle tuyl atalis senc tst anel u stugel mi qani acc- popoxutyunnery takiny aveli parzna

        /*await expect(() => tx)
        .to.changeEtherBalance(acc2,-100) // waffle tuyl atalis senc tst anel u stugel ardyoq acc2-ic 100 wei pakasec
        */

        await tx.wait() //spasum enq katarvi

        const balance = await payments.currentBalance() // stugum enq deployed contr-i curent balancy
        console.log(balance)

    })

})