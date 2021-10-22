//const InitialCoinOfferingStatus = artifacts.require("InitialCoinOfferingStatus");
const InitialCoinOfferingConractBase = artifacts.require("InitialCoinOfferingConractBase");

contract('InitialCoinOfferingConractBase', (accounts) => {
    it('contract should be deployed', async () => {
      const startDate = 1634677085;
      const endDate = 1634678085;
      const addressNotERC20 = accounts[1];
      const metaCoinInstance = await InitialCoinOfferingConractBase.deployed(startDate, endDate,addressNotERC20 );
      const status = await InitialCoinOfferingConractBase.getStatus();
      console.log(status);
      //assert.equal(status.valueOf(), , "10000 wasn't in the first account");
    });
  });
