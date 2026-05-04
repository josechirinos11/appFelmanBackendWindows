const { execFile } = require("child_process");
const fs = require("fs");
const DB_PATH = "D:\\Compartido\\AppFelmanAccessMySQL\\access-proxy\\CONTROL_PRODUCCION_MONCADA_V42.2_LOCAL.accdb";
function queryAccess(sql) {
  return new Promise((resolve, reject) => {
    const sqlB64 = Buffer.from(sql, "utf8").toString("base64");
    const pyScript = [
      "import win32com.client, json, base64",
      'sql = base64.b64decode("' + sqlB64 + '").decode("utf-8")',
      'conn = win32com.client.Dispatch("ADODB.Connection")',
      'conn.Open("Provider=Microsoft.ACE.OLEDB.16.0;Data Source=D:\\\\Compartido\\\\AppFelmanAccessMySQL\\\\access-proxy\\\\CONTROL_PRODUCCION_MONCADA_V42.2_LOCAL.accdb;")',
      'rs = win32com.client.Dispatch("ADODB.Recordset")',
      "rs.Open(sql, conn)",
      "cols = [rs.Fields.Item(i).Name for i in range(rs.Fields.Count)]",
      "rows = []",
      "while not rs.EOF:",
      "    obj = {}",
      "    for i, col in enumerate(cols):",
      "        try:",
      "            v = rs.Fields.Item(i).Value",
      "            obj[col] = None if v is None else str(v)",
      "        except:",
      "            obj[col] = None",
      "    rows.append(obj)",
      "    rs.MoveNext()",
      "rs.Close()",
      "conn.Close()",
      "print(json.dumps(rows, ensure_ascii=False))"
    ].join("\n");
    const tmpFile = "C:\\temp_api\\q_" + Date.now() + ".py";
    fs.writeFileSync(tmpFile, pyScript, "utf8");
    execFile("python", [tmpFile],
      { maxBuffer: 100 * 1024 * 1024, timeout: 60000 },
      (err, stdout, stderr) => {
        try { fs.unlinkSync(tmpFile); } catch {}
        if (err) return reject(new Error(stderr || err.message));
        try {
          const txt = stdout.trim();
          if (!txt || txt === "[]") return resolve([]);
          const parsed = JSON.parse(txt);
          resolve(Array.isArray(parsed) ? parsed : [parsed]);
        } catch(e) {
          reject(new Error("Parse error: " + stdout.slice(0,200)));
        }
      }
    );
  });
}
module.exports = { queryAccess, DB_PATH };
