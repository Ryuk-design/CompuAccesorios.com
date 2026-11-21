UPDATE productos
SET especificaciones = jsonb_build_object(
    'marca',          (ARRAY['Logitech','HP','Genius','Kingston','Redragon','Samsung','Lenovo','Sony'])[1 + id % 8],
    'color',          (ARRAY['Negro','Blanco','Gris','Azul','Rojo'])[1 + id % 5],
    'peso_gramos',    50 + id % 500,
    'compatibilidad', CASE id % 3
                          WHEN 0 THEN '["Windows","Linux"]'::jsonb
                          WHEN 1 THEN '["Windows","macOS"]'::jsonb
                          ELSE '["Windows","Linux","macOS","Android"]'::jsonb
                      END
)
WHERE especificaciones = '{}';