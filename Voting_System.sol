// Specifies the license type for the code
/ SPDX-License-Identifier: MIT

// Declares the Solidity version required to compile this contract
pragma solidity ^0.8.0;

// Ownable contract to manage ownership rights
contract Ownable {
    // Stores the address of the contract owner
    address public owner;

    // Constructor sets the deployer as the contract owner
    constructor() {
        owner = msg.sender;
    }

    // Modifier restricts access to only the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _; // Continues execution if the condition is met
    }
}

// Main contract that inherits ownership functionality
contract VotingSystem is Ownable {

    // Structure defining a candidate
    struct Candidate {
        uint id; // Unique ID for the candidate
        string name; // Candidate's name
        uint voteCount; // Number of votes received
    }

    // Maps candidate ID to Candidate struct (private access)
    mapping (uint => Candidate) private candidates;

    // Tracks whether an address has voted (private access)
    mapping (address => bool) private voters;

    // Stores total count of added candidates
    uint private totalCandidateCount;

    // Allows owner to add a candidate with ID, name, and initial vote count
    function addCandidate(uint id, string calldata name, uint voteCount) external onlyOwner {
        candidates[id] = Candidate(id, name, voteCount);
        totalCandidateCount++;
    }

    // Allows a user to vote for a candidate
    function vote(uint candidateId) external {
        require(!voters[msg.sender], "Already voted."); // Ensure one vote per address
        require(candidates[candidateId].id == candidateId, "Candidate does not exist."); // Validate candidate
        voters[msg.sender] = true; // Mark sender as having voted
        candidates[candidateId].voteCount++; // Increase vote count for candidate
    }

    // Returns candidate name and vote count for a given ID
    function getCandidate(uint candidateId) public view returns (string memory name, uint voteCount) {
        Candidate memory c = candidates[candidateId];
        return (c.name, c.voteCount);
    }

    // Returns the total number of candidates
    function getTotalCandiates() public view returns (uint) {
        return totalCandidateCount;
    }
}