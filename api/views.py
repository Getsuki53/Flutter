from rest_framework import viewsets, permissions, status, views, response, authentication
from rest_framework.response import Response
from rest_framework.decorators import action
from django.contrib.auth.models import User
from django.contrib.auth import logout, authenticate, login
from rest_framework.authtoken.models import Token
from django.shortcuts import get_object_or_404
from django.views.decorators.csrf import csrf_exempt
from django.utils.decorators import method_decorator
import secrets
from api.models import (
    Producto, Usuario, 
    Administrador, ProductoDeseado, tipoCategoria, 
    Carrito, Tienda, SeguimientoTienda, ItemCarrito, Pago
)
from api.serializers import (
    ProductoSerializer, 
    UsuarioSerializer, UserSerializer, 
    AdministradorSerializer,
    ProductoDeseadoSerializer, tipoCategoriaSerializer, 
    CarritoSerializer, TiendaSerializer, SeguimientoTiendaSerializer, 
    ItemCarritoSerializer, PagoSerializer
)
# from api.utils import crear_preferencia_pago  # Temporarily commented out
from api.auth_usuario import UsuarioTokenAuthentication
# import mercadopago  # Temporarily commented out
from django.conf import settings


class AdministradorViewSet(viewsets.ModelViewSet):
    queryset = Administrador.objects.all()
    serializer_class = AdministradorSerializer
    permission_classes = [permissions.AllowAny]
    authentication_classes = [authentication.BasicAuthentication,]

    @action(detail=False, methods=['post'])
    def AutenticarAdministrador(self, request):
        username = request.data.get('username')
        password = request.data.get('password')
        if not username or not password:
            return Response({'error': 'Debes enviar username y password'}, status=400)
        try:
            administrador = Administrador.objects.get(username=username, password=password)
            return Response({'message': 'Administrador autenticado exitosamente'}, status=200)
        except Administrador.DoesNotExist:
            return Response({'error': 'Administrador no encontrado o credenciales incorrectas'}, status=404)
        
# ENDPOINTS DE PRODUCTO (ADMIN Y USUARIO)
class ProductoAdminViewSet(viewsets.ModelViewSet):
    queryset = Producto.objects.filter(Estado=False)
    serializer_class = ProductoSerializer
    permission_classes = [permissions.AllowAny]

    @action(detail=False, methods=['get'])
    def ObtenerProductoMain(self, request):
        producto_id = request.query_params.get('producto_id')
        if not producto_id:
            return Response({'error': 'Debes enviar producto_id'}, status=400)
        try:
            producto = Producto.objects.get(pk=producto_id)
            serializer = ProductoSerializer(producto)
            return Response(serializer.data)
        except Producto.DoesNotExist:
            return Response({'error': 'Producto no encontrado'}, status=404)

    @action(detail=True, methods=['patch'])
    def ActualizarEstadoProducto(self, request, pk=None):
        try:
            producto = Producto.objects.get(pk=pk)
            producto.Estado = True
            producto.save()
            tienda = producto.tienda
            tienda.Cant_productos = Producto.objects.filter(tienda=tienda, Estado=True).count()
            tienda.save()
            return Response({'message': 'Estado del producto actualizado exitosamente y cantidad de productos actualizada'}, status=200)
        except Producto.DoesNotExist:
            return Response({'error': 'Producto no encontrado'}, status=404)

    @action(detail=False, methods=['delete'])
    def EliminarProducto(self, request):
        producto_id = request.data.get('producto_id')
        if not producto_id:
            return Response({'error': 'Debes enviar producto_id'}, status=400)
        try:
            producto = Producto.objects.get(pk=producto_id)
            producto.delete()
            return Response({'message': 'Producto eliminado exitosamente'}, status=200)
        except Producto.DoesNotExist:
            return Response({'error': 'Producto no encontrado'}, status=404)

