import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'scanner_screen.dart'; 
import 'login_screen.dart'; 
import 'login_jefe_screen.dart';
import 'historial_lectura_screen.dart';
import 'perfil_screen.dart';
import 'selection_screen.dart';
import 'dashboard_jefe_screen.dart';
// import 'dashboard_jefe_screen.dart'; // Importar cuando crees el archivo de gráficas

void main() async {
  WidgetsFlutterBinding.ensureInitialized();  
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(MyApp(camera: firstCamera));
}

class MyApp extends StatefulWidget {
  final CameraDescription camera;
  const MyApp({super.key, required this.camera});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;
  String _usuarioActual = ""; 
  String _rolActual = ""; // "trabajador" o "jefe"

  // Función para manejar el login desde cualquier pantalla
  void _handleLogin(String nombre, String rol) { 
    setState(() {
      _isLoggedIn = true;
      _usuarioActual = nombre;
      _rolActual = rol;
    });
  }

  // Función para cerrar sesión y volver a la selección
  void _handleLogout() {
    setState(() {
      _isLoggedIn = false;
      _usuarioActual = "";
      _rolActual = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EPSEL Smart Reader',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF005696),
        useMaterial3: true,
      ),
      // Dentro del build de MaterialApp
      home: _isLoggedIn 
          ? (_rolActual == "jefe" 
              ? DashboardJefeScreen(onLogout: _handleLogout) // <--- Cambio realizado
              : HomePage(
                  camera: widget.camera, 
                  nombreUsuario: _usuarioActual, 
                  onLogout: _handleLogout,
                )) 
          : SelectionScreen(onLogin: _handleLogin),
    );
  }
}

// --- PANTALLA PRINCIPAL PARA TRABAJADORES ---
class HomePage extends StatefulWidget {
  final CameraDescription camera;
  final String nombreUsuario;
  final VoidCallback onLogout;

  const HomePage({
    super.key, 
    required this.camera, 
    required this.nombreUsuario, 
    required this.onLogout
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: const Color(0xFF005696),
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset('assets/images/logo_epsel.jpeg', height: 45, width: 45, fit: BoxFit.cover),
            ),
            const SizedBox(width: 15),
            const Flexible(
              child: Text(
                'SISTEMA DE LECTURA DE MEDIDORES',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 0.5),
              ),
            ),
            const SizedBox(width: 60), 
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text('Hoy', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(15),
              children: [
                GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HistorialLecturaScreen(camera: widget.camera))),
                  child: _buildTaskItem("Tienes una tarea asignada", "23/09/2024 21:00", "No leído", Colors.orange),
                ),
                _buildTaskItem("Tienes una nueva tarea", "22/09/2024 8:00", "Leído", Colors.green),
                _buildTaskItem("Revisión de una lectura atípica", "21/09/2024 10:00", "Leído", Colors.green),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavbar(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF005696),
        shape: const CircleBorder(),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ScannerScreen(camera: widget.camera))),
        child: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Notificaciones', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Stack(
            children: [
              const Icon(Icons.notifications_none_outlined, size: 35, color: Color(0xFF005696)),
              Positioned(
                right: 0, top: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                  constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                  child: const Text('1', style: TextStyle(color: Colors.white, fontSize: 11), textAlign: TextAlign.center),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavbar() {
    return Container(
      height: 75,
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 25),
      decoration: BoxDecoration(
        color: const Color(0xFF005696),
        borderRadius: BorderRadius.circular(35),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset('assets/images/logo_epsel.jpeg', height: 35, width: 35, fit: BoxFit.cover),
          ),
          IconButton(
            icon: Icon(Icons.home_filled, color: _selectedIndex == 0 ? Colors.lightBlueAccent : Colors.white, size: 28),
            onPressed: () => setState(() => _selectedIndex = 0),
          ),
          IconButton(
            icon: Icon(Icons.assignment, color: _selectedIndex == 1 ? Colors.lightBlueAccent : Colors.white, size: 28),
            onPressed: () {
              setState(() => _selectedIndex = 1);
              Navigator.push(context, MaterialPageRoute(builder: (context) => HistorialLecturaScreen(camera: widget.camera)));
            },
          ),
          IconButton(
            icon: Icon(Icons.person, color: _selectedIndex == 2 ? Colors.lightBlueAccent : Colors.white, size: 28),
            onPressed: () {
              setState(() => _selectedIndex = 2);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const PerfilScreen()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.power_settings_new, color: Colors.white, size: 28),
            onPressed: widget.onLogout,
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(String title, String date, String status, Color statusColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xFFE3F2FD),
            radius: 25,
            child: Icon(Icons.chat_bubble_outline, color: Color(0xFF005696)),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text(date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(10)),
                  child: Text(status, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- CLASE PARA EL DASHBOARD DEL JEFE (PENDIENTE DISEÑO) ---
class PlaceholderDashboardJefe extends StatelessWidget {
  const PlaceholderDashboardJefe({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      appBar: AppBar(
        title: const Text("DASHBOARD ADMINISTRATIVO", style: TextStyle(color: Colors.white, fontSize: 14)),
        backgroundColor: const Color(0xFF002B49),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.analytics, size: 100, color: Color(0xFF002B49)),
            const SizedBox(height: 20),
            const Text("Bienvenido, Jefe de Zona", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Text("Aquí se mostrarán las estadísticas de Chiclayo"),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Simulación de logout para volver a la selección
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => MyApp(camera: (context.findAncestorWidgetOfExactType<MyApp>()!).camera)),
                  (route) => false
                );
              },
              child: const Text("Cerrar Sesión")
            )
          ],
        ),
      ),
    );
  }
}