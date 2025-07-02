from rest_framework.authentication import BaseAuthentication
from rest_framework import exceptions
from api.models import Usuario

class UsuarioTokenAuthentication(BaseAuthentication):
    def authenticate(self, request):
        auth_header = request.headers.get('Authorization')
        if not auth_header or not auth_header.startswith('Token '):
            return None
        token = auth_header.split(' ')[1]
        try:
            usuario = Usuario.objects.get(token=token)
        except Usuario.DoesNotExist:
            raise exceptions.AuthenticationFailed('Token inválido')
        return (usuario, None)