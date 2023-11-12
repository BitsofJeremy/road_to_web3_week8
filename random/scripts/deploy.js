const main = async () => {
  try {
    const CasinoContractFactory = await hre.ethers.getContractFactory(
      "Casino"
    );
    const CasinoContract = await CasinoContractFactory.deploy();
    await CasinoContract.deployed();

    console.log("Contract deployed to:", CasinoContract.address);
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

main();
