const express = require("express");
const { exec } = require("child_process");

const app = express();
const PORT = 4000; // Puedes cambiarlo si ya está en uso

app.use(express.json());

app.post("/deploy", (req, res) => {
  console.log("📦 Webhook recibido - iniciando deploy");

  const cmd = `
    cd /d "D:\\Compartido\\AppFelmanAccessMySQL\\access-proxy" &&
    git pull origin main &&
    pm2 restart access-proxy &&
    pm2 save
  `;

  exec(cmd, (err, stdout, stderr) => {
    if (err) {
      console.error("❌ Error en deploy:", err);
      return res.status(500).send("Error en el despliegue");
    }

    console.log("✅ Despliegue completado:\n", stdout);
    res.send("Despliegue realizado correctamente");
  });
});

app.listen(PORT, () => {
  console.log(`🚀 Webhook escuchando en http://localhost:${PORT}/deploy`);
});