class ProductoViewSet(viewsets.ModelViewSet):
    queryset = Producto.objects.filter(Estado=True)
    serializer_class = ProductoSerializer
    permission_classes = [permissions.AllowAny]

    @action(detail=False, methods=['get'])
    def ObtenerProductoMain(self, request):
        producto_id = request.query_params.get('producto_id')
        if not producto_id:
            return Response({'error': 'Debes enviar producto_id'}, status=400)
        try:
            producto = Producto.objects.get(pk=producto_id)
            serializer = ProductoSerializer(producto)
            return Response(serializer.data)
        except Producto.DoesNotExist:
            return Response({'error': 'Producto no encontrado'}, status=404)

    @action(detail=False, methods=['get'])
    def ObtenerProductosPorTienda(self, request):
        tienda_id = request.query_params.get('tienda_id')
        if not tienda_id:
            return Response({'error': 'Debes enviar tienda_id'}, status=400)
        try:
            tienda = Tienda.objects.get(pk=tienda_id)
            productos = Producto.objects.filter(tienda=tienda)
            serializer = self.get_serializer(productos, many=True)
            return Response(serializer.data)
        except Tienda.DoesNotExist:
            return Response({'error': 'Tienda no encontrada'}, status=404)

    @action(detail=False, methods=['get'])
    def ObtenerProductosCarrito(self, request):
        usuario_id = request.query_params.get('usuario_id')
        if not usuario_id:
            return Response({'error': 'Debes enviar usuario_id'}, status=400)
        try:
            usuario = Usuario.objects.get(pk=usuario_id)
            carrito = Carrito.objects.filter(usuario=usuario)
            serializer = CarritoSerializer(carrito, many=True)
            return Response(serializer.data)
        except Usuario.DoesNotExist:
            return Response({'error': 'Usuario no encontrado'}, status=404)

    @action(detail=False, methods=['patch'])
    def ActualizarEstadoProducto(self, request):
        producto_id = request.data.get('producto_id')
        if not producto_id:
            return Response({'error': 'Debes enviar producto_id'}, status=400)
        try:
            producto = Producto.objects.get(pk=producto_id)
            producto.Estado = True
            producto.save()
            return Response({'message': 'Estado del producto actualizado exitosamente'}, status=200)
        except Producto.DoesNotExist:
            return Response({'error': 'Producto no encontrado'}, status=404)

# ENDPOINTS DE USUARIO
class UsuarioViewSet(viewsets.ModelViewSet):
    queryset = Usuario.objects.all()
    serializer_class = UsuarioSerializer
    permission_classes = [permissions.AllowAny]
    authentication_classes = [authentication.BasicAuthentication,]

    @action(detail=False, methods=['get'])
    def ListaUsuarios(self, request):
        usuarios = Usuario.objects.all()
        serializer = self.get_serializer(usuarios, many=True)
        return Response(serializer.data)

    @action(detail=False, methods=['patch'])
    def CambiarContrasena(self, request):
        usuario_id = request.data.get('usuario_id')
        nueva_contrasena = request.data.get('nueva_contrasena')
        if not usuario_id or not nueva_contrasena:
            return Response({'error': 'Debes enviar usuario_id y nueva_contrasena'}, status=400)
        try:
            usuario = Usuario.objects.get(pk=usuario_id)
            usuario.contraseña = nueva_contrasena
            usuario.save()
            return Response({'message': 'Contraseña actualizada exitosamente'}, status=200)
        except Usuario.DoesNotExist:
            return Response({'error': 'Usuario no encontrado'}, status=404)

# ENDPOINTS DE AUTENTICACIÓN PERSONALIZADA
class LoginUsuarioView(views.APIView):
    permission_classes = []
    authentication_classes = []

    def post(self, request):
        correo = request.data.get('correo')
        contrasena = request.data.get('contrasena')
        if not correo or not contrasena:
            return Response({'error': 'Correo y contraseña requeridos'}, status=status.HTTP_400_BAD_REQUEST)
        try:
            usuario = Usuario.objects.get(correo=correo)
        except Usuario.DoesNotExist:
            return Response({'error': 'Usuario no existe'}, status=status.HTTP_404_NOT_FOUND)
        if usuario.contraseña != contrasena:
            return Response({'error': 'Contraseña incorrecta'}, status=status.HTTP_401_UNAUTHORIZED)
        # Generar token si no existe
        if not usuario.token:
            usuario.token = secrets.token_hex(32)
            usuario.save()
        return Response({'token': usuario.token, 'usuario_id': usuario.id})

