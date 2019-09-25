const Migrations = artifacts.require("Migrations");
const ChoiHo = artifacts.require("ChoiHo");

module.exports = function(deployer) {
  deployer.deploy(Migrations);
  deployer.deploy(ChoiHo);
};
