// Configuración del entorno para node-adodb
const fs = require('fs');
const path = require('path');
const express = require('express');
const ADODB = require('node-adodb');
const cors = require('cors');

// Forzar el uso de la versión de 64 bits de cscript.exe
process.env.ADODB_CSCRIPT = 'C:\\Windows\\System32\\cscript.exe';
console.log('Forzando el uso de cscript de System32 (64 bits)');

ADODB.debug = true;
const app = express();
const PORT = process.env.PORT || 3001;

// Habilitar CORS para todas las rutas
app.use(cors());

// Ruta a la base de datos Access - Usar una copia local si es posible
const originDbFile = '\\\\192.168.1.81\\Compartido\\PRODUCCION_MONCADA\\CONTROL_PRODUCCION_MONCADA_V40.accdb';
const localDbCopy = path.join(__dirname, 'CONTROL_PRODUCCION_MONCADA_V40_LOCAL.accdb');

// Crear una copia local de la base de datos para evitar problemas de bloqueo
try {
  if (fs.existsSync(originDbFile)) {
    console.log(`Base de datos remota encontrada en: ${originDbFile}`);
    console.log('Creando copia local para evitar problemas de bloqueo...');
    fs.copyFileSync(originDbFile, localDbCopy);
    console.log(`Copia local creada en: ${localDbCopy}`);
  } else {
    console.error(`La base de datos remota no existe en la ruta: ${originDbFile}`);
    if (!fs.existsSync(localDbCopy)) {
      console.error('No existe una copia local de respaldo. Imposible continuar.');
      process.exit(1);
    } else {
      console.log('Usando la copia local existente como respaldo.');
    }
  }
} catch (err) {
  console.error(`Error al intentar crear copia local: ${err.message}`);
  if (fs.existsSync(localDbCopy)) {
    console.log('Usando la copia local existente como respaldo.');
  } else {
    console.error('No hay copia local disponible. Intentando usar la remota directamente.');
  }
}

const dbFile = fs.existsSync(localDbCopy) ? localDbCopy : originDbFile;
console.log(`Usando base de datos en: ${dbFile}`);

// Intentar varias opciones de conexión con diferentes configuraciones
function createConnection() {
  try {
    // Opciones de conexión con manejo explícito de permisos y bloqueo
    return ADODB.open(
      `Provider=Microsoft.ACE.OLEDB.12.0;Data Source=${dbFile};Mode=Share Deny None;Jet OLEDB:Database Password=;User Id=Admin;Password=;`
    );
  } catch (error) {
    console.error('Error al crear la conexión:', error);
    // Intentar una configuración alternativa si la primera falla
    return ADODB.open(
      `Provider=Microsoft.ACE.OLEDB.12.0;Data Source=${dbFile};Mode=Read;Persist Security Info=False;`
    );
  }
}

// Crear la conexión
const connection = createConnection();

