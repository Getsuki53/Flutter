class Config {
  static const String appName = "Handmade Geeks";
  static const String apiURL = '192.168.1.91'; // ✅ SIN :8000

  // Función helper para construir URLs completas
  static String buildUrl(String endpoint) {
    return 'http://$apiURL/$endpoint';
  }

  // Función helper para construir URLs completas de imágenes
  static String buildImageUrl(String imagePath) {
    if (imagePath.startsWith('http')) {
      return imagePath; // Ya es una URL completa
    }
    // Remover la barra inicial si existe
    String cleanPath =
        imagePath.startsWith('/') ? imagePath.substring(1) : imagePath;
    return 'http://$apiURL/$cleanPath';
  }

  // Endpoints básicos de modelos
  static const obtenerProductoMainAPI = "api/producto/obtenerproductomain";
  static const productoAPI = "api/producto";
  static const tiendaAPI = "api/tienda";
  static const loginAPI = "api/login-usuario/";
  static const obtenertokenAPI = "api/api-token-auth/";
  static const productoadminAPI = "api/productoadmin/";
  static const usuarioAPI = "api/usuario";
  static const administradorAPI = "api/administrador";
  static const productodeseadoAPI = "api/productodeseado";
  static const tipocategoriaAPI = "api/tipocategoria";
  static const carritoAPI = "api/carrito";
  static const seguimientotiendaAPI = "api/seguimientotienda";

  // Endpoints específicos de TIENDA
  static const tiendaObtenerProductoAPI = "api/tienda/ObtenerProducto/";
  static const tiendaBuscarAPI = "api/tienda/buscar";
  static const tiendaObtenerImgNomTiendaPorProductoAPI =
      "api/tienda/ObtenerImgNomTiendaPorProducto";
  static const tiendaCrearTiendaAPI = "api/tienda/CrearTienda";
  static const tiendaObtenerDetallesTiendaAPI =
      "api/tienda/ObtenerDetallesTienda";
  static const tiendaObtenerTiendaPorPropietarioAPI =
      "api/tienda/ObtenerTiendaPorPropietario";

  // Endpoints específicos de SEGUIMIENTO TIENDA
  static const seguimientoObtenerListaTiendasSeguidasPorUsuarioAPI =
      "api/SeguimientoTienda/ObtenerListaTiendasSeguidasPorUsuario";
  static const seguimientoObtenerListaUsuarioQueSiguenTiendaAPI =
      "api/SeguimientoTienda/ObtenerListaUsuarioQueSiguenTienda";
  static const seguimientoAgregarSeguimientoTiendaAPI =
      "api/SeguimientoTienda/AgregarSeguimientoTienda";
  static const seguimientoDejarDeSeguirTiendaAPI =
      "api/SeguimientoTienda/DejarDeSeguirTienda";

  // Endpoints específicos de PRODUCTO
  static const productoObtenerProductosPorTiendaAPI =
      "api/producto/obtenerproductosportienda";
  static const productoCrearProductoAPI = "api/producto/";
  static const productoadminObtenerProductoMainAPI =
      "api/productoadmin/obtenerproductomain";
  static const productoadminEliminarProductoAPI =
      "api/productoadmin/eliminarproducto";

  // Endpoints específicos de PRODUCTO DESEADO
  static const productodeseadoObtenerListaDeseadosPorUsuarioAPI =
      "api/productodeseado/ObtenerListaDeseadosPorUsuario/";
  static const productodeseadoObtenerListaUsuariosQueDeseanProductoAPI =
      "api/productodeseado/ObtenerListaUsuariosQueDeseanProducto";
  static const productodeseadoAgregarProductoDeseadoAPI =
      "api/productodeseado/AgregarProductoDeseado";
  static const productodeseadoEliminarProductoDeseadoAPI =
      "api/productodeseado/EliminarProductoDeseado";

  // Endpoints específicos de Carrito
  static const ObtenerProductoCarritoAPI =
      "api/producto/ObtenerProductosCarrito";

  // Endpoints específicos de USUARIO Y REGISTRO
  static const registroUsuarioAPI = "api/RegistroUsuario";
  static const logoutAPI = "api/Logout/logout-usuario";
  static const cambiarcontrasenaAPI = "api/usuario/CambiarContrasena/";
  static const itemCarritoAPI =
      "api/itemcarrito"; // Para agregar, actualizar o eliminar ítems del carrito
  static const checkoutAPI = "api/checkout/"; // Para iniciar el pago
  static const pagoAPI = "api/pago"; // Para consultar pagos
  static const actualizarEstadoPagoAPI =
      "api/actualizar_estado_pago/"; // Para actualizar el estado del pago y vaciar carrito
}
