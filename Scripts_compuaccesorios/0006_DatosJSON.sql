-- Carga de productos desde un documento JSON (JSON -> tabla).
-- La estructura del documento esta descrita en JSON_Schema.json.
-- Se puede ejecutar varias veces: los productos que ya existen se omiten.

INSERT INTO productos (id, nombre_producto, precio_unitario_producto, cantidad_producto,
                       id_categoria, id_proveedor, id_inventario, especificaciones)
SELECT p.id, p.nombre_producto, p.precio_unitario_producto, p.cantidad_producto,
       p.id_categoria, p.id_proveedor, p.id_inventario,
       COALESCE(p.especificaciones, '{}')
FROM jsonb_to_recordset(($json$
{
  "productos": [
    {
      "id": 10001,
      "nombre_producto": "Mouse Inalambrico M185",
      "precio_unitario_producto": 45000,
      "cantidad_producto": 30,
      "id_categoria": 1,
      "id_proveedor": 1,
      "id_inventario": 1,
      "especificaciones": {
        "marca": "Logitech",
        "color": "Gris",
        "peso_gramos": 75,
        "compatibilidad": ["Windows", "macOS", "Linux"]
      }
    },
    {
      "id": 10002,
      "nombre_producto": "Teclado Mecanico K552",
      "precio_unitario_producto": 180000,
      "cantidad_producto": 12,
      "id_categoria": 2,
      "id_proveedor": 2,
      "id_inventario": 1,
      "especificaciones": {
        "marca": "Redragon",
        "color": "Negro",
        "peso_gramos": 860,
        "compatibilidad": ["Windows", "Linux"]
      }
    },
    {
      "id": 10003,
      "nombre_producto": "Audifonos Gamer H320",
      "precio_unitario_producto": 120000,
      "cantidad_producto": 20,
      "id_categoria": 3,
      "id_proveedor": 2,
      "id_inventario": 2,
      "especificaciones": {
        "marca": "Lenovo",
        "color": "Azul",
        "peso_gramos": 250,
        "compatibilidad": ["Windows", "macOS", "Android"]
      }
    },
    {
      "id": 10004,
      "nombre_producto": "Memoria USB 64GB",
      "precio_unitario_producto": 28000,
      "cantidad_producto": 50,
      "id_categoria": 3,
      "id_proveedor": 3,
      "id_inventario": 2,
      "especificaciones": {
        "marca": "Kingston",
        "color": "Negro",
        "peso_gramos": 10
      }
    },
    {
      "id": 10005,
      "nombre_producto": "Parlantes 2.0",
      "precio_unitario_producto": 60000,
      "cantidad_producto": 8,
      "id_categoria": 1,
      "id_proveedor": 3,
      "id_inventario": 1,
      "especificaciones": {
        "marca": "Samsung"
      }
    },
    {
      "id": 10006,
      "nombre_producto": "Base Refrigerante para Laptop",
      "precio_unitario_producto": 55000,
      "cantidad_producto": 15,
      "id_categoria": 2,
      "id_proveedor": 1,
      "id_inventario": 1
    }
  ]
}
$json$)::jsonb -> 'productos') AS p(id INT, nombre_producto VARCHAR, precio_unitario_producto INT,
                                   cantidad_producto INT, id_categoria INT, id_proveedor INT,
                                   id_inventario INT, especificaciones JSONB)
ON CONFLICT DO NOTHING;