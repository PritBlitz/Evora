require("dotenv").config(); // Load environment variables
const express = require("express");
const mongoose = require("mongoose");
const User = require("./backend/models/User");
const Team = require("./backend/models/Team");
const cors = require("cors");

const app = express();
app.use(express.json());
app.use(cors());

// MongoDB connection
const mongoURI = process.env.MONGO_URI;
const PORT = process.env.PORT || 5000;

mongoose
  .connect(mongoURI)
  .then(() => console.log("✅ MongoDB Atlas Connected!"))
  .catch((err) => console.log("❌ MongoDB Connection Error:", err));

// POST Route for creating a new user and assigning them to a team
app.post("/api/users", async (req, res) => {
  try {
    const { name, email, age, password, teamName, collegeName } = req.body;

    let team = await Team.findOne({ teamName });

    if (!team) {
      team = new Team({
        teamName,
        collegeName, // ✅ Save College Name in the Team
        members: [],
      });
      await team.save();
    }

    const user = new User({
      name,
      email,
      age,
      password,
      team: team._id,
      collegeName, // ✅ Store College Name in User
    });

    await user.save();

    team.members.push(user._id);
    await team.save();

    res.status(201).json({ message: "User registered", user, team });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

// GET Route to get all members of a team by team name
app.get("/api/teams/:teamName", async (req, res) => {
  try {
    const { teamName } = req.params;

    const team = await Team.findOne({ teamName }).populate(
      "members",
      "name email age"
    );

    if (!team) {
      return res.status(404).json({ error: "❌ Team not found" });
    }

    res.status(200).json({ team });
  } catch (error) {
    console.error("❌ Error fetching team:", error);
    res.status(500).json({ error: "Internal Server Error" });
  }
});

app.get("/api/teams/college/:collegeName", async (req, res) => {
  try {
    const { collegeName } = req.params;

    // Find all teams that belong to the given college
    const teams = await Team.find({ collegeName }).populate(
      "members",
      "name email age"
    );

    if (!teams.length) {
      return res.status(404).json({ error: "No teams found for this college" });
    }

    res.status(200).json({ teams });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

// Start the server
app.listen(PORT, () => console.log(`🚀 Server running on port ${PORT}`));
