const express = require("express");
const axios = require("axios");
const { exec } = require("child_process");

const app = express();
const PORT = 3003;

// Mengecek IP publik saat aplikasi dimulai
exec("curl -s ifconfig.me", (err, stdout) => {
  if (err) {
    console.error("Error checking VPN connection:", err);
  } else {
    console.log("VPN Public IP:", stdout.trim());
  }
});

app.get("/fetch-data", async (req, res) => {
  try {
    const response = await axios.get("http://103.181.142.133:4001/data");
    res.json(response.data);
  } catch (error) {
    console.error("Error fetching data:", error.message);
    res.status(500).send(`Error: ${error.message}`);
  }
});

app.listen(PORT, () => {
  console.log(`Service running on port ${PORT}`);
});