# ENDPOINTS DE CARRITO 
class CarritoViewSet(viewsets.ModelViewSet):
    queryset = Carrito.objects.all()
    serializer_class = CarritoSerializer
    permission_classes = [permissions.IsAuthenticated]
    authentication_classes = [UsuarioTokenAuthentication]

    
    def get_queryset(self):
        usuario = self.request.user
        return Carrito.objects.filter(usuario=usuario)

    def retrieve(self, request, *args, **kwargs):
        usuario = request.user
        instance = get_object_or_404(Carrito, usuario=usuario)
        serializer = self.get_serializer(instance)
        return Response(serializer.data)

# ENDPOINTS DE ITEMS DEL CARRITO
class ItemCarritoViewSet(viewsets.ModelViewSet):
    queryset = ItemCarrito.objects.all()
    serializer_class = ItemCarritoSerializer
    permission_classes = [permissions.IsAuthenticated]
    authentication_classes = [UsuarioTokenAuthentication]

    def get_queryset(self):
        usuario = self.request.user
        return ItemCarrito.objects.filter(carrito__usuario=usuario)

    def perform_create(self, serializer):
        usuario = self.request.user
        carrito, _ = Carrito.objects.get_or_create(usuario=usuario)
        serializer.save(carrito=carrito)
    
    def partial_update(self, request, *args, **kwargs):
        instance = self.get_object()
        unidades = request.data.get('unidades')
        restar = request.data.get('restar')
        sumar = request.data.get('sumar')
        cantidad_final = instance.unidades

        if restar is not None:
            try:
                restar = int(restar)
            except ValueError:
                return Response({'error': 'La cantidad a restar debe ser un número entero.'}, status=400)
            cantidad_final = instance.unidades - restar
        elif sumar is not None:
            try:
                sumar = int(sumar)
            except ValueError:
                return Response({'error': 'La cantidad a sumar debe ser un número entero.'}, status=400)
            cantidad_final = instance.unidades + sumar
        elif unidades is not None:
            try:
                cantidad_final = int(unidades)
            except ValueError:
                return Response({'error': 'La cantidad debe ser un número entero.'}, status=400)

        if cantidad_final < 0:
            return Response({'error': 'La cantidad no puede ser menor a 0.'}, status=400)
        if cantidad_final > instance.producto.Stock:
            return Response({'error': f'Solo hay {instance.producto.Stock} unidades disponibles.'}, status=400)
        if cantidad_final == 0:
            instance.delete()
            return Response({'message': 'Ítem eliminado del carrito.'}, status=204)
        instance.unidades = cantidad_final
        instance.save()
        serializer = self.get_serializer(instance)
        return Response(serializer.data)

# ENDPOINTS DE PAGO Y MERCADO PAGO
class CheckoutView(views.APIView):
    permission_classes = [permissions.IsAuthenticated]
    authentication_classes = [UsuarioTokenAuthentication]

    def post(self, request):
        # Temporarily disabled mercadopago functionality
        return Response({
            "message": "Checkout temporarily disabled - MercadoPago not configured",
            "preference_id": "temp_preference_id",
            "init_point": "temp_init_point",
        }, status=status.HTTP_200_OK)
        
        # Original code commented out:
        # usuario = request.user
        # try:
        #     carrito = usuario.carrito
        # except Carrito.DoesNotExist:
        #     return Response({"error": "El carrito está vacío"}, status=status.HTTP_400_BAD_REQUEST)
        # preference_id, init_point = crear_preferencia_pago(usuario, carrito)
        # pago, created = Pago.objects.get_or_create(
        #     usuario=usuario,
        #     carrito=carrito,
        #     defaults={"estado": "pendiente"}
        # )
        # pago.preference_id = preference_id
        # pago.save()
        # return Response({
        #     "preference_id": preference_id,
        #     "init_point": init_point,
        # })

