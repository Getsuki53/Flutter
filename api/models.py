from django.db import models
import datetime
from django.core.exceptions import ValidationError
import secrets

# MODELO DE CATEGORÍA
class tipoCategoria(models.Model):
    NomCat = models.CharField(max_length=100, primary_key=True, verbose_name='Nombre de Categoria')

    def __str__(self):
        return self.NomCat

# MODELO BASE PERSONA
class Persona(models.Model):
    correo = models.EmailField('Correo', blank=True)
    contraseña = models.CharField('Contraseña', max_length=100)
    #class Meta:
    #    abstract = True

# MODELO USUARIO CON AUTENTICACIÓN PERSONALIZADA
class Usuario(Persona):
    nombre = models.CharField('Nombre', max_length=100)
    apellido = models.CharField('Apellido', default="vacio_", max_length=100)
    foto = models.ImageField(null=True, blank=True, upload_to='fotos/')
    token = models.CharField(max_length=64, blank=True, null=True, unique=True)  # Token personalizado

    @property
    def is_authenticated(self):
        return True

    def __str__(self):
        return '{0},{1}'.format(self.apellido, self.nombre)

# MODELO ADMINISTRADOR
class Administrador(Persona):
    def __str__(self):
        return '{0}'.format(self.correo)

# MODELO TIENDA
class Tienda(models.Model):
    Propietario = models.ForeignKey(Usuario, on_delete=models.CASCADE, verbose_name='Propietario', null=False, unique=True)
    NomTienda = models.CharField(max_length=200)
    Logo = models.ImageField(null=True, blank=True, upload_to='logos/')
    DescripcionTienda = models.TextField(blank=True)
    Cant_productos = models.PositiveIntegerField(default=0)
    Cant_seguidores = models.PositiveIntegerField(default=0)

    def __str__(self):
        return self.NomTienda

    def ActualizarCantidadProductos(self):
        self.Cant_productos = Producto.objects.filter(tienda=self).count()
        self.save()

# MODELO PRODUCTO
class Producto(models.Model):
    Nomprod = models.CharField(max_length=200)
    DescripcionProd = models.CharField(blank=True, max_length=200)
    Stock = models.PositiveIntegerField(default=0)
    FotoProd = models.ImageField(null=True, blank=True, upload_to='images/')
    Precio = models.DecimalField(max_digits=10, decimal_places=2)
    tipoCategoria = models.ForeignKey('tipoCategoria', on_delete=models.CASCADE, verbose_name='Tipo de Categoria', null=False)
    Estado = models.BooleanField(default=False)
    FechaPub = models.DateTimeField(default=datetime.datetime.now)
    tienda = models.ForeignKey(Tienda, on_delete=models.CASCADE, verbose_name='Tienda', null=False)

    def __str__(self):
        return self.Nomprod

# MODELO PRODUCTO DESEADO
class ProductoDeseado(models.Model):
    usuario = models.ForeignKey(Usuario, on_delete=models.CASCADE, verbose_name='Usuario', null=False)
    producto = models.ForeignKey(Producto, on_delete=models.CASCADE, verbose_name='Producto', null=False)

    def __str__(self):
        return f'{self.usuario} desea {self.producto}'

    class Meta:
        indexes = [
            models.Index(fields=['usuario', 'producto']),
        ]

# MODELO SEGUIMIENTO TIENDA
class SeguimientoTienda(models.Model):
    usuario = models.ForeignKey(Usuario, on_delete=models.CASCADE, verbose_name='Usuario', null=False)
    tienda = models.ForeignKey(Tienda, on_delete=models.CASCADE, verbose_name='Tienda', null=False)

    def __str__(self):
        return f'{self.usuario} sigue a {self.tienda}'

    class Meta:
        indexes = [
            models.Index(fields=['usuario', 'tienda']),
        ]

# MODELO CARRITO (UN CARRITO POR USUARIO)
class Carrito(models.Model):
    usuario = models.OneToOneField(
        Usuario,
        on_delete=models.CASCADE,
        related_name='carrito'
    )
    creado_en = models.DateTimeField(auto_now_add=True)
    actualizado_en = models.DateTimeField(auto_now=True)
    total = models.DecimalField(max_digits=10, decimal_places=2, default=0.00)

    def __str__(self):
        return f'Carrito de {self.usuario.nombre}'

    def actualizar_total(self):
        total = sum(item.subtotal for item in self.items.all())
        self.total = total
        self.save()
        return self.total

# MODELO ITEM CARRITO (PRODUCTOS EN EL CARRITO)
class ItemCarrito(models.Model):
    carrito = models.ForeignKey(
        Carrito,
        on_delete=models.CASCADE,
        related_name='items'
    )
    producto = models.ForeignKey(Producto, on_delete=models.CASCADE)
    unidades = models.PositiveIntegerField(default=1)
    subtotal = models.DecimalField(max_digits=10, decimal_places=2, default=0.00)

    def clean(self):
        if self.unidades > self.producto.Stock:
            raise ValidationError(f'Solo hay {self.producto.Stock} unidades de "{self.producto.Nomprod}".')

    def save(self, *args, **kwargs):
        self.full_clean()
        self.subtotal = self.unidades * self.producto.Precio
        super().save(*args, **kwargs)

    def __str__(self):
        return f'{self.unidades} x {self.producto.Nomprod}'

# MODELO PAGO (INTEGRACIÓN MERCADO PAGO)
class Pago(models.Model):
    ESTADOS = [
        ('pendiente', 'Pendiente'),
        ('aprobado', 'Aprobado'),
        ('rechazado', 'Rechazado'),
    ]

    usuario = models.ForeignKey(Usuario, on_delete=models.CASCADE)
    carrito = models.OneToOneField(Carrito, on_delete=models.CASCADE)
    estado = models.CharField(max_length=20, choices=ESTADOS, default='pendiente')
    preference_id = models.CharField(max_length=255, blank=True, null=True)
    fecha_creacion = models.DateTimeField(auto_now_add=True)
    fecha_actualizacion = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f'Pago de {self.usuario} ({self.estado})'

    class Meta:
        indexes = [
            models.Index(fields=['usuario', 'carrito', 'preference_id']),
        ]

    def marcar_aprobado(self):
        if self.estado == 'aprobado':
            raise ValidationError('Este pago ya está aprobado.')
        self.estado = 'aprobado'
        self.save()

    def marcar_rechazado(self):
        if self.estado == 'rechazado':
            raise ValidationError('Este pago ya está rechazado.')
        self.estado = 'rechazado'
        self.save()

    def registrar_preference_id(self, preference_id):
        self.preference_id = preference_id
        self.save()

    def save(self, *args, **kwargs):
        if self.estado not in dict(self.ESTADOS).keys():
            raise ValidationError(f'Estado "{self.estado}" no permitido.')
        super().save(*args, **kwargs)

# MODELO VENTA (OPCIONAL, PARA HISTORIAL)
class Venta(models.Model):
    comprador = models.ForeignKey(Usuario, on_delete=models.CASCADE, verbose_name='Usuario', null=False)
    productoComprado = models.ForeignKey(Producto, on_delete=models.CASCADE, verbose_name='Producto', null=False)
    cantidad = models.PositiveIntegerField(default=0)
    fecha = models.DateTimeField(default=datetime.datetime.now)

    def __str__(self):
        return f'{self.comprador} compró {self.productoComprado}'

    class Meta:
        indexes = [
            models.Index(fields=['comprador', 'productoComprado']),
        ]
