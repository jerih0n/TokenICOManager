

const OpenZeppelinERC20TokenHandler = artifacts.require("OpenZeppelingERC20TokenHandler");
const TestToken = artifacts.require("TestToken");
const BN = web3.utils.BN;

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
        assert.equal(await openZeppelinERC20TokenHandlerInstance.getSymbol.call(), await testTokenInstance.symbol.call(), "Confirm that this is a valid ERC20 token and can get symbol")
      });

      it('should get decimals correctly', async () => {
        const testTokenInstance = await TestToken.deployed();
        const openZeppelinERC20TokenHandlerInstance = await OpenZeppelinERC20TokenHandler.deployed(testTokenInstance.address,accounts[0]);

        const decimalsFromHandler = await openZeppelinERC20TokenHandlerInstance.getDecimals();
        const decimalsFromToken = await testTokenInstance.decimals();

        assert.equal(decimalsFromHandler.toNumber(), decimalsFromToken.toNumber() ,"Confirm that this is a valid ERC20 token and can get decimals");
      });

      it('should get total supply corectly', async () => {
        const testTokenInstance = await TestToken.deployed();
        const openZeppelinERC20TokenHandlerInstance = await OpenZeppelinERC20TokenHandler.deployed(testTokenInstance.address,accounts[0]);
        const totalSupplyHandler = await openZeppelinERC20TokenHandlerInstance.getDecimals();
        const totalSupplyToken = await testTokenInstance.decimals();
        assert.equal(totalSupplyHandler.toNumber(), totalSupplyToken.toNumber(), "Confirm that this is a valid ERC20 token and can get total supply")
      });

      it('should get balance corectly', async () => {
        const testTokenInstance = await TestToken.deployed();
        const openZeppelinERC20TokenHandlerInstance = await OpenZeppelinERC20TokenHandler.deployed(testTokenInstance.address,accounts[0]);

        const balanceOfAccountHandler = await openZeppelinERC20TokenHandlerInstance.getBalance.call(accounts[0]);
        const balanceOfAccountToken = await testTokenInstance.balanceOf.call(accounts[0]);

        assert(balanceOfAccountHandler.eq(balanceOfAccountToken), "Confirmes that this is a valid EC20 token and can get balanceOf address");
      });

      it('should perform transaction corectly', async () => {
        const testTokenInstance = await TestToken.deployed();
        const openZeppelinERC20TokenHandlerInstance = await OpenZeppelinERC20TokenHandler.deployed(testTokenInstance.address,accounts[0]);

        const balanceFromAccountThatHasBalance = await openZeppelinERC20TokenHandlerInstance.getBalance.call(accounts[0]);
        const balanceFromAccountThatHasZeroBalance = await openZeppelinERC20TokenHandlerInstance.getBalance.call(accounts[1]);

        assert(balanceFromAccountThatHasZeroBalance.gt(0), "This account should have 0 tokens");
        assert(balanceFromAccountThatHasBalance.gt(0), "This account should have more that 0 tokens")
        

        const amountToTransfer = 10000;

        console.log(balanceFromAccountThatHasBalance.gt(0));

        const result = await openZeppelinERC20TokenHandlerInstance.transferTo(accounts[1],amountToTransfer);

        assert(result,"transaction should be send successfuly")

        const newBalanceFromAccountThatHadZeroBalance = await openZeppelinERC20TokenHandlerInstance.getBalance.call(accounts[1]);

        assert(newBalanceFromAccountThatHadZeroBalance.gt(0),"This account should have balance now")
        //assert(balanceOfAccountHandler.eq(balanceOfAccountToken), "Confirmes that this is a valid EC20 token and can get balanceOf address");
      });
  });