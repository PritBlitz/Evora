const Participant = require("../models/Participant");

// Register participant or autofill details
exports.registerParticipant = async (req, res) => {
  const { name, email, college, phone, eventId } = req.body;

  try {
    let participant = await Participant.findOne({ email });

    if (participant) {
      return res.status(200).json({ message: "Existing user", participant });
    }

    participant = new Participant({
      name,
      email,
      college,
      phone,
      registeredEvents: [eventId],
    });
    await participant.save();

    res.status(201).json({ message: "Registered successfully", participant });
  } catch (error) {
    res.status(500).json({ message: "Server error", error });
  }
};

// Fetch participant details for autofill
exports.getParticipant = async (req, res) => {
  try {
    const participant = await Participant.findOne({ email: req.params.email });
    if (!participant)
      return res.status(404).json({ message: "User not found" });

    res.status(200).json(participant);
  } catch (error) {
    res.status(500).json({ message: "Server error", error });
  }
};