@method_decorator(csrf_exempt, name='dispatch')
class MercadoPagoWebhookView(views.APIView):
    def post(self, request):
        # Temporarily disabled mercadopago functionality
        return Response({'message': 'MercadoPago webhook temporarily disabled'}, status=status.HTTP_200_OK)
        
        # Original code commented out:
        # data = request.data
        # if data.get('type') != 'payment':
        #     return Response({'message': 'Evento ignorado'}, status=status.HTTP_200_OK)
        # payment_id = data.get('data', {}).get('id')
        # if not payment_id:
        #     return Response({'error': 'No payment_id'}, status=status.HTTP_400_BAD_REQUEST)
        # sdk = mercadopago.SDK(settings.MERCADO_PAGO_ACCESS_TOKEN)
        # payment_info = sdk.payment().get(payment_id)
        # payment = payment_info.get('response', {})
        # preference_id = payment.get('order', {}).get('id') or payment.get('preference_id')
        # status_mp = payment.get('status')
        # if not preference_id:
        #     return Response({'error': 'No preference_id en pago'}, status=status.HTTP_400_BAD_REQUEST)
        # try:
        #     pago = Pago.objects.get(preference_id=preference_id)
        # except Pago.DoesNotExist:
        #     return Response({'error': 'Pago no encontrado'}, status=status.HTTP_404_NOT_FOUND)
        # if status_mp == 'approved':
        #     pago.estado = 'aprobado'
        # elif status_mp == 'rejected':
        #     pago.estado = 'rechazado'
        # else:
        #     pago.estado = 'pendiente'
        # pago.save()
        # return Response({'message': f'Pago actualizado a {pago.estado}'}, status=status.HTTP_200_OK)

class PagoViewSet(viewsets.ModelViewSet):
    queryset = Pago.objects.all()
    serializer_class = PagoSerializer
    permission_classes = [permissions.IsAuthenticated]
    authentication_classes = [UsuarioTokenAuthentication]

    def get_queryset(self):
        return Pago.objects.filter(usuario=self.request.user)

