// server.js
const express = require("express");
const mongoose = require("mongoose");
const User = require("./backend-node/models/User");
const Team = require("./backend-node/models/Team");

const app = express();
app.use(express.json());

// MongoDB connection
const mongoURI =
  "mongodb+srv://pritish9801edu:BBTza4vFn2UOSEeI@cluster0.frplq.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0";

mongoose
  .connect(mongoURI, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  })
  .then(() => console.log("MongoDB Atlas Connected!"))
  .catch((err) => console.log("MongoDB Connection Error:", err));

// POST Route for creating a new user and assigning them to a team
app.post("/api/users", async (req, res) => {
  try {
    const { name, email, age, password, teamName } = req.body;

    // Check if the team exists, or create a new team
    let team = await Team.findOne({ teamName });

    if (!team) {
      // Create a new team if it doesn't exist
      team = new Team({
        teamName,
        members: [], // Initially no members
      });
      await team.save();
    }

    // Create the user and assign them to the team
    const user = new User({
      name,
      email,
      age,
      password,
      team: team._id, // Assign user to the team
    });

    await user.save();

    // Add user to the team's members list
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
      return res.status(404).json({ error: "Team not found" });
    }

    res.status(200).json({ team });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

app.listen(5000, () => console.log("Server running on port 5000"));
