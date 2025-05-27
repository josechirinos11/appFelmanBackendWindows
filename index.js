const express = require('express');
const ADODB = require('node-adodb');
const app = express();

// Ruta local a la .accdb
const dbPath = 'C:/DBShare/controlPedidos.accdb';
const connection = ADODB.open(
  \Provider=Microsoft.ACE.OLEDB.12.0;Data Source=\;Persist Security Info=False;\
);

app.get('/api/pedidos', async (req, res) => {
  try {
    const sql = \
      SELECT
        [Ejercicio] & '-' & [Serie] & '-' & [NPedido] AS NºPedido,
        Estado AS EstadoPedido,
        Incidencia,
        FechaCompromiso  AS Compromiso
      FROM BPedidos
      LEFT JOIN AEstadosPedido 
        ON BPedidos.Id_EstadoPedido = AEstadosPedido.Id_EstadoPedido
    \;
    const data = await connection.query(sql);
    res.json(data);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: err.message });
  }
});

const PORT = 3001;
app.listen(PORT, () => console.log(\Proxy Access escuchando en puerto \\));
