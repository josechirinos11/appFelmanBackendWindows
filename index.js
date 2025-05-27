const path = require('path');
const express = require('express');
const ADODB = require('node-adodb');

ADODB.debug = true;
const app = express();
const PORT = process.env.PORT || 3001;



const dbFile = '\\\\192.168.1.81\\Compartido\\PRODUCCION_MONCADA\\CONTROL_PRODUCCION_MONCADA_V40.accdb';


// Abre la conexión OLEDB apuntando al archivo correcto
const connection = ADODB.open(
  `Provider=Microsoft.ACE.OLEDB.12.0;Data Source=${dbFile};Persist Security Info=False;`
);

app.get('/api/pedidos', async (_, res) => {
  try {
    const rows = await connection.query('SELECT * FROM pedidos');
    res.json(rows);
  } catch (err) {
    console.error('Error al consultar Access:', err);
    res.status(500).json({ error: err.message });
  }
});

app.listen(PORT, () => console.log(`Proxy Access corriendo en puerto ${PORT}`));
