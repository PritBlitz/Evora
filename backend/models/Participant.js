const mongoose = require("mongoose");

const participantSchema = new mongoose.Schema(
  {
    name: String,
    email: { type: String, unique: true, required: true },
    college: String,
    phone: String,
    registeredEvents: [String],
  },
  { timestamps: true }
);

module.exports = mongoose.model("Participant", participantSchema);
