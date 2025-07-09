import 'package:appflutter/pages/Sesion/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Tienda/MiTienda.dart';
import '../Tienda/CrearTienda.dart';
import '../Seguidos/Seguidos.dart';
import '../Deseados/Deseados.dart';
import 'package:appflutter/services/usuario/api_perfil.dart';
import 'package:appflutter/services/tienda/api_tienda_por_propietario.dart';
import 'package:appflutter/models/usuario_modelo.dart';
import 'package:appflutter/config.dart';

class MiPerfil extends StatefulWidget {
  const MiPerfil({super.key});

  @override
  State<MiPerfil> createState() => _MiPerfilState();
}

class _MiPerfilState extends State<MiPerfil> {
  int? usuarioId;

  void cerrarSesion(BuildContext context) {
    // Aquí puedes limpiar cualquier estado o token si fuera necesario
    // Por ejemplo: await SharedPreferences.getInstance().then((prefs) => prefs.clear());

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  void initState() {
    super.initState();
    _loadUsuarioId();
  }

  Future<void> _loadUsuarioId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      usuarioId = prefs.getInt('usuario_id');
    });
  }

  Future<void> _navegarAMiTienda() async {
    if (usuarioId == null) return;

    try {
      // Consultar al backend si el usuario tiene una tienda
      final tienda = await APIObtenerTiendaPorPropietario.obtenerTiendaPorPropietario(usuarioId!);
      
      if (tienda != null && tienda.id != null) {
        // El usuario tiene una tienda, navegar a MiTienda
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MiTienda()),
        );
      } else {
        // El usuario no tiene tienda, navegar a CrearTienda
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CrearTienda()),
        );
      }
    } catch (e) {
      // En caso de error, mostrar un mensaje
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al verificar tienda: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1f1e2a),
      appBar: AppBar(title: const Text('Mi Perfil',
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: const Color(0xff383758),),
      
      body:
          usuarioId == null
              ? Center(child: Text("UsuarioID = $usuarioId"))
              : FutureBuilder<Usuario?>(
                future: APIPerfil.obtenerPerfil(usuarioId!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }
                  final usuario = snapshot.data;
                  if (usuario == null) {
                    return const Center(
                      child: Text("No se pudo cargar el perfil"),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 45,
                              backgroundImage:
                                  usuario.foto.isNotEmpty
                                      ? NetworkImage(
                                        usuario.foto.startsWith('http')
                                            ? usuario.foto
                                            : Config.buildImageUrl(
                                              usuario.foto,
                                            ),
                                      )
                                      : null,
                              child:
                                  usuario.foto.isEmpty
                                      ? const Icon(
                                        Icons.person,
                                        size: 45,
                                        color: Colors.grey,
                                      )
                                      : null,
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${usuario.nombre} ${usuario.apellido}",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(usuario.correo ?? '',
                                  style: TextStyle(color: Colors.white),),
                              ],
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 24),
                        // Botón "Mi Tienda"
                        Container(
                          height: 50,
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                          margin: const EdgeInsets.only(bottom: 24),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xffe8d0f8), Color(0xffae92f2), Color(0xff9dd5f3)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: usuarioId == null ? null : _navegarAMiTienda,
                              child: const Center(
                                child: Text(
                                  'Mi Tienda',
                                  style: TextStyle(color: Colors.white, fontSize: 18),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Botón "Tiendas Seguidas"
                        Container(
                          height: 50,
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                          margin: const EdgeInsets.only(bottom: 24),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xffe8d0f8), Color(0xffae92f2), Color(0xff9dd5f3)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const FollowedPage(),
                                  ),
                                );
                              },
                              child: const Center(
                                child: Text(
                                  'Tiendas Seguidas',
                                  style: TextStyle(color: Colors.white, fontSize: 18),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Botón "Lista de deseos"
                        Container(
                          height: 50,
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                          margin: const EdgeInsets.only(bottom: 24),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xffe8d0f8), Color(0xffae92f2), Color(0xff9dd5f3)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: usuarioId == null
                                  ? null
                                  : () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => WishedPage(usuario_id: usuarioId!),
                                        ),
                                      );
                                    },
                              child: const Center(
                                child: Text(
                                  'Lista de deseos',
                                  style: TextStyle(color: Colors.white, fontSize: 18),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Botón "Cerrar sesión"
                        Container(
                          height: 50,
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                          margin: const EdgeInsets.only(bottom: 24),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xffe8d0f8), Color(0xffae92f2), Color(0xff9dd5f3)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: () {
                                cerrarSesion(context);
                              },
                              child: const Center(
                                child: Text(
                                  'Cerrar sesión',
                                  style: TextStyle(color: Colors.white, fontSize: 18),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
    );
  }
}
