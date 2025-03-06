const express = require("express");
const {
  registerParticipant,
  getParticipant,
} = require("../controllers/participantController");

const router = express.Router();

router.post("/register", registerParticipant);
router.get("/participant/:email", getParticipant);

module.exports = router;
