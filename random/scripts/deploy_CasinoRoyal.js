const main = async () => {
  try {
    const CasinoRoyalContractFactory = await hre.ethers.getContractFactory(
      "CasinoRoyal"
    );
    const CasinoRoyalContract = await CasinoRoyalContractFactory.deploy();
    await CasinoRoyalContract.deployed();

    console.log("Contract deployed to:", CasinoRoyalContract.address);
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

main();
