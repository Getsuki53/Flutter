import mercadopago
from django.conf import settings
from decimal import Decimal

def crear_preferencia_pago(usuario, carrito):
    sdk = mercadopago.SDK(settings.MERCADO_PAGO_ACCESS_TOKEN)

    items = []
    for item in carrito.items.all():
        items.append({
            "title": item.producto.Nomprod,
            "quantity": item.unidades,
            "unit_price": float(Decimal(item.producto.Precio)),
            "currency_id": "ARS"
        })

    preference_data = {
        "items": items,
        "payer": {
            "email": usuario.correo,
            "name": usuario.nombre,
            "surname": usuario.apellido,
        },
        "back_urls": {
            "success": "https://www.google.com",  # URL pública
            "failure": "https://www.google.com",
            "pending": "https://www.google.com",
        },
        "auto_return": "approved",
        "binary_mode": True,  # Para evitar pagos en cuotas o parciales
    }

    preference_response = sdk.preference().create(preference_data)
    if "response" not in preference_response or "id" not in preference_response["response"]:
        raise Exception(f"Error al crear preferencia de pago: {preference_response}")
    preference = preference_response["response"]

    return preference["id"], preference["init_point"]
