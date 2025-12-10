require('dotenv').config();
const express = require('express');
const axios = require('axios');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());

const PORT = process.env.PORT || 8080;
const GEMINI_API_KEY = process.env.GEMINI_API_KEY;
const GEMINI_API_URL = process.env.GEMINI_API_URL;

// Basic health check
app.get('/health', (req, res) => res.json({ok: true}));

// Proxy endpoint for chat
app.post('/api/chat', async (req, res) => {
  try {
    const { messages, model, params } = req.body; // adapt shape to how you call it

    // Build request for Gemini API — adapt body to Gemini's API shape
    const geminiBody = {
      model: model || 'gemini-small',
      input: messages, // or whichever field your API expects
      ...params
    };

    const response = await axios.post(GEMINI_API_URL, geminiBody, {
      headers: {
        Authorization: `Bearer ${GEMINI_API_KEY}`,
        'Content-Type': 'application/json'
      },
      timeout: 60000
    });

    // return the provider response directly (or transform it into easier shape)
    return res.json(response.data);
  } catch (err) {
    console.error('Proxy error:', err?.response?.data || err.message);
    return res.status(err?.response?.status || 500).json({
      error: 'backend_error',
      details: err?.response?.data || err.message
    });
  }
});

app.listen(PORT, () => console.log(`Server listening on ${PORT}`));
