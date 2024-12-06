import { ethers } from "hardhat";

async function main() {
	const SplitwiseContract = await ethers.getContractFactory("Splitwise");
	const splitwiseContract = await SplitwiseContract.deploy();
	await splitwiseContract.deployed();
	console.log(`Splitwise contract address: ${splitwiseContract.address}`);
}

main()
	.then(() => process.exit(0))
	.catch((error) => {
		console.error(error);
		process.exit(1);
	});