
class Producto {
  final int? id;
  final String nomprod;
  final String descripcionProd;
  final int stock;
  final String fotoProd;
  final double precio;
  final String tipoCategoria;
  final bool? estado;
  final DateTime? fechaPub;
  final int? idTienda;

  Producto({
    this.id,
    required this.nomprod,
    required this.descripcionProd,
    required this.stock,
    required this.fotoProd,
    required this.precio,
    required this.tipoCategoria,
    this.estado,
    this.fechaPub,
    this.idTienda,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'] as int?,
      nomprod: json['Nomprod'] as String,
      descripcionProd: json['DescripcionProd'] as String,
      stock: json['Stock'] as int,
      fotoProd: json['FotoProd'] as String,
      precio: _parsePrecio(json['Precio']),
      tipoCategoria: json['tipoCategoria'] as String,
      estado: json['Estado'] as bool?,
      fechaPub: json['FechaPub'] != null
          ? DateTime.parse(json['FechaPub'])
          : null,
      idTienda: json['tienda'] is int ? json['tienda'] : null,
    );
  }

  // Función de utilidad para convertir a double de forma segura
  static double _parsePrecio(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['Nomprod'] = nomprod;
    data['DescripcionProd'] = descripcionProd;
    data['Stock'] = stock;
    data['FotoProd'] = fotoProd;
    data['Precio'] = precio;
    data['Estado'] = estado;
    data['FechaPub'] = fechaPub?.toIso8601String();
    data['tipoCategoria'] = tipoCategoria;
    data['tienda'] = idTienda;
    return data;
  }
}