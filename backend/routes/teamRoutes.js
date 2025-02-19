const express = require("express");
const Team = require("../models/Team");
const User = require("../models/User");
const router = express.Router();

// Create a team
router.post("/teams", async (req, res) => {
  try {
    const { name } = req.body;
    const newTeam = new Team({ name });

    await newTeam.save();
    res.status(201).json(newTeam);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

// Add user to team
router.post("/teams/:teamId/addUser", async (req, res) => {
  try {
    const { userId } = req.body;
    const team = await Team.findById(req.params.teamId);

    if (!team) {
      return res.status(404).json({ message: "Team not found" });
    }

    // Check if the team has less than 4 members
    if (team.members.length >= 4) {
      return res.status(400).json({ message: "Team is full" });
    }

    const user = await User.findById(userId);

    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    // Add the user to the team
    team.members.push(user._id);
    user.team = team._id;

    await team.save();
    await user.save();

    res.status(200).json({ message: "User added to team", team });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

// Get team information
router.get("/teams/:teamId", async (req, res) => {
  try {
    const team = await Team.findById(req.params.teamId).populate("members");

    if (!team) {
      return res.status(404).json({ message: "Team not found" });
    }

    res.status(200).json(team);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

module.exports = router;
