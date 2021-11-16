const BigNumber = require("bignumber.js");


//test the basic functionality of the Crowdfunding cotract
const TestToken = artifacts.require("TestToken");
const TestTokenOwnerCrowdfundig = artifacts.require("TestTokenOwnerCrowdfundig")


contract('TestTokenOwnerCrowdfundig', (accounts) => {

    it('should deploy contract successfully', async () => {
        try {
            const testToken = await TestToken.deployed();
            const testBaseCrowdfundingContract = await TestTokenOwnerCrowdfundig.deployed(testToken.address, 100, { from: accounts[0] });
            assert.isTrue(true, "Contract deployed Successfully")
        } catch (error) {
            assert.isTrue(false, "Contract deployedment failed")
        }


    });

    it(`should have balance for distribution`, async () => {
        const testToken = await TestToken.deployed({ from: accounts[0] });
        const testBaseCrowdfundingContract = await TestTokenOwnerCrowdfundig.deployed(testToken.address, 100, { from: accounts[0] });

        let accBalance = web3.utils.BN(await testToken.balanceOf(accounts[0]));

        assert.isTrue(accBalance > 0, "Account must have balance")

        const maxAmountForDistribution = web3.utils.BN(await testBaseCrowdfundingContract.getMaxTokenAmountToBeDestributed());
        await testToken.transfer(testBaseCrowdfundingContract.address, maxAmountForDistribution, { from: accounts[0] });

        let contractBalance = web3.utils.BN(await testToken.balanceOf(testBaseCrowdfundingContract.address));

        assert.isTrue(accBalance > 0, "Account must have balance")
        assert.isTrue(contractBalance > 0, "No money are transfered")
    });

});