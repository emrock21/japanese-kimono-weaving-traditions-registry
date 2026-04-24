// SPDX-License-Identifier: MIT
pragma solidity 0.8.31;

contract KimonoWeavingTraditionsRegistry {

    struct WeavingTradition {
        string textileName;         // tsumugi, kasuri, chirimen, bashofu, etc.
        string region;              // Kyoto, Okinawa, Yuki, Yonezawa, etc.
        string materials;           // silk, ramie, banana fiber, cotton
        string techniques;          // handloom, kasuri resist, twist weaving, etc.
        string motifs;              // geometric, kasuri blur, regional patterns
        string culturalContext;     // kimono types, seasonal use, ritual use
        string uniqueness;          // what makes this textile distinct
        address creator;
        uint256 likes;
        uint256 dislikes;
        uint256 createdAt;
    }

    struct WeavingInput {
        string textileName;
        string region;
        string materials;
        string techniques;
        string motifs;
        string culturalContext;
        string uniqueness;
    }

    WeavingTradition[] public traditions;
    mapping(uint256 => mapping(address => bool)) public hasVoted;

    event WeavingRecorded(uint256 indexed id, string textileName, address indexed creator);
    event WeavingVoted(uint256 indexed id, bool like, uint256 likes, uint256 dislikes);

    constructor() {
        traditions.push(
            WeavingTradition({
                textileName: "Example (replace manually)",
                region: "example",
                materials: "example",
                techniques: "example",
                motifs: "example",
                culturalContext: "example",
                uniqueness: "example",
                creator: address(0),
                likes: 0,
                dislikes: 0,
                createdAt: block.timestamp
            })
        );
    }

    function recordWeaving(WeavingInput calldata w) external {
        traditions.push(
            WeavingTradition({
                textileName: w.textileName,
                region: w.region,
                materials: w.materials,
                techniques: w.techniques,
                motifs: w.motifs,
                culturalContext: w.culturalContext,
                uniqueness: w.uniqueness,
                creator: msg.sender,
                likes: 0,
                dislikes: 0,
                createdAt: block.timestamp
            })
        );

        emit WeavingRecorded(traditions.length - 1, w.textileName, msg.sender);
    }

    function voteWeaving(uint256 id, bool like) external {
        require(id < traditions.length, "Invalid ID");
        require(!hasVoted[id][msg.sender], "Already voted");

        hasVoted[id][msg.sender] = true;
        WeavingTradition storage w = traditions[id];

        if (like) w.likes++;
        else w.dislikes++;

        emit WeavingVoted(id, like, w.likes, w.dislikes);
    }

    function totalWeavings() external view returns (uint256) {
        return traditions.length;
    }
}
