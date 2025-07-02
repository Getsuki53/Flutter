from django.contrib import admin
from django.urls import path, include
from django.http import HttpResponse
from django.conf import settings
from django.conf.urls.static import static

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/', include('api.urls')),
    path('', lambda request: HttpResponse("Bienvenido a la API")),
] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)