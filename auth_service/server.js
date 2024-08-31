const express = require('express');
const bodyParser = require('body-parser');
const crypto = require('crypto');

const app = express();
app.use(bodyParser.json());

const PORT = process.env.PORT || 3000;

// In-memory store for commitments and challenges
const users = {};

// List of words for generating recovery phrases
const wordList = [
  "apple", "banana", "cherry", "date", "elder", "fig", "grape", "honeydew",
  "indigo", "jicama", "kiwi", "lemon", "mango", "nectarine", "orange", "papaya",
  "quince", "raspberry", "strawberry", "tangerine", "ugli", "vanilla", "watermelon", "xigua",
  "yuzu", "zucchini"
  // ... add more words to have at least 2048 words for security
];

// Function to generate a recovery phrase
function generateRecoveryPhrase(wordCount = 12) {
  const phrase = [];
  for (let i = 0; i < wordCount; i++) {
    const randomIndex = crypto.randomInt(0, wordList.length);
    phrase.push(wordList[randomIndex]);
  }
  return phrase.join(' ');
}

// Function to derive a big integer from the recovery phrase
function deriveCommitmentFromPhrase(phrase) {
  const hash = crypto.createHash('sha256').update(phrase).digest('hex');
  return BigInt('0x' + hash);
}

// Utility function to generate a random big integer
function generateRandomBigInt(bytes) {
  return BigInt('0x' + crypto.randomBytes(bytes).toString('hex'));
}

// Endpoint to register a user (generate recovery phrase and store the commitment)
app.post('/register', (req, res) => {
  const recoveryPhrase = generateRecoveryPhrase();
  const commitment = deriveCommitmentFromPhrase(recoveryPhrase);

  // Generate a user ID (in practice, this could be a wallet address or other identifier)
  const userId = crypto.randomBytes(16).toString('hex');
  
  // Store the commitment
  users[userId] = {
    commitment: commitment,
    challenge: null,
  };

  console.log(`User ${userId} registered with commitment derived from recovery phrase`);
  res.json({ userId, recoveryPhrase });
});

// Endpoint to generate a challenge for authentication
app.get('/challenge', (req, res) => {
  const { userId } = req.query;
  if (!userId || !users[userId]) {
    return res.status(400).json({ error: 'Invalid user ID' });
  }

  // Generate a random challenge
  const challenge = generateRandomBigInt(16); // 128-bit challenge
  users[userId].challenge = challenge;

  console.log(`Challenge for user ${userId}: ${challenge}`);
  res.json({ challenge: challenge.toString() });
});

// Endpoint to verify the proof
app.post('/authenticate', (req, res) => {
  const { userId, response } = req.body;
  if (!userId || !response || !users[userId]) {
    return res.status(400).json({ error: 'Invalid request' });
  }

  const { commitment, challenge } = users[userId];
  const s = BigInt(response);
  const g = BigInt(2); // Simplified generator point

  // Verify the proof: check if g^s mod p equals commitment * g^challenge mod p
  const p = BigInt(2)**BigInt(256) - BigInt(2**32) - BigInt(977); // A 256-bit prime number
  const verified = g.modPow(s, p) === (commitment * g.modPow(challenge, p)) % p;

  if (verified) {
    console.log(`User ${userId} authenticated successfully`);
    res.json({ success: true });
  } else {
    console.log(`User ${userId} failed authentication`);
    res.status(401).json({ success: false });
  }
});

app.listen(PORT, () => {
  console.log(`ZKP Authentication Server running on port ${PORT}`);
});