class Config {
  static const String appName = "Handmade Geeks";
  static const String apiURL = 'hgeeks-backend.onrender.com';

  // Función helper para construir URLs completas con debugging
  static String buildUrl(String endpoint) {
    final url = 'https://$apiURL/$endpoint';
    return url;
  }

  // Función helper para construir URLs completas de imágenes
  static String buildImageUrl(String imagePath) {
    if (imagePath.startsWith('http')) {
      return imagePath;
    }
    String cleanPath = imagePath.startsWith('/') ? imagePath.substring(1) : imagePath;
    final url = 'https://$apiURL/$cleanPath';
    print('🖼️ [CONFIG] URL de imagen construida: $url');
    return url;
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
  static const iniciarMercadoPagoAPI = "api/mercadopago/iniciar/";
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

  static const tiendaVerificarPropietarioProdAPI =
      "api/tienda/VerificarPropietarioPorProducto";

  // Endpoints específicos de SEGUIMIENTO TIENDA
  static const seguimientoObtenerListaTiendasSeguidasPorUsuarioAPI =
      "api/seguimientotienda/ObtenerListaTiendasSeguidasPorUsuario";
  static const seguimientoObtenerListaUsuarioQueSiguenTiendaAPI =
      "api/seguimientotienda/ObtenerListaUsuarioQueSiguenTienda";
  static const seguimientoVerificarSeguimientoAPI =
      "api/seguimientotienda/VerificarSeguimiento";
  static const seguimientoAgregarSeguimientoTiendaAPI =
      "api/seguimientotienda/AgregarSeguimientoTienda";
  static const seguimientoDejarDeSeguirTiendaAPI =
      "api/seguimientotienda/DejarDeSeguirTienda";

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

  static const ActualizarCantidadCarritoAPI =
      "api/carrito/ActualizarCantidadCarrito/";
  static const EliminarProductoCarritoAPI =
      "api/carrito/EliminarProductodelCarrito/";

  //

  // Endpoints específicos de USUARIO Y REGISTRO
  static const registroUsuarioAPI = "api/RegistroUsuario";
  static const logoutAPI = "api/Logout/logout-usuario";
  static const cambiarcontrasenaAPI = "api/usuario/CambiarContrasena/";
}