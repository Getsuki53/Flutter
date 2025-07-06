OBSERVACIÓN: Siempre que llamen a un modelo, es decir, no un metodo. Se vera
de la siguiente forma: "api/modelo" en cambio cuando llaman a un metodo, se vera
de la siguiente forma: "api/modelo/metodo", entonces si quisieran obtener todos
lo que tiene esa tabla especifica basta con hacer un get "api/modelo" para cualquiera
Un ejemplo de esto es el "api/producto" que entrega todos los productos de la base
de datos (aunque en este caso particular los que tienen estado=1), asimismo, para
llamar a un dato especifico de esa tabla basta con api/modelo/id.

-------------------------Endpoints de TIENDA-------------------------------------------
"api/tienda": Entrega los atributos de todas las tiendas una por una. Un ejemplo
seria get 192.168.1.91/api/tienda para obtener todas las tiendas de la base de datos
o tambien 192.168.1.91/api/tienda/id siendo el id el id de la tienda, esto entrega los
datos de una tienda especifica de la base de datos ingresando el id de tal tienda.

"api/tienda/ObtenerProducto/ Recibe un id de producto y retorna la tienda a la que pertenece(toda la tienda no solo id)
un ejemplo de uso seria GET 192.168.1.91/api/tienda/ObtenerProducto/4 lo que daria
la tienda a la que pertenece el producto con id 4

"api/tienda/buscar"; Para este metodo se debe dar el nombre de la tienda que se busca, es
un metodo get.

"api/tienda/ObtenerImgNomTiendaPorProducto"; Esto devuelve la imagen y el nombre
de la tienda. Se debe dar el id del producto. Esto sirve para cuando se muestra un
producto, abajo mostrar el logo de la tienda y su nombre.

"api/tienda/CrearTienda"; Esto es un post para ingresar todos los valores de la tienda

"api/tienda/ObtenerDetallesTienda"; Esto se utiliza para obtener los detalles de una
tienda especifica dando el id de la tienda.

-------------------------Endpoints de SEGUIMIENTO TIENDA----------------------------------
"api/seguimientotienda"; Este Entrega la id del seguidor y el id de la tienda que sigue.

"api/SeguimientoTienda/ObtenerListaTiendasSeguidasPorUsuario"; Esto da el id de las
tiendas que sigue un usuario, para esto se debe dar el id del usuario.

"api/SeguimientoTienda/ObtenerListaUsuarioQueSiguenTienda"; Esto da el id de los usuarios
que siguen una tienda en especifico, para esto se debe dar el id de la tienda.

"api/SeguimientoTienda/AgregarSeguimientoTienda"; Esto agrega un seguimiento a la lista
de seguidos en la bdd, a esto se le debe dar el id del usuario y el de la tienda.
Para utilizarlo es un POST.

"api/SeguimientoTienda/DejarDeSeguirTienda"; Lo mismo que arriba pero esto es con un
DELETE para eliminar un seguimiento de tienda.

-------------------------Endpoints de PRODUCTO------------------------------------------
"api/producto"; Entrega todos los productos de la base de datos que sean visibles
es decir, con estado=1. 
Para conseguir uno especifico basta con api/producto/3 entregando esto el producto con
id=3

"api/producto/obtenerproductomain"; obtiene un producto del main sin todos los atributos,
solo precio, nombre, e imagen ('Nomprod', 'Precio', 'FotoProd') que es lo que se muestra
en el main, este al igual que los demas para llamar a uno especifico se llama de la siguiente
manera: api/producto/obtenerproductomain/id 

"api/productoadmin/"; mismo uso de producto, pero entrega los productos con estado=0
este se utiliza para la vista del admin.

"api/productoadmin/obtenerproductomain"; obtiene todos los productos
 que no sean visibles en la base de datos
 con atributos ('Nomprod', 'Precio', 'FotoProd') y se utiliza igual que en
 api/producto/obtenerproductomain, es decir: api/productoadmin/obtenerproductomain/id 

"api/productoadmin/eliminarproducto"; con este metodo se ingresa un id de un producto
y se elimina el producto de la bdd, esto sirve para cuando el admin habilita o borra
productos en su pagina.

"api/producto/obtenerproductosportienda"; esto sirve para obtener los productos de
una tienda especifica, despues del endpoint se ingresa el id de la tienda. Un ejemplo
de uso seria GET 192.168.1.91/api/producto/obtenerproductosportienda/id siendo el id
de la tienda.

"api/producto/ObtenerProductosCarrito"; Esto es para obtener tooodos los productos del
usuario que tiene en el carrito, un ejemplo de uso es el siguiente:
http://192.168.1.91/api/producto/ObtenerProductosCarrito/?usuario_id=2 lo cual daria
los productos del carrito del usuario con id 2.

---------------------------Endpoints de ProductoDeseado---------------------------------
"api/productodeseado/ObtenerListaDeseadosPorUsuario/"; Esto se utiliza para
obtener la lista de productos deseados por el usuario. Para utilizarlo deben poner
el id del usuario como vimos en los demas ejemplos. Se usa con un GET

"api/productodeseado/ObtenerListaUsuariosQueDeseanProducto"; Esto entrega la lista
de usuarios que desean un producto en especifico. Para usarlo deben dar el id del
producto.

"api/productodeseado/AgregarProductoDeseado"; Se usa para agregar un producto a deseados.
para usarlo deben dar el id del usuario y el id del producto que se desea.

"api/productodeseado/EliminarProductoDeseado"; Se usa para borrar un producto deseado por
el usuario, para usar esto es un DELETE y se deben dar el id del usuario y el id del producto

---------------------------Endpoints de Usuario y Registro---------------------------------
"api/usuario/CrearUsuario"; esto se ocupa con un POST para ingresar un usuario al sistema
el ejemplo es este, el nombre el correo y la contraseña con obligatorios.
{
  "nombre": "Juan",
  "apellido": "Pérez",
  "correo": "juan@ejemplo.com",
  "contrasena": "miclave123"
}

"api/usuario/"; obtiene a todos los usuarios de la bdd y si quieren uno especifico
seria api/usuario/id siendo id la clave primaria de usuario, creo que seria el correo
en este caso.

"api/usuario/CambiarContrasena/"; Se ingresa id de usuario con la nueva contraseña. Su uso
seria http://192.168.1.91/api/usuario/CambiarContrasena/ y con un json de la forma:
{
  "usuario_id": 2,
  "nueva_contrasena": "ola123"
}


---------------------------Endpoints de Persona---------------------------------

"api/Login/login-usuario" Metodo post para hacer login. En el body se pone correo y contraseña
"api/Logout/logout-usuario" Metodo post para hace Logout. Se pone el correo.

--------------------------Endpoints de Tipo Categorias---------------------------
 "api/tipocategoria"; obtiene todas las categorias existentes en la base de datos



