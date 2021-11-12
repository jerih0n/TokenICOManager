const Calculations = artifacts.require("Calculations");
const TestToken = artifacts.require("TestToken");
const TestBasicCrowdFunding = artifacts.require("TestBasicCrowdFunding");

Date.prototype.addDays = function (days) {
    var date = new Date(this.valueOf());
    date.setDate(date.getDate() + days);
    return date;
}

//Deploying in main net will cost you real ETH is gass FEE! Be carfull 
module.exports = async function (deployer, network, accounts) {

    //deployment options 
    //1).overwrite: false -> this contract will not be deployed again if already has been. THIS should be the case with 3-th party contract like in this case 
    //2)from: send the owner address. By default will be the first address. NOTE: setting the owner of the contract is important. Some calls to of well ritten smart contract
    //should be limited only for owner. In other words calling smart contracts with address different than owner my face limitations
    //3)gas: set the max amount of gass in wei to be payed. IF gass price goes beyoud this max amount the deploy will be revurted. the same rule for all eth transactions
    //deploy only on local ganache network !


    deployer.then(async () => {
        await deployer.deploy(Calculations, { from: accounts[0], overwrite: false });
        await deployer.deploy(TestToken, { from: accounts[0], overwrite: false });
        await deployer.link(Calculations, TestBasicCrowdFunding);
        await deployer.deploy(TestBasicCrowdFunding, TestToken.address, { from: accounts[0], overwrite: false })
    })

};