# ENDPOINTS DESEADOS, TIENDA, SEGUIMIENTO, VENTA, ETC.
class ProductoDeseadoViewSet(viewsets.ModelViewSet):
    queryset = ProductoDeseado.objects.all()
    serializer_class = ProductoDeseadoSerializer
    permission_classes = [permissions.AllowAny]
    authentication_classes = [authentication.BasicAuthentication,]

    @action(detail=False, methods=['get'])
    def ObtenerListaDeseadosPorUsuario(self, request):
        usuario_id = request.query_params.get('usuario_id')
        if not usuario_id:
            return Response({'error': 'Debes enviar usuario_id'}, status=400)
        try:
            usuario = Usuario.objects.get(pk=usuario_id)
            productos_deseados = ProductoDeseado.objects.filter(usuario=usuario)
            serializer = self.get_serializer(productos_deseados, many=True)
            return Response(serializer.data)
        except Usuario.DoesNotExist:
            return Response({'error': 'Usuario no encontrado'}, status=404)
    
    @action(detail=False, methods=['get'])
    def ObtenerListaUsuariosQueDeseanProducto(self, request, pk=None):
        producto_id = request.query_params.get('producto_id')
        if not producto_id:
            return Response({'error': 'Debes enviar producto_id'}, status=400)
        try:
            producto = Producto.objects.get(pk=producto_id)
            usuarios_desean = ProductoDeseado.objects.filter(producto=producto)
            serializer = self.get_serializer(usuarios_desean, many=True)
            return Response(serializer.data)
        except Producto.DoesNotExist:
            return Response({'error': 'Producto no encontrado'}, status=status.HTTP_404_NOT_FOUND)
        
    @action(detail=False, methods=['post'])
    def AgregarProductoDeseado(self, request):
        usuario_id = request.data.get('usuario_id')
        producto_id = request.data.get('producto_id')
        if not usuario_id or not producto_id:
            return Response({'error': 'Debes enviar usuario_id y producto_id'}, status=400)
        try:
            usuario = Usuario.objects.get(pk=usuario_id)
            producto = Producto.objects.get(pk=producto_id)
            deseado, created = ProductoDeseado.objects.get_or_create(usuario=usuario, producto=producto)
            if created:
                return Response({'message': 'Producto agregado a deseos exitosamente'}, status=201)
            else:
                return Response({'message': 'El producto ya está en la lista de deseos'}, status=200)
        except (Usuario.DoesNotExist, Producto.DoesNotExist):
            return Response({'error': 'Usuario o Producto no encontrado'}, status=404)
    
    @action(detail=False, methods=['DELETE'])
    def EliminarProductoDeseado(self, request):
        usuario_id = request.data.get('usuario_id')
        producto_id = request.data.get('producto_id')
        if not usuario_id or not producto_id:
            return Response({'error': 'Debes enviar usuario_id y producto_id'}, status=400)
        try:
            usuario = Usuario.objects.get(pk=usuario_id)
            producto = Producto.objects.get(pk=producto_id)
            deseado = ProductoDeseado.objects.filter(usuario=usuario, producto=producto).first()
            if deseado:
                deseado.delete()
                return Response({'message': 'Producto eliminado de deseos exitosamente'}, status=200)
            else:
                return Response({'message': 'El producto no está en la lista de deseos'}, status=404)
        except (Usuario.DoesNotExist, Producto.DoesNotExist):
            return Response({'error': 'Usuario o Producto no encontrado'}, status=404)

class tipoCategoriaViewSet(viewsets.ModelViewSet):
    queryset = tipoCategoria.objects.all()
    serializer_class = tipoCategoriaSerializer
    permission_classes = [permissions.AllowAny]
    authentication_classes = [authentication.BasicAuthentication,]

class UserViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    permission_classes = [permissions.IsAdminUser,]
    authentication_classes = [authentication.BasicAuthentication,]

class TiendaViewSet(viewsets.ModelViewSet):
    queryset = Tienda.objects.all()  # Assuming you want to list products in the store
    serializer_class = TiendaSerializer 
    permission_classes = [permissions.AllowAny]
    authentication_classes = [authentication.BasicAuthentication,]

    @action(detail=False, methods=['get'])
    def buscar(self, request):
        nombre = request.query_params.get('nombre', None)
        if nombre:
            tiendas = Tienda.objects.filter(nombre__icontains=nombre)
        else:
            tiendas = Tienda.objects.all()
        serializer = self.get_serializer(tiendas, many=True)
        return Response(serializer.data)
    
    @action(detail=False, methods=['get'])
    def ObtenerImgNomTiendaPorProducto(self, request):
        producto_id = request.query_params.get('producto_id')
        if not producto_id:
            return Response({'error': 'Debes enviar producto_id'}, status=400)
        try:
            producto = Producto.objects.get(pk=producto_id)
            tienda = producto.tienda
            data = {
                'nombre': tienda.NomTienda,
                'imagen': tienda.Logo.url if tienda.Logo else None
            }
            return Response(data)
        except Producto.DoesNotExist:
            return Response({'error': 'Producto no encontrado'}, status=404)
        except AttributeError:
            return Response({'error': 'El modelo Tienda debe tener un campo imagen'}, status=500)
        
    @action(detail=False, methods=['post'])
    def CrearTienda(self, request):
        propietario_id = request.data.get('propietario_id')
        nombre_tienda = request.data.get('nombre_tienda')
        descripcion_tienda = request.data.get('descripcion_tienda', '')
        logo = request.FILES.get('logo', None)

        if not propietario_id or not nombre_tienda:
            return Response({'error': 'Debes enviar propietario_id y nombre_tienda'}, status=400)

        try:
            propietario = Usuario.objects.get(pk=propietario_id)
            tienda, created = Tienda.objects.get_or_create(Propietario=propietario, NomTienda=nombre_tienda)
            if created:
                tienda.DescripcionTienda = descripcion_tienda
                tienda.Logo = logo
                tienda.save()
                return Response({'message': 'Tienda creada exitosamente'}, status=201)
            else:
                return Response({'message': 'La tienda ya existe'}, status=200)
        except Usuario.DoesNotExist:
            return Response({'error': 'Usuario no encontrado'}, status=404)
    
    @action(detail=False, methods=['get'])
    def ObtenerDetallesTienda(self, request):
        tienda_id = request.query_params.get('tienda_id')
        if not tienda_id:
            return Response({'error': 'Debes enviar tienda_id'}, status=400)
        try:
            tienda = Tienda.objects.get(pk=tienda_id)
            serializer = self.get_serializer(tienda)
            return Response(serializer.data)
        except Tienda.DoesNotExist:
            return Response({'error': 'Tienda no encontrada'}, status=status.HTTP_404_NOT_FOUND)

