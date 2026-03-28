const express = require("express");
const bodyParser = require("body-parser");

const app = express();
app.use(bodyParser.json());

// Generate 100 mock users
const mockUsers = [];
for (let i = 1; i <= 100; i++) {
  const pan = "PAN" + i.toString().padStart(5, "0"); // PAN00001 → PAN00100
  const aadhaar = (100000000000 + i).toString();     // Aadhaar numbers
  const creditScore = Math.floor(Math.random() * 300) + 500; // 500–800
  mockUsers.push({ PAN: pan, AADHAAR: aadhaar, CREDIT_SCORE: creditScore });
}

// API endpoint
app.post("/getCreditScore", (req, res) => {
  const { PAN, AADHAAR } = req.body;

  const user = mockUsers.find(
    (u) => u.PAN === PAN && u.AADHAAR === AADHAAR
  );

  if (user) {
    res.json({ "CREDIT SCORE": user.CREDIT_SCORE });
  } else {
    res.status(404).json({ error: "User not found or PAN/AADHAAR mismatch" });
  }
});

// Start server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`✅ Mock Banking API running at http://localhost:${PORT}`));
