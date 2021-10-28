
//test the basic functionality of the Crowdfunding cotract
const TestToken = artifacts.require("TestToken");
const OpenZeppelinERC20TokenHandler = artifacts.require("OpenZeppelingERC20TokenHandler");
const TestBaseCrowdfundingContract = artifacts.require("TestBasicCrowdFunding")


contract('TestBaseCrowdfundingContract', (accounts) => {

    it('should deploy contract successfully', async () => {
        try {
            const testToken = await TestToken.deployed();
            const openZeppelinERC20TokenHandler = await OpenZeppelinERC20TokenHandler.deployed(testToken.address, accounts[0])
            const testBaseCrowdfundingContract = await TestBaseCrowdfundingContract.deployed(testToken.address, { from: accounts[0] });
            assert.isTrue(true, "Contract deployed Successfully")
        } catch (error) {
            assert.isTrue(false, "Contract deployedment failed")
        }


    });

    it(`should return ${accounts[0]} as sender `, async () => {

        const testToken = await TestToken.deployed();
        const openZeppelinERC20TokenHandler = await OpenZeppelinERC20TokenHandler.deployed(testToken.address, accounts[0])
        const testBaseCrowdfundingContract = await TestBaseCrowdfundingContract.deployed(testToken.address, { from: accounts[0] });
        const sender = await testBaseCrowdfundingContract.getSender()
        assert.equal(sender, accounts[0], `${sender} returned from call`)
    });

    it(`should return 1000 as rate `, async () => {

        const testToken = await TestToken.deployed();
        const openZeppelinERC20TokenHandler = await OpenZeppelinERC20TokenHandler.deployed(testToken.address, accounts[0])
        const testBaseCrowdfundingContract = await TestBaseCrowdfundingContract.deployed(testToken.address, { from: accounts[0] });
        const eth = 10;
        const rete = 1000;
        const rateFromContract = await testBaseCrowdfundingContract.test_getRate(eth);
        assert.equal(rete, rateFromContract.toNumber(), `${rateFromContract} rate returned from call`)
    });

    it(`should calculate token amount properly t1`, async () => {

        const testToken = await TestToken.deployed();
        const openZeppelinERC20TokenHandler = await OpenZeppelinERC20TokenHandler.deployed(testToken.address, accounts[0])
        const testBaseCrowdfundingContract = await TestBaseCrowdfundingContract.deployed(testToken.address, { from: accounts[0] });

        const wei = 10 ** 18; //1 eth
        console.log(wei);

        const amountFromToken = await testBaseCrowdfundingContract._getTokenAmount(wei);

        const tokenAmountThatShouldBeGet = ((wei * (10 ** await openZeppelinERC20TokenHandler.getDecimals())) / 10) * rateFromContract;


        assert.equal(amountFromToken, tokenAmountThatShouldBeGet, `should calculate correctly the token amount`)
    });
});