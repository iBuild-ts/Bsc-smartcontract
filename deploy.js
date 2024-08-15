async function main() {
    const [deployer] = await ethers.getSigners();

    console.log("Deploying contracts with the account:", deployer.address);

    const Token = await ethers.getContractFactory("Token");
    const Presale = await ethers.getContractFactory("Presale");

    // Assuming you've already deployed your ERC20 token contract
    const token = await Token.deploy();
    await token.deployed();

    console.log("Token deployed to:", token.address);

    // Deploying the presale contract
    const presale = await Presale.deploy(token.address, "DEV_WALLET_ADDRESS", "OWNER_WALLET_ADDRESS");
    await presale.deployed();

    console.log("Presale deployed to:", presale.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
