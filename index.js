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
    const rows = await connection.query(`SELECT
      [Ejercicio] & '-' & [Serie] & '-' & [NPedido] AS NºPedido,
      Estado AS EstadoPedido,
      Incidencia,
      FechaCompromiso AS Compromiso
    FROM BPedidos
    LEFT JOIN AEstadosPedido ON BPedidos.Id_EstadoPedido = AEstadosPedido.Id_EstadoPedido`);
    res.json(rows);
  } catch (err) {
    console.error('Error al consultar Access:', err);
    res.status(500).json({ error: err.message });
  }
});

app.get('/api/controlPedidoInicio', async (_, res) => {
  try {
    const rows = await connection.query(`
      SELECT
        [BPedidos].[Ejercicio] & '-' & [BPedidos].[Serie] & '-' & [BPedidos].[NPedido] AS NoPedido,
        ASecciones.Seccion,
        AClientes.NombreCliente AS Cliente,
        BPedidos.RefCliente AS [Ref Cliente],
        BPedidos.FechaCompromiso AS Compromiso,
        C.Id_ControlMat,
        C.Material,
        C.Proveedor,
        C.FechaPrevista,
        C.Recibido
      FROM ((BPedidos
      INNER JOIN AClientes ON BPedidos.Id_Cliente = AClientes.Id_Cliente)
      INNER JOIN ASecciones ON BPedidos.Id_Seccion = ASecciones.Id_Seccion)
      LEFT JOIN ControlPedidosProveedores AS C ON 
        ([BPedidos].[Ejercicio] & '-' & [BPedidos].[Serie] & '-' & [BPedidos].[NPedido]) = C.[NºPedido]
    `);
    res.json(rows);
  } catch (err) {
    console.error('Error al consultar Access:', err);
    res.status(500).json({ error: err.message });
  }
});



app.listen(PORT, () => console.log(`Proxy Access corriendo en puerto ${PORT}`));
