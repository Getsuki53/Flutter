from rest_framework import serializers
from api.models import (
    Administrador, Carrito, ItemCarrito, 
    Persona, Producto, ProductoDeseado, SeguimientoTienda, 
    Tienda, Usuario, tipoCategoria, Pago, 
)
from django.contrib.auth.models import User
from rest_framework.authtoken.models import Token

# SERIALIZER DE ÍTEM DEL CARRITO CON VALIDACIÓN DE STOCK
class ItemCarritoSerializer(serializers.ModelSerializer):
    class Meta:
        model = ItemCarrito
        fields = ['id', 'producto', 'unidades', 'subtotal']

    def validate(self, data):
        producto = data['producto']
        unidades = data['unidades']
        if unidades > producto.Stock:
            raise serializers.ValidationError(
                f'Solo hay {producto.Stock} unidades disponibles de "{producto.Nomprod}".'
            )
        return data

# SERIALIZER DE PRODUCTO
class ProductoSerializer(serializers.ModelSerializer):
    class Meta:
        model = Producto
        fields = '__all__'
        read_only_fields = ('created_at',)

class ProductoMainSerializer(serializers.ModelSerializer):
    class Meta:
        model = Producto
        fields = ['Nomprod', 'Precio', 'FotoProd']

class ProductoCarritoSerializer(serializers.ModelSerializer):
    class Meta:
        model = Producto
        fields = ['Nomprod', 'Precio', 'FotoProd', 'Stock']

# SERIALIZER DE USUARIO
class UsuarioSerializer(serializers.ModelSerializer):
    class Meta:
        model = Usuario
        fields = '__all__'

# SERIALIZER DE ADMINISTRADOR
class AdministradorSerializer(serializers.ModelSerializer):
    class Meta:
        model = Administrador
        fields = '__all__'

# SERIALIZER DE PRODUCTO DESEADO
class ProductoDeseadoSerializer(serializers.ModelSerializer):
    class Meta:
        model = ProductoDeseado
        fields = '__all__'

# SERIALIZER DE CATEGORÍA
class tipoCategoriaSerializer(serializers.ModelSerializer):
    class Meta:
        model = tipoCategoria
        fields = '__all__'

# SERIALIZER DE CARRITO (ANIDA ÍTEMS)
class CarritoSerializer(serializers.ModelSerializer):
    items = ItemCarritoSerializer(many=True, read_only=True)
    class Meta:
        model = Carrito
        fields = ['id', 'usuario', 'items', 'total', 'creado_en', 'actualizado_en']
        read_only_fields = ['total', 'creado_en', 'actualizado_en']

# SERIALIZER DE TIENDA
class TiendaSerializer(serializers.ModelSerializer):
    class Meta:
        model = Tienda
        fields = '__all__'

# SERIALIZER DE SEGUIMIENTO DE TIENDA
class SeguimientoTiendaSerializer(serializers.ModelSerializer):
    class Meta:
        model = SeguimientoTienda
        fields = '__all__'

# SERIALIZER DE PAGO (ANIDA CARRITO)
class PagoSerializer(serializers.ModelSerializer):
    carrito = CarritoSerializer(read_only=True)
    usuario = serializers.PrimaryKeyRelatedField(read_only=True)
    class Meta:
        model = Pago
        fields = [
            'id',
            'usuario',
            'carrito',
            'estado',
            'preference_id',
            'fecha_creacion',
            'fecha_actualizacion',
        ]
        read_only_fields = [
            'estado',
            'preference_id',
            'fecha_creacion',
            'fecha_actualizacion',
        ]

# SERIALIZER DE USUARIO DE DJANGO
class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id', 'first_name', 'last_name', 'username', 'password', 'groups', 'email']
        extra_kwargs = {
            'password': {'write_only': True, 'required': True}
        }
    def create(self, validated_data):
        user = User.objects.create_user(**validated_data)
        Token.objects.create(user=user)
        return user
