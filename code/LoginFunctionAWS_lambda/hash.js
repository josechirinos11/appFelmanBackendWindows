const bcrypt = require('bcryptjs');
const password = 'felman2025'; // Cambia por la contraseña que quieras

bcrypt.hash(password, 10, (err, hash) => {
  if (err) throw err;
  console.log('Hash:', hash);
});