app.get('/api/pedidos', async (_, res) => {
  try {
    const rows = await connection.query(`SELECT
      [Ejercicio] & '-' & [Serie] & '-' & [NPedido] AS NºPedido,
      Estado AS EstadoPedido,
      Incidencia,
      FechaCompromiso AS Compromiso
    FROM BPedidos
    LEFT JOIN AEstadosPedido ON BPedidos.Id_EstadoPedido = AEstadosPedido.Id_EstadoPedido`);
    console.log(`Consulta a api/pedidos`);
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
        BPedidos.RefCliente,
        BPedidos.FechaCompromiso AS Compromiso,
        BCM.Id_ControlMat,
        AM.Material,
        AP.Proveedor,
        BCM.FechaPrevista,
        BCM.Recibido
      FROM ((((BPedidos
        INNER JOIN AClientes ON BPedidos.Id_Cliente = AClientes.Id_Cliente)
        INNER JOIN ASecciones ON BPedidos.Id_Seccion = ASecciones.Id_Seccion)
        LEFT JOIN BControlMateriales AS BCM ON BPedidos.Id_Pedido = BCM.Id_Pedido)
        LEFT JOIN AMateriales AS AM ON BCM.Id_Material = AM.Id_Material)
        LEFT JOIN AProveedores AS AP ON BCM.Id_Proveedor = AP.Id_Proveedor
    `);
    console.log(`Contrl Pedidos (${rows.length} registros):`, rows.slice(0, 5));
    res.json(rows);
  } catch (err) {
    console.error('Error al consultar Access:', err);
    res.status(500).json({ error: err.message });
  }
});




app.get('/api/incidencia', async (_, res) => {
  try {
    // 1. Obtener los NPedido donde Incidencia = 'si'
    const pedidosConIncidencia = await connection.query(`SELECT NPedido FROM BPedidos WHERE Incidencia = 'si'`);
    if (!pedidosConIncidencia.length) return res.json([]);

    // 2. Extraer NPedido y construir cláusula WHERE
    const pedidos = pedidosConIncidencia.map(p => p.NPedido);
    const whereClause = pedidos.map(n => `[BPedidos].[NPedido] = ${n}`).join(' OR ');

    // 3. Consultar los datos completos
    const query = `
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
        BCM.Recibido
      FROM ((((BPedidos
        INNER JOIN AClientes ON BPedidos.Id_Cliente = AClientes.Id_Cliente)
        INNER JOIN ASecciones ON BPedidos.Id_Seccion = ASecciones.Id_Seccion)
        LEFT JOIN BControlMateriales AS BCM ON BPedidos.Id_Pedido = BCM.Id_Pedido)
        LEFT JOIN AMateriales AS AM ON BCM.Id_Material = AM.Id_Material)
        LEFT JOIN AProveedores AS AP ON BCM.Id_Proveedor = AP.Id_Proveedor
      WHERE ${whereClause}
    `;
    
    const rows = await connection.query(query);
    console.log(`Incidencias (${rows.length} registros):`, rows.slice(0, 5));
    res.json(rows);
  } catch (err) {
    console.error('Error al consultar Access:', err);
    res.status(500).json({ error: err.message });
  }
});



app.get('/api/pedidosComerciales', async (_, res) => {
  try {
    const rows = await connection.query(`
      SELECT
  [BPedidos].[Ejercicio] & '-' & [BPedidos].[Serie] & '-' & [BPedidos].[NPedido] AS NoPedido,
  ASecciones.Seccion,
  AClientes.NombreCliente AS Cliente,
  AComerciales.Comercial,
  BPedidos.RefCliente,
  BPedidos.FechaCompromiso AS Compromiso,
  BCM.Id_ControlMat,
  AM.Material,
  AP.Proveedor,
  BCM.FechaPrevista,
  BCM.Recibido
FROM (((((BPedidos
  INNER JOIN AClientes ON BPedidos.Id_Cliente = AClientes.Id_Cliente)
  INNER JOIN AComerciales ON AClientes.Id_Comercial = AComerciales.Id_Comercial)
  INNER JOIN ASecciones ON BPedidos.Id_Seccion = ASecciones.Id_Seccion)
  LEFT JOIN BControlMateriales AS BCM ON BPedidos.Id_Pedido = BCM.Id_Pedido)
  LEFT JOIN AMateriales AS AM ON BCM.Id_Material = AM.Id_Material)
  LEFT JOIN AProveedores AS AP ON BCM.Id_Proveedor = AP.Id_Proveedor
    `);
    console.log(`Pedidos Comercial (${rows.length} registros):`, rows.slice(0, 5));
    res.json(rows);
  } catch (err) {
    console.error('Error al consultar Access:', err);
    res.status(500).json({ error: err.message });
  }
});


app.get('/api/controlEntregaDiaria', async (_, res) => {
  try {
    const rows = await connection.query(`
      SELECT
        DED.Id_Entrega,
        DED.FechaEnvio,
        DED.EntregaConfirmada,
        DED.EstadoCarga,
        DED.ObservaGral,
        DEL.Id_LineaEntrega,
        DEL.Id_Pedido,
        DEL.Observaciones,
        DEL.NCaballetes,
        DEL.NBultos,
        DEL.Id_ResponsableEnvio,
        DEL.Id_EstadoEntrega,
        DEL.DocuAdjunta,
        DEL.Id_LugarEntrega,
        DEL.NSCaballetes,
        BPedidos.Ejercicio & '-' & BPedidos.Serie & '-' & BPedidos.NPedido AS NoPedido,
        BPedidos.RefCliente,
        AClientes.NombreCliente AS Cliente,
        AComerciales.Comercial
      FROM ((((DEntregasDiarias AS DED
        INNER JOIN DEntregasLineas AS DEL ON DED.Id_Entrega = DEL.Id_Entrega)
        INNER JOIN BPedidos ON DEL.Id_Pedido = BPedidos.Id_Pedido)
        INNER JOIN AClientes ON BPedidos.Id_Cliente = AClientes.Id_Cliente)
        INNER JOIN AComerciales ON AClientes.Id_Comercial = AComerciales.Id_Comercial)
    `);
    console.log(`Control Entrega Diaria (${rows.length} registros):`, rows.slice(0, 5));
    res.json(rows);
  } catch (err) {
    console.error('Error al consultar Access (controlEntregaDiaria):', err);
    res.status(500).json({ error: err.message });
  }
});

app.get('/api/controlEntregaDiariaA1DIA', async (_, res) => {
  try {
    const rows = await connection.query(`
      SELECT
        DED.Id_Entrega,
        DED.FechaEnvio,
        DED.EntregaConfirmada,
        DED.EstadoCarga,
        DED.ObservaGral,
        DEL.Id_LineaEntrega,
        DEL.Id_Pedido,
        DEL.Observaciones,
        DEL.NCaballetes,
        DEL.NBultos,
        DEL.Id_ResponsableEnvio,
        DEL.Id_EstadoEntrega,
        DEL.DocuAdjunta,
        DEL.Id_LugarEntrega,
        DEL.NSCaballetes,
        BPedidos.Ejercicio & '-' & BPedidos.Serie & '-' & BPedidos.NPedido AS NoPedido,
        BPedidos.RefCliente,
        AClientes.NombreCliente AS Cliente,
        AComerciales.Comercial
      FROM ((((DEntregasDiarias AS DED
        INNER JOIN DEntregasLineas AS DEL ON DED.Id_Entrega = DEL.Id_Entrega)
        INNER JOIN BPedidos ON DEL.Id_Pedido = BPedidos.Id_Pedido)
        INNER JOIN AClientes ON BPedidos.Id_Cliente = AClientes.Id_Cliente)        INNER JOIN AComerciales ON AClientes.Id_Comercial = AComerciales.Id_Comercial)
      WHERE DED.FechaEnvio >= DateAdd('d', -90, Date()) 
        AND DED.FechaEnvio <= Date()
      ORDER BY DED.FechaEnvio DESC
    `);
    console.log(`Control Entrega Diaria Últimos 90 días (${rows.length} registros):`, rows.slice(0, 5));
    res.json(rows);
  } catch (err) {
    console.error('Error al consultar Access (controlEntregaDiariaA1DIA):', err);
    res.status(500).json({ error: err.message });
  }
});



app.get('/api/test-access', (_, res) => {
  console.log("Probando acceso a Access");
  res.send('acceso a access');
});

app.listen(PORT, () => console.log(`Proxy Access corriendo en puerto ${PORT}`));
