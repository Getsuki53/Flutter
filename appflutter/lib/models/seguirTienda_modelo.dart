import 'usuario_modelo.dart';
import 'tienda_modelo.dart';

class SeguimientoTienda{
  late Usuario usuario;
  late Tienda tienda;

  SeguimientoTienda({
    required this.usuario,
    required this.tienda,
  });

  factory SeguimientoTienda.fromJson(Map<String, dynamic> json) {
    return SeguimientoTienda(
      usuario: Usuario.fromJson(json['usuario']),
      tienda: Tienda.fromJson(json['tienda']),
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['usuario'] = usuario.toJson();
    data['tienda'] = tienda.toJson();
    return data;
  }
}