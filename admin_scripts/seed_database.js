import { initializeApp, cert } from 'firebase-admin/app';
import { getAuth } from 'firebase-admin/auth';
import { getFirestore, Timestamp } from 'firebase-admin/firestore';
import { createRequire } from 'module';

const require = createRequire(import.meta.url);
const serviceAccount = require('../service-account-key.json');

// --- DATOS DE PRUEBA AMPLIADOS ---

const usuariosDePrueba = [
  {
    dni: '70111111',
    nombres: 'Ana',
    apellidos: 'García López',
    rol: 'trabajador',
    email: 'ana.g@epsel.com',
  },
  {
    dni: '70222222',
    nombres: 'Luis',
    apellidos: 'Martinez Solano',
    rol: 'trabajador',
    email: 'luis.m@epsel.com',
  },
  {
    dni: '70333333',
    nombres: 'Sofía',
    apellidos: 'Rodriguez Peña',
    rol: 'trabajador',
    email: 'sofia.r@epsel.com',
  },
  {
    dni: '70444444',
    nombres: 'Claudia',
    apellidos: 'Chavarry Paucar',
    rol: 'trabajador',
    email: 'claudia.c@epsel.com',
  },
  {
    dni: '70555555',
    nombres: 'Romina',
    apellidos: 'Brenis Pérez',
    rol: 'trabajador',
    email: 'romina.b@epsel.com',
  },
  {
    dni: '80111111',
    nombres: 'Jorge',
    apellidos: 'Chavez Costa',
    rol: 'jefe',
    email: 'jorge.c@epsel.com',
  },
];

const lecturasDePrueba = [
    { codigoSuministro: 'SUM-001', idRuta: 'ruta-prueba-1', lecturaActual: 125.5, estadoLectura: 'Leído' },
    { codigoSuministro: 'SUM-002', idRuta: 'ruta-prueba-1', lecturaActual: 340.0, estadoLectura: 'Leído' },
    { codigoSuministro: 'SUM-003', idRuta: 'ruta-prueba-2', lecturaActual: 88.0, estadoLectura: 'Atípico' },
];

// --- LÓGICA DEL SCRIPT ---

console.log('Iniciando script de seeding...');

try {
  initializeApp({
    credential: cert(serviceAccount),
  });
  console.log('Conexión con Firebase establecida.');
} catch (error) {
  console.error('Error al inicializar Firebase Admin:', error);
  process.exit(1);
}

const auth = getAuth();
const db = getFirestore();

async function seedDatabase() {
  console.log('--- SEMBRANDO USUARIOS ---');
  const uids = {}; // Para guardar los UIDs de los usuarios creados

  for (const userData of usuariosDePrueba) {
    try {
      console.log(`Creando usuario en Auth: ${userData.email}...`);
      const userRecord = await auth.createUser({
        email: userData.email,
        password: userData.dni,
        displayName: `${userData.nombres} ${userData.apellidos}`,
      });

      const uid = userRecord.uid;
      uids[userData.dni] = uid; // Guardamos el UID usando el DNI como clave
      console.log(` -> Usuario en Auth creado con UID: ${uid}`);

      const userDocRef = db.collection('usuarios').doc(uid);
      await userDocRef.set({
        id: uid,
        dni: userData.dni,
        nombres: userData.nombres,
        apellidos: userData.apellidos,
        rol: userData.rol,
      });
      console.log(` -> Documento en Firestore creado para ${userData.nombres}.`);
      
    } catch (error) {
      if (error.code === 'auth/email-already-exists') {
        console.warn(`ADVERTENCIA: El usuario con email ${userData.email} ya existe. Saltando...`);
        // Si ya existe, buscamos su UID para usarlo después
        const existingUser = await auth.getUserByEmail(userData.email);
        uids[userData.dni] = existingUser.uid;
      } else {
        console.error(`ERROR al procesar a ${userData.nombres}:`, error.message);
      }
    }
    console.log('---------------------------------');
  }

  console.log('\n--- SEMBRANDO RUTAS ASIGNADAS ---');
  try {
    const uidClaudia = uids['70444444']; // Obtenemos el UID de Claudia
    if (uidClaudia) {
      const rutaRef = db.collection('rutas_asignadas').doc('ruta-claudia-01');
      await rutaRef.set({
        idRuta: 'ruta-claudia-01',
        id_usuario: uidClaudia,
        fecha_asignacion: Timestamp.now(),
        estado: 'Pendiente',
        suministros: ['SUM-101', 'SUM-102', 'SUM-103', 'SUM-104'],
      });
      console.log('Ruta de prueba asignada a Claudia.');
    } else {
      console.warn('No se pudo encontrar el UID de Claudia para asignarle una ruta.');
    }
  } catch (error) {
    console.error('ERROR al sembrar rutas:', error.message);
  }
  console.log('---------------------------------');


  console.log('\n--- SEMBRANDO LECTURAS ---');
  for (const lecturaData of lecturasDePrueba) {
    try {
        const lecturaRef = db.collection('lecturas').doc(); // ID automático
        await lecturaRef.set({
            ...lecturaData,
            fecha_lectura: Timestamp.now(),
            lectura_anterior: 50.0, // Dato de ejemplo
            consumo_calculado: lecturaData.lecturaActual - 50.0,
            foto_url: '',
            latitud: -6.77,
            longitud: -79.84,
        });
        console.log(`Lectura para suministro ${lecturaData.codigoSuministro} creada.`);
    } catch (error) {
        console.error(`ERROR al crear lectura de prueba:`, error.message);
    }
  }
  console.log('---------------------------------');

  console.log('\n¡Seeding completado!');
}

seedDatabase();
