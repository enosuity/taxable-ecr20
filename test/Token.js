const {
    time,
    loadFixture,
  } = require("@nomicfoundation/hardhat-network-helpers");
  const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
  const { expect } = require("chai");
  
  describe("Token", function () {
    // We define a fixture to reuse the same setup in every test.
    // We use loadFixture to run this setup once, snapshot that state,
    // and reset Hardhat Network to that snapshot in every test.
    async function deployMe() {
      
      return { };
    }
  
    describe("Deployment", function () {
      it("test", async function () {
        // const { lock, unlockTime } = await loadFixture(deployMe);
  
        // expect(await lock.unlockTime()).to.equal(unlockTime);
      });
    });
  });
  