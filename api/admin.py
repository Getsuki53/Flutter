from django.contrib import admin
# Register your models here.
from api.models import Producto, Persona, Usuario, Administrador, ProductoDeseado, Tienda, SeguimientoTienda, Carrito, tipoCategoria, ItemCarrito, Pago

admin.site.register(Producto)
admin.site.register(Persona)
admin.site.register(Usuario)
admin.site.register(Administrador)
admin.site.register(ProductoDeseado)
admin.site.register(Tienda)
admin.site.register(SeguimientoTienda)
admin.site.register(Carrito)
admin.site.register(tipoCategoria)
admin.site.register(ItemCarrito)
admin.site.register(Pago)
