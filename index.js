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

app.get('/api/controlPedidoInicio', async (req, res) => {
  const page = parseInt(req.query.page || '1');
  const pageSize = parseInt(req.query.pageSize || '50');
  const offset = (page - 1) * pageSize;

  try {
    const rows = await connection.query(`
      SELECT TOP ${pageSize}
        Sub.NoPedido, Sub.Seccion, Sub.Cliente, Sub.RefCliente, Sub.Compromiso,
        Sub.Id_ControlMat, Sub.Material, Sub.Proveedor, Sub.FechaPrevista, Sub.Recibido
      FROM (
        SELECT
          [BPedidos].[Ejercicio] & '-' & [BPedidos].[Serie] & '-' & [BPedidos].[NPedido] AS NoPedido,
          ASecciones.Seccion,
          AClientes.NombreCliente AS Cliente,
          BPedidos.RefCliente,
          BPedidos.FechaCompromiso AS Compromiso,
          BCM.Id_ControlMat,
          AM.Material,
          AP.Proveedor,
          BCM.FechaPrevista,
          BCM.Recibido,
          BPedidos.Id_Pedido
        FROM (((BPedidos
          INNER JOIN AClientes ON BPedidos.Id_Cliente = AClientes.Id_Cliente)
          INNER JOIN ASecciones ON BPedidos.Id_Seccion = ASecciones.Id_Seccion)
          LEFT JOIN BControlMateriales AS BCM ON BPedidos.Id_Pedido = BCM.Id_Pedido)
          LEFT JOIN AMateriales AS AM ON BCM.Id_Material = AM.Id_Material
          LEFT JOIN AProveedores AS AP ON BCM.Id_Proveedor = AP.Id_Proveedor
      ) AS Sub
      WHERE Sub.Id_Pedido NOT IN (
        SELECT TOP ${offset} Id_Pedido
        FROM BPedidos
      )
    `);
    res.json(rows);
  } catch (err) {
    console.error('Error al consultar Access:', err);
    res.status(500).json({ error: err.message });
  }
});







app.listen(PORT, () => console.log(`Proxy Access corriendo en puerto ${PORT}`));
