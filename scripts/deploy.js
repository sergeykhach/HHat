const hre = require('hardhat');
const ethers = hre.ethers;
const fs = require('fs');
const path = require('path');

async function main() {  // stegh karanq mi angmaic shat contract deploy anenq***
  if (network.name === "hardhat") { // uzum enq hardhati teghy local host ogtagorcenq, vor amen anjateluc chjnjvi
    console.warn(
      "You are trying to deploy a contract to the Hardhat Network, which" +
        "gets automatically created and destroyed every time. Use the Hardhat" +
        " option '--network localhost'"
    );
  }

  const [deployer] = await ethers.getSigners()  // hashivnery

  console.log("Deploying with", await deployer.getAddress()) //hascen enq vercnum vortegh deploy a anum

  const DutchAuction = await ethers.getContractFactory("DutchAuction", deployer) //contracty vori het uzum enq ashxatenq compile 
  const auction = await DutchAuction.deploy(
    ethers.utils.parseEther('2.0'),
    1,
    "Motorbike"
  ) // deploy enq anum 3 arg-erov vonc constructori mej
  await auction.deployed() //spasum enq deploy lini 

  //*** hetkaranq stegh poxancenq 
// stegh asum em vor mer deploy arac smart contracty stegh a  u ira hamapatasxan obyekty edauction popoxakani mej a
  saveFrontendFiles({
    DutchAuction: auction
  })
}

// sa chisht copya anelu en faylery vornq menq uzum enq copy anenq frontendi hamar
 
function saveFrontendFiles(contracts) {
  const contractsDir = path.join(__dirname, '/..', 'front/contracts') //pahum enq aystegh

  if(!fs.existsSync(contractsDir)) { //ete chka sarqi direktoryn
    fs.mkdirSync(contractsDir)
  }

  //dimum enq bolor contractnerin, contract item u dranic khanenq klyuch u znacheniyan
  Object.entries(contracts).forEach((contract_item) => {
    const [name, contract] = contract_item // es depqum name : duchauctin, contract: auction

    if(contract) { // stugum eq ete smart c ka u sxal chi eghel
//kopit asac taki mej hascena
      fs.writeFileSync(
        path.join(contractsDir, '/', name + '-contract-address.json'), //sarqac diri mej faylll kdnenq es anunov, vori mrj hascen kdnenq mer henc nor deploy arac contracti hascen
        JSON.stringify({[name]: contract.address}, undefined, 2) // stegh ed fayli  mej henc hascen grum enq
      )
    }

    const ContractArtifact = hre.artifacts.readArtifactSync(name) //stanum enq smart contracti artifacty (compile arac)
// sra mej el abi-n
    // noric ksarqenq fayl SC-anuny . JSOn u 
    fs.writeFileSync( 
      path.join(contractsDir, '/', name + ".json"),
      JSON.stringify(ContractArtifact, null, 2) //dra mej kdnenq artifacti parunakututyuny 
    )
  })
}

// kanchum enq mainy
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })

  // ka patrast smart contracneri deploy fronti hamar