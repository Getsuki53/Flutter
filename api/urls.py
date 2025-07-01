from rest_framework import routers
from api.views import (
    ProductoViewSet, UsuarioViewSet, UserViewSet, LogoutView, 
     AdministradorViewSet, #VentaViewSet, 
    ProductoDeseadoViewSet, tipoCategoriaViewSet, CarritoViewSet, 
    TiendaViewSet, SeguimientoTiendaViewSet, ProductoAdminViewSet,
    LoginUsuarioView, RegistroUsuarioView, CheckoutView, MercadoPagoWebhookView, 
    ActualizarEstadoPagoView, ItemCarritoViewSet, PagoViewSet
)
from rest_framework.authtoken.views import obtain_auth_token
from django.urls import path

router = routers.DefaultRouter()
router.register('usuario', UsuarioViewSet)
router.register('administrador', AdministradorViewSet)
router.register('productodeseado', ProductoDeseadoViewSet)
router.register('tipocategoria', tipoCategoriaViewSet)
router.register('user', UserViewSet)
router.register('carrito', CarritoViewSet)
router.register('itemcarrito', ItemCarritoViewSet)
router.register('pago', PagoViewSet)
router.register('tienda', TiendaViewSet)
router.register('seguimientotienda', SeguimientoTiendaViewSet)
router.register('producto', ProductoViewSet, basename='producto')
router.register('productoadmin', ProductoAdminViewSet, basename='productoadmin')


urlpatterns = [
    path('api-token-auth/', obtain_auth_token, name='api_token_auth'),
    path('logout/', LogoutView.as_view()),
    path('login-usuario/', LoginUsuarioView.as_view()),
    path('registro-usuario/', RegistroUsuarioView.as_view()),
    path('checkout/', CheckoutView.as_view()),
    path('webhook-mercadopago/', MercadoPagoWebhookView.as_view()),
    path('actualizar-estado-pago/', ActualizarEstadoPagoView.as_view()),
] + router.urls
