class Config {
  static const String appName = "Handmade Geeks";
  static const String apiURL = '192.168.1.6'; // Cambia esto por la IP de tu servidor
  //obtiene todos los productos del main con estado 1
  static const obtenerProductoMainAPI = "api/producto/obtenerproductomain";
  //obtiene todos los productos base de datos
  static const productoAPI = "api/producto";
  //todas las tienda que existen o api/tienda/id siendo id el numero de id de la tienda
  static const tiendaAPI = "api/tienda";
  static const loginAPI = "api/login/";
  static const obtenertokenAPI = "api/api-token-auth/";
  static const productoadminAPI = "api/productoadmin/";
  static const usuarioAPI = "api/usuario/";
  static const administradorAPI = "api/administrador";
  static const productodeseadoAPI = "api/productodeseado";
  static const tipocategoriaAPI = "api/tipocategoria";
  static const carritoAPI = "api/carrito";
  static const seguimientotiendaAPI = "api/seguimientotienda";

}