class SeguimientoTiendaViewSet(viewsets.ModelViewSet):
    queryset = SeguimientoTienda.objects.all()  # Assuming you want to track products in the store
    serializer_class = SeguimientoTiendaSerializer
    permission_classes = [permissions.AllowAny]
    authentication_classes = [authentication.BasicAuthentication,]

    @action(detail=False, methods=['get'])
    def ObtenerListaTiendasSeguidasPorUsuario(self, request):
        usuario_id = request.query_params.get('usuario_id')
        if not usuario_id:
            return Response({'error': 'Debes enviar usuario_id'}, status=400)
        try:
            usuario = Usuario.objects.get(pk=usuario_id)
            tiendas_seguidas = SeguimientoTienda.objects.filter(usuario=usuario)
            serializer = self.get_serializer(tiendas_seguidas, many=True)
            return Response(serializer.data)
        except Usuario.DoesNotExist:
            return Response({'error': 'Usuario no encontrado'}, status=404)
        
    @action(detail=False, methods=['get'])
    def ObtenerListaUsuarioQueSiguenTienda(self, request, pk=None):
        tienda_id = request.query_params.get('tienda_id')
        if not tienda_id:
            return Response({'error': 'Debes enviar tienda_id'}, status=400)    
        try:
            tienda = Tienda.objects.get(pk=tienda_id)
            seguidores = SeguimientoTienda.objects.filter(tienda=tienda)
            serializer = self.get_serializer(seguidores, many=True)
            return Response(serializer.data)
        except Tienda.DoesNotExist:
            return Response({'error': 'Tienda no encontrada'}, status=status.HTTP_404_NOT_FOUND)

    @action(detail=False, methods=['post'])   
    def AgregarSeguimientoTienda(self, request):
        usuario_id = request.data.get('usuario_id')
        tienda_id = request.data.get('tienda_id')
        if not usuario_id or not tienda_id:
            return Response({'error': 'Debes enviar usuario_id y tienda_id'}, status=400)
        try:
            usuario = Usuario.objects.get(pk=usuario_id)
            tienda = Tienda.objects.get(pk=tienda_id)
            seguimiento, created = SeguimientoTienda.objects.get_or_create(usuario=usuario, tienda=tienda)
            #Subir la cantidad de seguidores de la tienda
            if seguimiento.tienda:
                seguimiento.tienda.CantidadSeguidores += 1
                seguimiento.tienda.save()
            if created:
                return Response({'message': 'Ahora sigues la tienda exitosamente'}, status=201)
            else:
                return Response({'message': 'Ya sigues esta tienda'}, status=200)
        except (Usuario.DoesNotExist, Tienda.DoesNotExist):
            return Response({'error': 'Usuario o Tienda no encontrado'}, status=404)

    @action(detail=False, methods=['DELETE'])
    def DejarDeSeguirTienda(self, request):
        usuario_id = request.data.get('usuario_id')
        tienda_id = request.data.get('tienda_id')
        if not usuario_id or not tienda_id:
            return Response({'error': 'Debes enviar usuario_id y tienda_id'}, status=400)
        try:
            usuario = Usuario.objects.get(pk=usuario_id)
            tienda = Tienda.objects.get(pk=tienda_id)
            seguimiento = SeguimientoTienda.objects.filter(usuario=usuario, tienda=tienda).first()
            if seguimiento:
                seguimiento.delete()
                return Response({'message': 'Has dejado de seguir la tienda exitosamente'}, status=200)
            else:
                return Response({'message': 'No estabas siguiendo esta tienda'}, status=404)
        except (Usuario.DoesNotExist, Tienda.DoesNotExist):
            return Response({'error': 'Usuario o Tienda no encontrado'}, status=404)

