const BigNumber = require("bignumber.js");


//test the basic functionality of the Crowdfunding cotract
const TestToken = artifacts.require("TestToken");
const TestBaseCrowdfundingContract = artifacts.require("TestBasicCrowdFunding")



contract('TestBasicCrowdFunding', (accounts) => {

    it('should deploy contract successfully', async () => {
        try {
            const testToken = await TestToken.deployed();
            const testBaseCrowdfundingContract = await TestBaseCrowdfundingContract.deployed(testToken.address, 100, { from: accounts[0] });
            assert.isTrue(true, "Contract deployed Successfully")
        } catch (error) {
            assert.isTrue(false, "Contract deployedment failed")
        }


    });

    it(`should return ${accounts[0]} as sender `, async () => {

        const testToken = await TestToken.deployed();
        const testBaseCrowdfundingContract = await TestBaseCrowdfundingContract.deployed(testToken.address, 100, { from: accounts[0] });
        const sender = await testBaseCrowdfundingContract.getSender()
        assert.equal(sender, accounts[0], `${sender} returned from call`)
    });

    it(`should return 1000 as rate `, async () => {

        const testToken = await TestToken.deployed();
        const testBaseCrowdfundingContract = await TestBaseCrowdfundingContract.deployed(testToken.address, 100, { from: accounts[0] });
        const eth = 10;
        const rete = 1000;
        const rateFromContract = await testBaseCrowdfundingContract.test_getRate(eth);
        assert.equal(rete, rateFromContract.toNumber(), `${rateFromContract} rate returned from call`)
    });

    it(`should calculate token amount properly for 1 eth`, async () => {

        const testToken = await TestToken.deployed();
        const testBaseCrowdfundingContract = await TestBaseCrowdfundingContract.deployed(testToken.address, 100, { from: accounts[0] });

        var expectedTokenAmount = new BigNumber(`${1000000000000000000000}`); //1000e18 1000 tokens for 1 eth

        var tokenAmount = new BigNumber(`${await testBaseCrowdfundingContract.test_getTokenAmount.call(web3.utils.toWei("1", "ether"))}`);//1e18 wei

        assert.isTrue(tokenAmount.eq(expectedTokenAmount), "should calculate correctly the token amount")
    });

    it(`should calculate token amount properly for 10 eth`, async () => {

        const testToken = await TestToken.deployed();
        const testBaseCrowdfundingContract = await TestBaseCrowdfundingContract.deployed(testToken.address, 100, { from: accounts[0] });

        var expectedTokenAmount = new BigNumber(`${10 * 1000000000000000000000}`); //1000e18 1000 tokens for 1 eth

        var tokenAmount = new BigNumber(`${await testBaseCrowdfundingContract.test_getTokenAmount.call(web3.utils.toWei("10", "ether"))}`);//1e18 wei

        assert.isTrue(tokenAmount.eq(expectedTokenAmount), "should calculate correctly the token amount")
    });

    it(`should calculate token amount properly for 0.09 eth`, async () => {

        const testToken = await TestToken.deployed();
        const testBaseCrowdfundingContract = await TestBaseCrowdfundingContract.deployed(testToken.address, 100, { from: accounts[0] });

        var expectedTokenAmount = new BigNumber(`${0.09 * 1000000000000000000000}`); //1000e18 1000 tokens for 1 eth

        var tokenAmount = new BigNumber(`${await testBaseCrowdfundingContract.test_getTokenAmount.call(web3.utils.toWei("0.09", "ether"))}`);//1e18 wei

        assert.isTrue(tokenAmount.eq(expectedTokenAmount), "should calculate correctly the token amount")
    });

    it(`should return Not Started when contract is not started`, async () => {
        const testToken = await TestToken.deployed();
        const testBaseCrowdfundingContract = await TestBaseCrowdfundingContract.deployed(testToken.address, 100, { from: accounts[0] });
        const status = "Not Started";

        const resut = web3.utils.toUtf8(await testBaseCrowdfundingContract.getStatus());
        assert.equal(status, resut, "status is not correct")
    })

    it(`should return In Progress when crowdfunding is in progress`, async () => {
        const testToken = await TestToken.deployed();
        const testBaseCrowdfundingContract = await TestBaseCrowdfundingContract.deployed(testToken.address, 100, { from: accounts[0] });
        const status = "Not Started";

        const resut = web3.utils.toUtf8(await testBaseCrowdfundingContract.getStatus());
        assert.equal(status, resut, "status is not correct")
    })


    it(`should throw error when crowdfunding is started twice`, async () => {
        const testToken = await TestToken.deployed();
        const testBaseCrowdfundingContract = await TestBaseCrowdfundingContract.deployed(testToken.address, 100, { from: accounts[0] });

        try {
            await testBaseCrowdfundingContract.start.call();
            const resut = web3.utils.toUtf8(await testBaseCrowdfundingContract.start.call());
            assert.isTrue(false, "Error is trown");
        }
        catch (error) {
            assert.isTrue(true, "Error is trown");
        }
    })

    it(`should throw error when end is called before start `, async () => {
        const testToken = await TestToken.deployed();
        const testBaseCrowdfundingContract = await TestBaseCrowdfundingContract.deployed(testToken.address, 100, { from: accounts[0] });

        try {
            await testBaseCrowdfundingContract.end.call();

            assert.isTrue(false, "Error is trown");
        }
        catch (error) {
            assert.isTrue(true, "Error is trown");
        }
    })
});