// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Presale is Ownable {
    IERC20 public token;
    uint256 public presaleStage;
    uint256 public totalTokensSold;
    uint256 public constant TAX_PERCENTAGE = 5; // 5% tax
    address public devWallet;
    address public ownerWallet;

    struct Stage {
        uint256 tokensToSell;
        uint256 pricePerToken;
        bool isActive;
        uint256 minBuyBNB;
        uint256 maxBuyBNB;
    }

    Stage[] public stages;

    event TokensPurchased(address indexed buyer, uint256 amount, uint256 cost);

    constructor(
        IERC20 _token,
        address _devWallet,
        address _ownerWallet
    ) {
        token = _token;
        devWallet = _devWallet;
        ownerWallet = _ownerWallet;

        // Initializing the stages
        stages.push(Stage(1_050_000 * (10 ** 18), 0.1 ether, true, 0.1 ether, 3 ether)); // Fair launch
        stages.push(Stage(1_058_333 * (10 ** 18), 0.5 ether, false, 0.1 ether, 3 ether)); // Stage 1
        stages.push(Stage(1_058_333 * (10 ** 18), 0.6 ether, false, 0.1 ether, 3 ether)); // Stage 2
        stages.push(Stage(1_058_333 * (10 ** 18), 0.7 ether, false, 0.1 ether, 3 ether)); // Stage 3
        stages.push(Stage(1_058_333 * (10 ** 18), 0.8 ether, false, 0.1 ether, 3 ether)); // Stage 4
        stages.push(Stage(1_058_333 * (10 ** 18), 0.9 ether, false, 0.1 ether, 3 ether)); // Stage 5
        stages.push(Stage(1_058_333 * (10 ** 18), 1 ether, false, 0.1 ether, 3 ether)); // Stage 6

        presaleStage = 0; // Start from the first stage (Fair launch)
    }

    function buyTokens() external payable {
        require(stages[presaleStage].isActive, "Presale stage is not active");
        require(msg.value >= stages[presaleStage].minBuyBNB, "Minimum BNB not met");
        require(msg.value <= stages[presaleStage].maxBuyBNB, "Exceeds maximum BNB");

        uint256 tokensToBuy = (msg.value * 10 ** 18) / stages[presaleStage].pricePerToken;
        require(stages[presaleStage].tokensToSell >= tokensToBuy, "Not enough tokens left in this stage");

        uint256 taxAmount = (msg.value * TAX_PERCENTAGE) / 100;
        uint256 netAmount = msg.value - taxAmount;

        token.transfer(msg.sender, tokensToBuy);
        stages[presaleStage].tokensToSell -= tokensToBuy;
        totalTokensSold += tokensToBuy;

        payable(devWallet).transfer(taxAmount);
        payable(ownerWallet).transfer(netAmount);

        emit TokensPurchased(msg.sender, tokensToBuy, msg.value);

        if (stages[presaleStage].tokensToSell == 0 && presaleStage < stages.length - 1) {
            stages[presaleStage].isActive = false;
            presaleStage++;
            stages[presaleStage].isActive = true;
        }
    }

    function setStageStatus(uint256 stageIndex, bool status) external onlyOwner {
        stages[stageIndex].isActive = status;
    }

    function withdrawFunds() external onlyOwner {
        payable(ownerWallet).transfer(address(this).balance);
    }
}
