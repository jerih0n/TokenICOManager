const OpenZeppelinERC20TokenHandler = artifacts.require("OpenZeppelingERC20TokenHandler");
const TestToken = artifacts.require("TestToken");


contract('OpenZeppelingERC20TokenHandler', (accounts) => {
    it('should NOT Accept no ERC20 Token to interact', async () => {
        try {
            const openZeppelinERC20TokenHandlerInstance = await OpenZeppelinERC20TokenHandler.new(accounts[0],accounts[0]);
            asert.equal(await openZeppelinERC20TokenHandlerInstance.isERC20Token(), false, "Confirm the this is not a VALID EC20 token")
        }
        catch (err) {
            
        }
      });

    it('should be deployed with no errors with valid OpenZeppelin ERC20 token', async () => {
      const testTokenInstance = await TestToken.deployed();
      const openZeppelinERC20TokenHandlerInstance = await OpenZeppelinERC20TokenHandler.deployed(testTokenInstance.address,accounts[0]);
      assert.equal(await openZeppelinERC20TokenHandlerInstance.isERC20Token(), true, "Confirm that this is a valid ERC20 token")
    });

    it('should get token symbol correctly', async () => {
        const testTokenInstance = await TestToken.deployed();
        const openZeppelinERC20TokenHandlerInstance = await OpenZeppelinERC20TokenHandler.deployed(testTokenInstance.address,accounts[0]);
        assert.equal(await openZeppelinERC20TokenHandlerInstance.getSymbol(), await testTokenInstance.symbol(), "Confirm that this is a valid ERC20 token and can get symbol")
      });

      it('should get decimals correctly', async () => {
        const testTokenInstance = await TestToken.deployed();
        const openZeppelinERC20TokenHandlerInstance = await OpenZeppelinERC20TokenHandler.deployed(testTokenInstance.address,accounts[0]);
        assert.equal(await openZeppelinERC20TokenHandlerInstance.getDecimals(), await testTokenInstance.decimals(), "Confirm that this is a valid ERC20 token and can get decimals")
      });

      it('should get total supply corectly', async () => {
        const testTokenInstance = await TestToken.deployed();
        const openZeppelinERC20TokenHandlerInstance = await OpenZeppelinERC20TokenHandler.deployed(testTokenInstance.address,accounts[0]);
        assert.equal(await openZeppelinERC20TokenHandlerInstance.getTotalSupply(), await testTokenInstance.totalSupply(), "Confirm that this is a valid ERC20 token and can get total supply")
      });

  });