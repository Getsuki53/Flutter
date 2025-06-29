from django.db.models.signals import post_save, post_delete
from django.dispatch import receiver
from .models import ItemCarrito

@receiver([post_save, post_delete], sender=ItemCarrito)
def actualizar_total_carrito(sender, instance, **kwargs):
    carrito = instance.carrito
    carrito.actualizar_total()
