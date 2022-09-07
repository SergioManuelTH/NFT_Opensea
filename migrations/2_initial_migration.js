const Nfts = artifacts.require("Nfts.sol");

module.exports = function(deployer) {
  deployer.deploy(Nfts,"DADOS","DD"); //si el contructor del contrato tiene args de entrada: deployer.deploy(Hello,'arg1', ..)
};