class LoginView(views.APIView):
    permission_classes = [permissions.AllowAny]
    def post(self, request):
        # Recuperamos las credenciales y autenticamos al usuario
        username2= request.data.get('username', None)
        password2 = request.data.get('password', None)
        if username2 is None or password2 is None:
            return response.Response({'message': 'Please provide both username and password'},status=status.HTTP_400_BAD_REQUEST)
        user2 = authenticate(username=username2, password=password2)
        if not user2:
            return response.Response({'message': 'Usuario o Contraseña incorrecto !!!! '},status=status.HTTP_404_NOT_FOUND)

        token, _ = Token.objects.get_or_create(user=user2)
        # Si es correcto añadimos a la request la información de sesión
        if user2:
            # para loguearse una sola vez
            # login(request, user)
            return response.Response({'message':'usuario y contraseña correctos!!!!'},status=status.HTTP_200_OK)
            #return response.Response({'token': token.key}, status=status.HTTP_200_OK)

        # Si no es correcto devolvemos un error en la petición
        return response.Response(status=status.HTTP_404_NOT_FOUND)        

class LogoutView(views.APIView):
    authentication_classes = [authentication.TokenAuthentication]
    def post(self, request):        
        request.user.auth_token.delete()
        # Borramos de la request la información de sesión
        logout(request)
        # Devolvemos la respuesta al cliente
        return response.Response({'message':'Sessión Cerrada y Token Eliminado !!!!'},status=status.HTTP_200_OK)

# ENDPOINT PARA ACTUALIZAR ESTADO DE PAGO Y VACIAR CARRITO
class ActualizarEstadoPagoView(views.APIView):
    def post(self, request):
        pago_id = request.data.get('pago_id')
        nuevo_estado = request.data.get('estado')
        if not pago_id or not nuevo_estado:
            return Response({'error': 'pago_id y estado son requeridos'}, status=status.HTTP_400_BAD_REQUEST)
        try:
            pago = Pago.objects.get(id=pago_id)
            pago.estado = nuevo_estado
            pago.save()
            debug_info = {}
            if nuevo_estado == 'aprobado':
                carrito = pago.carrito
                debug_info['carrito_id'] = carrito.id
                debug_info['items_antes'] = list(carrito.items.values('id', 'producto_id', 'unidades'))
                for item in carrito.items.all():
                    item.producto.Stock = max(0, item.producto.Stock - item.unidades)
                    item.producto.save()
                carrito.items.all().delete()
                debug_info['items_despues'] = list(carrito.items.values('id', 'producto_id', 'unidades'))
            return Response({'message': 'Estado actualizado y carrito vaciado', 'debug': debug_info}, status=status.HTTP_200_OK)
        except Pago.DoesNotExist:
            return Response({'error': 'Pago no encontrado'}, status=status.HTTP_404_NOT_FOUND)

