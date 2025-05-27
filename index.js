const express = require('express');
const ADODB  = require('node-adodb');
const app    = express();

// Ruta LAN o UNC a la base Access
const dbPath = 'D:\Compartido\PRODUCCION_MONCADA\CONTROL_PRODUCCION_MONCADA_V40.accdb';
const conn   = ADODB.open(
  `Provider=Microsoft.ACE.OLEDB.12.0;Data Source=${dbPath};Persist Security Info=False;`
);

// Endpoint que expone los pedidos
app.get('/api/pedidos', async (req, res) => {
  try {
    const sql = `SELECT
      [Ejercicio] & '-' & [Serie] & '-' & [NPedido] AS NºPedido,
      Estado AS EstadoPedido,
      Incidencia,
      FechaCompromiso AS Compromiso
    FROM BPedidos
    LEFT JOIN AEstadosPedido ON BPedidos.Id_EstadoPedido = AEstadosPedido.Id_EstadoPedido`;
    const data = await conn.query(sql);
    res.json(data);
  } catch (error) {
    console.error('Error al consultar Access:', error);
    res.status(500).json({ error: error.message });
  }
});

const PORT = 3001;
app.listen(PORT, () => console.log(`Proxy Access corriendo en puerto ${PORT}`));