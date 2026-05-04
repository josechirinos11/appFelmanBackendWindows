const fs = require("fs");
const path = require("path");
const express = require("express");
const cors = require("cors");
const { exec } = require("child_process");
const { queryAccess, DB_PATH } = require("./psquery.js");

const app = express();
const PORT = process.env.PORT || 3001;

app.use(cors());
app.use(express.json());

const originDbFile = "\\\\192.168.1.81\\Compartido\\PRODUCCION_MONCADA\\CONTROL_PRODUCCION_MONCADA_V42.2.accdb";
try {
  if (fs.existsSync(originDbFile)) {
    fs.copyFileSync(originDbFile, DB_PATH);
    console.log("Copia local de BD creada correctamente");
  } else {
    console.log("BD remota no encontrada, usando copia local existente");
  }
} catch (err) {
  console.error("Error copiando BD:", err.message);
}

app.get("/api/pedidos", async (_, res) => {
  try {
    const rows = await queryAccess(`SELECT [Ejercicio] & '-' & [Serie] & '-' & [NPedido] AS NoPedido, Estado AS EstadoPedido, Incidencia, Format(FechaCompromiso, 'yyyy-mm-dd') AS Compromiso FROM BPedidos LEFT JOIN AEstadosPedido ON BPedidos.Id_EstadoPedido = AEstadosPedido.Id_EstadoPedido`);
    res.json(rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

app.get("/api/controlPedidoInicio", async (_, res) => {
  try {
    const rows = await queryAccess(`SELECT [BPedidos].[Ejercicio] & '-' & [BPedidos].[Serie] & '-' & [BPedidos].[NPedido] AS NoPedido, [ASecciones].[Seccion], [AClientes].[NombreCliente] AS Cliente, [BPedidos].[RefCliente], Format([BPedidos].[FechaCompromiso], 'yyyy-mm-dd') AS Compromiso, [AE].[Estado] AS EstadoPedido, [BCM].[Id_ControlMat], [AM].[Material], [AP].[Proveedor], Format([BCM].[FechaPrevista], 'yyyy-mm-dd') as FechaPrevista, [BCM].[Recibido] FROM (((((([BPedidos] INNER JOIN [AClientes] ON [BPedidos].[Id_Cliente] = [AClientes].[Id_Cliente]) INNER JOIN [ASecciones] ON [BPedidos].[Id_Seccion] = [ASecciones].[Id_Seccion]) INNER JOIN [AEstadosPedido] AS [AE] ON [BPedidos].[Id_EstadoPedido] = [AE].[Id_EstadoPedido]) LEFT JOIN [BControlMateriales] AS [BCM] ON [BPedidos].[Id_Pedido] = [BCM].[Id_Pedido]) LEFT JOIN [AMateriales] AS [AM] ON [BCM].[Id_Material] = [AM].[Id_Material]) LEFT JOIN [AProveedores] AS [AP] ON [BCM].[Id_Proveedor] = [AP].[Id_Proveedor]) WHERE [AE].[Estado] <> 'SERVIDO'`);
    res.json(rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

app.get("/api/controlPedidoInicio40Registro", async (_, res) => {
  try {
    const rows = await queryAccess(`SELECT TOP 40 [BPedidos].[Ejercicio] & '-' & [BPedidos].[Serie] & '-' & [BPedidos].[NPedido] AS NoPedido, [ASecciones].[Seccion], [AClientes].[NombreCliente] AS Cliente, [BPedidos].[RefCliente], Format([BPedidos].[FechaCompromiso], 'yyyy-mm-dd') AS Compromiso, [AE].[Estado] AS EstadoPedido, [BCM].[Id_ControlMat], [AM].[Material], [AP].[Proveedor], Format([BCM].[FechaPrevista], 'yyyy-mm-dd') as FechaPrevista, [BCM].[Recibido] FROM (([BPedidos] INNER JOIN [AClientes] ON [BPedidos].[Id_Cliente] = [AClientes].[Id_Cliente]) INNER JOIN [ASecciones] ON [BPedidos].[Id_Seccion] = [ASecciones].[Id_Seccion]) INNER JOIN [AEstadosPedido] AS [AE] ON [BPedidos].[Id_EstadoPedido] = [AE].[Id_EstadoPedido] LEFT JOIN (([BControlMateriales] AS [BCM] LEFT JOIN [AMateriales] AS [AM] ON [BCM].[Id_Material] = [AM].[Id_Material]) LEFT JOIN [AProveedores] AS [AP] ON [BCM].[Id_Proveedor] = [AP].[Id_Proveedor]) ON [BPedidos].[Id_Pedido] = [BCM].[Id_Pedido] WHERE [AE].[Estado] <> 'SERVIDO' AND [BCM].[FechaPrevista] >= Date() ORDER BY [BCM].[FechaPrevista] ASC`);
    res.json(rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

app.get("/api/incidencia", async (_, res) => {
  try {
    const pedidosConIncidencia = await queryAccess(`SELECT NPedido FROM BPedidos WHERE Incidencia = 'si'`);
    if (!pedidosConIncidencia.length) return res.json([]);
    const whereClause = pedidosConIncidencia.map(p => `[BPedidos].[NPedido] = ${p.NPedido}`).join(" OR ");
    const rows = await queryAccess(`SELECT [BPedidos].[Ejercicio] & '-' & [BPedidos].[Serie] & '-' & [BPedidos].[NPedido] AS NoPedido, ASecciones.Seccion, AClientes.NombreCliente AS Cliente, BPedidos.RefCliente, Format(BPedidos.FechaCompromiso, 'yyyy-mm-dd') AS Compromiso, BCM.Id_ControlMat, AM.Material, AP.Proveedor, Format(BCM.FechaPrevista, 'yyyy-mm-dd') as FechaPrevista, BCM.Recibido FROM ((((BPedidos INNER JOIN AClientes ON BPedidos.Id_Cliente = AClientes.Id_Cliente) INNER JOIN ASecciones ON BPedidos.Id_Seccion = ASecciones.Id_Seccion) LEFT JOIN BControlMateriales AS BCM ON BPedidos.Id_Pedido = BCM.Id_Pedido) LEFT JOIN AMateriales AS AM ON BCM.Id_Material = AM.Id_Material) LEFT JOIN AProveedores AS AP ON BCM.Id_Proveedor = AP.Id_Proveedor WHERE ${whereClause}`);
    res.json(rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

app.get("/api/pedidosComerciales", async (_, res) => {
  try {
    const rows = await queryAccess(`SELECT [BPedidos].[Ejercicio] & '-' & [BPedidos].[Serie] & '-' & [BPedidos].[NPedido] AS NoPedido, [ASecciones].[Seccion], [AClientes].[NombreCliente] AS Cliente, [AComerciales].[Comercial], [BPedidos].[RefCliente], Format([BPedidos].[FechaCompromiso], 'yyyy-mm-dd') AS Compromiso, [AE].[Estado] AS EstadoPedido, [BCM].[Id_ControlMat], [AM].[Material], [AP].[Proveedor], Format([BCM].[FechaPrevista], 'yyyy-mm-dd') as FechaPrevista, [BCM].[Recibido] FROM (((([BPedidos] INNER JOIN [AClientes] ON [BPedidos].[Id_Cliente] = [AClientes].[Id_Cliente]) INNER JOIN [AComerciales] ON [AClientes].[Id_Comercial] = [AComerciales].[Id_Comercial]) INNER JOIN [ASecciones] ON [BPedidos].[Id_Seccion] = [ASecciones].[Id_Seccion]) INNER JOIN [AEstadosPedido] AS [AE] ON [BPedidos].[Id_EstadoPedido] = [AE].[Id_EstadoPedido]) LEFT JOIN (([BControlMateriales] AS [BCM] LEFT JOIN [AMateriales] AS [AM] ON [BCM].[Id_Material] = [AM].[Id_Material]) LEFT JOIN [AProveedores] AS [AP] ON [BCM].[Id_Proveedor] = [AP].[Id_Proveedor]) ON [BPedidos].[Id_Pedido] = [BCM].[Id_Pedido] WHERE [AE].[Estado] <> 'SERVIDO'`);
    res.json(rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

app.get("/api/pedidosComercialesJeronimoN8N", async (_, res) => {
  try {
    const rows = await queryAccess(`SELECT [BPedidos].[Ejercicio] & '-' & [BPedidos].[Serie] & '-' & [BPedidos].[NPedido] AS NoPedido, [ASecciones].[Seccion], [AClientes].[NombreCliente] AS Cliente, [AComerciales].[Comercial], [AComerciales].[Email] AS EmailComercial, [BPedidos].[RefCliente], Format([BPedidos].[FechaCompromiso], 'yyyy-mm-dd') AS Compromiso, [AE].[Estado] AS EstadoPedido, [BCM].[Id_ControlMat], [AM].[Material], [AP].[Proveedor], Format([BCM].[FechaPrevista], 'yyyy-mm-dd') as FechaPrevista, [BCM].[Recibido] FROM (((([BPedidos] INNER JOIN [AClientes] ON [BPedidos].[Id_Cliente] = [AClientes].[Id_Cliente]) INNER JOIN [AComerciales] ON [AClientes].[Id_Comercial] = [AComerciales].[Id_Comercial]) INNER JOIN [ASecciones] ON [BPedidos].[Id_Seccion] = [ASecciones].[Id_Seccion]) INNER JOIN [AEstadosPedido] AS [AE] ON [BPedidos].[Id_EstadoPedido] = [AE].[Id_EstadoPedido]) LEFT JOIN (([BControlMateriales] AS [BCM] LEFT JOIN [AMateriales] AS [AM] ON [BCM].[Id_Material] = [AM].[Id_Material]) LEFT JOIN [AProveedores] AS [AP] ON [BCM].[Id_Proveedor] = [AP].[Id_Proveedor]) ON [BPedidos].[Id_Pedido] = [BCM].[Id_Pedido]`);
    res.json(rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

app.get("/api/pedidosComercialesJeronimoN8N_completa", async (_, res) => {
  try {
    const rows = await queryAccess(`SELECT [BPedidos].[Ejercicio] & '-' & [BPedidos].[Serie] & '-' & [BPedidos].[NPedido] AS NoPedido, [ASecciones].[Seccion], [AClientes].[NombreCliente] AS Cliente, [AComerciales].[Comercial], [AComerciales].[Email] AS EmailComercial, [BPedidos].[RefCliente], Format([BPedidos].[FechaCompromiso], 'yyyy-mm-dd') AS Compromiso, [AE].[Estado] AS EstadoPedido, Format([Ent].[FechaEnvio], 'yyyy-mm-dd') AS FechaEnvio, [BCM].[Id_ControlMat], [AM].[Material], [AP].[Proveedor], Format([BCM].[FechaPrevista], 'yyyy-mm-dd') as FechaPrevista, [BCM].[Recibido] FROM ((((([BPedidos] INNER JOIN [AClientes] ON [BPedidos].[Id_Cliente] = [AClientes].[Id_Cliente]) INNER JOIN [AComerciales] ON [AClientes].[Id_Comercial] = [AComerciales].[Id_Comercial]) INNER JOIN [ASecciones] ON [BPedidos].[Id_Seccion] = [ASecciones].[Id_Seccion]) INNER JOIN [AEstadosPedido] AS [AE] ON [BPedidos].[Id_EstadoPedido] = [AE].[Id_EstadoPedido]) LEFT JOIN (SELECT [DL].[Id_Pedido], Max([DD].[FechaEnvio]) AS FechaEnvio FROM [DEntregasLineas] AS [DL] INNER JOIN [DEntregasDiarias] AS [DD] ON [DL].[Id_Entrega] = [DD].[Id_Entrega] GROUP BY [DL].[Id_Pedido]) AS [Ent] ON [BPedidos].[Id_Pedido] = [Ent].[Id_Pedido]) LEFT JOIN (([BControlMateriales] AS [BCM] LEFT JOIN [AMateriales] AS [AM] ON [BCM].[Id_Material] = [AM].[Id_Material]) LEFT JOIN [AProveedores] AS [AP] ON [BCM].[Id_Proveedor] = [AP].[Id_Proveedor]) ON [BPedidos].[Id_Pedido] = [BCM].[Id_Pedido]`);
    res.json(rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

app.get("/api/pedidosComercialesJeronimoN8N_completa_tipoTrabajo", async (_, res) => {
  try {
    const rows = await queryAccess(`SELECT [BPedidos].[Ejercicio] & '-' & [BPedidos].[Serie] & '-' & [BPedidos].[NPedido] AS NoPedido, [ASecciones].[Seccion], [AClientes].[NombreCliente] AS Cliente, [AComerciales].[Comercial], [AComerciales].[Email] AS EmailComercial, [BPedidos].[RefCliente], Format([BPedidos].[FechaCompromiso], 'yyyy-mm-dd') AS Compromiso, [AE].[Estado] AS EstadoPedido, Format([Ent].[FechaEnvio], 'yyyy-mm-dd') AS FechaEnvio, [BCM].[Id_ControlMat], [AM].[Material], [AP].[Proveedor], Format([BCM].[FechaPrevista], 'yyyy-mm-dd') as FechaPrevista, [BCM].[Recibido], Format([BCM].[FechaPedido], 'yyyy-mm-dd') AS FechaPedido, [BCM].[NumeroPedido] AS NumeroPedido, Format([BPedidos].[FechaPedido], 'yyyy-mm-dd') AS FechaAltaPedido, [ATT].[TipoTrabajo] AS TipoTrabajo, [BPT].[NFab] AS NFab, [BPT].[Unidades] AS Unidades, [BPedidos].[ColorGeneral], [AFT].[FormatoTrabajo], [BPedidos].[Unidades] AS Unidades_del_Pedido, [BPedidos].[Orden] FROM ((((((([BPedidos] INNER JOIN [AClientes] ON [BPedidos].[Id_Cliente] = [AClientes].[Id_Cliente]) INNER JOIN [AComerciales] ON [AClientes].[Id_Comercial] = [AComerciales].[Id_Comercial]) INNER JOIN [ASecciones] ON [BPedidos].[Id_Seccion] = [ASecciones].[Id_Seccion]) INNER JOIN [AEstadosPedido] AS [AE] ON [BPedidos].[Id_EstadoPedido] = [AE].[Id_EstadoPedido]) LEFT JOIN [AFormatoTrabajo] AS [AFT] ON [BPedidos].[Id_Formato] = [AFT].[Id_Formato]) LEFT JOIN (SELECT [DL].[Id_Pedido], Max([DD].[FechaEnvio]) AS FechaEnvio FROM [DEntregasLineas] AS [DL] INNER JOIN [DEntregasDiarias] AS [DD] ON [DL].[Id_Entrega] = [DD].[Id_Entrega] GROUP BY [DL].[Id_Pedido]) AS [Ent] ON [BPedidos].[Id_Pedido] = [Ent].[Id_Pedido]) LEFT JOIN (([BControlMateriales] AS [BCM] LEFT JOIN [AMateriales] AS [AM] ON [BCM].[Id_Material] = [AM].[Id_Material]) LEFT JOIN [AProveedores] AS [AP] ON [BCM].[Id_Proveedor] = [AP].[Id_Proveedor]) ON [BPedidos].[Id_Pedido] = [BCM].[Id_Pedido]) LEFT JOIN ([BPartes_trabajo] AS [BPT] LEFT JOIN [ATipoTrabajo] AS [ATT] ON [BPT].[Id_TipoTrabajo] = [ATT].[Id_TipoTrabajo]) ON [BPedidos].[Id_Pedido] = [BPT].[Id_Pedido]`);
    res.json(rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

app.get("/api/controlEntregaDiaria", async (_, res) => {
  try {
    const rows = await queryAccess(`SELECT DED.Id_Entrega, Format(DED.FechaEnvio, 'yyyy-mm-dd') AS FechaEnvio, DED.EntregaConfirmada, DED.EstadoCarga, DED.ObservaGral, DEL.Id_LineaEntrega, DEL.Id_Pedido, DEL.Observaciones, DEL.NCaballetes, DEL.NBultos, DEL.Id_ResponsableEnvio, DEL.Id_EstadoEntrega, DEL.DocuAdjunta, DEL.Id_LugarEntrega, DEL.NSCaballetes, BPedidos.Ejercicio & '-' & BPedidos.Serie & '-' & BPedidos.NPedido AS NoPedido, BPedidos.RefCliente, AClientes.NombreCliente AS Cliente, AComerciales.Comercial FROM ((((DEntregasDiarias AS DED INNER JOIN DEntregasLineas AS DEL ON DED.Id_Entrega = DEL.Id_Entrega) INNER JOIN BPedidos ON DEL.Id_Pedido = BPedidos.Id_Pedido) INNER JOIN AClientes ON BPedidos.Id_Cliente = AClientes.Id_Cliente) INNER JOIN AComerciales ON AClientes.Id_Comercial = AComerciales.Id_Comercial)`);
    res.json(rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

app.get("/api/controlEntregaDiariaA1DIA", async (_, res) => {
  try {
    const rows = await queryAccess(`SELECT DED.Id_Entrega, Format(DED.FechaEnvio, 'yyyy-mm-dd') AS FechaEnvio, DED.EntregaConfirmada, DED.EstadoCarga, DED.ObservaGral, DEL.Id_LineaEntrega, DEL.Id_Pedido, DEL.Observaciones, DEL.NCaballetes, DEL.NBultos, DEL.Id_ResponsableEnvio, DEL.Id_EstadoEntrega, DEL.DocuAdjunta, DEL.Id_LugarEntrega, DEL.NSCaballetes, BPedidos.Ejercicio & '-' & BPedidos.Serie & '-' & BPedidos.NPedido AS NoPedido, BPedidos.RefCliente, AClientes.NombreCliente AS Cliente, AComerciales.Comercial FROM ((((DEntregasDiarias AS DED INNER JOIN DEntregasLineas AS DEL ON DED.Id_Entrega = DEL.Id_Entrega) INNER JOIN BPedidos ON DEL.Id_Pedido = BPedidos.Id_Pedido) INNER JOIN AClientes ON BPedidos.Id_Cliente = AClientes.Id_Cliente) INNER JOIN AComerciales ON AClientes.Id_Comercial = AComerciales.Id_Comercial) WHERE DED.FechaEnvio >= DateAdd('d', -90, Date()) AND DED.FechaEnvio <= Date() ORDER BY DED.FechaEnvio DESC`);
    res.json(rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

app.get("/api/test-access", (_, res) => res.send("OK - psquery"));

app.post("/api/webhook", (req, res) => {
  res.json({ message: "Webhook recibido" });
  setTimeout(() => {
    exec("cd D:/Compartido/AppFelmanAccessMySQL/access-proxy && git pull", (err, stdout) => {
      if (err) return console.error("Error git pull:", err.message);
      console.log("git pull:", stdout);
      exec("pm2 restart AppFelmanWindows && pm2 save", (error, out) => {
        if (error) return console.error("Error pm2:", error.message);
        console.log("pm2 restart:", out);
      });
    });
  }, 1000);
});

app.listen(PORT, () => console.log(`Proxy Access corriendo en puerto ${PORT}`)).on("error", (err) => {
  console.error("ERROR listen:", err);
  process.exit(1);
});
