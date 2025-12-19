# Tests para Lambda Functions

## Descripción

Tests unitarios para las funciones Lambda `get_visits` y `increment_visits` que manejan el contador de visitas de páginas.

## Características Importantes

### Protección contra valores negativos
Los tests verifican que el contador **NUNCA** pueda ser negativo:
- Páginas nuevas empiezan en 0 (o 1 después del primer incremento)
- La función `get_visits` retorna 0 si la página no existe
- La función `increment_visits` usa operaciones atómicas con `if_not_exists(visit_count, 0)`

## Instalación

```bash
# Instalar dependencias de test
pip install -r requirements-test.txt
```

## Ejecutar Tests

### Todos los tests
```bash
# Con unittest
python -m unittest discover -s . -p "test_*.py"

# Con pytest (más detallado)
pytest -v
```

### Tests específicos
```bash
# Solo get_visits
python -m unittest test_get_visits.py

# Solo increment_visits
python -m unittest test_increment_visits.py

# Un test específico
python -m unittest test_get_visits.TestGetVisits.test_get_visits_negative_value_protection
```

### Con cobertura
```bash
# Generar reporte de cobertura
pytest --cov=. --cov-report=html
python -m http.server 8000 -d htmlcov  # Ver reporte en navegador
```

## Tests Implementados

### test_get_visits.py
- ✅ `test_get_visits_existing_page`: Obtener visitas de página existente
- ✅ `test_get_visits_new_page`: Página nueva retorna 0
- ✅ `test_get_visits_zero_count`: Página con contador en 0
- ✅ `test_get_visits_negative_value_protection`: **Protección contra valores negativos**
- ✅ `test_get_visits_default_page_id`: Page ID por defecto
- ✅ `test_get_visits_cors_headers`: Headers CORS correctos
- ✅ `test_get_visits_error_handling`: Manejo de errores

### test_increment_visits.py
- ✅ `test_increment_visits_new_page`: Primera visita = 1
- ✅ `test_increment_visits_existing_page`: Incrementar página existente
- ✅ `test_increment_never_negative`: **El contador NUNCA puede ser negativo**
- ✅ `test_increment_from_zero`: Incrementar desde 0 da 1
- ✅ `test_increment_atomic_operation`: Operación atómica con if_not_exists
- ✅ `test_increment_default_page_id`: Page ID por defecto
- ✅ `test_increment_cors_headers`: Headers CORS
- ✅ `test_increment_error_handling`: Manejo de errores
- ✅ `test_increment_large_numbers`: Números grandes

## Validación Crítica: No Negativos

Los tests garantizan que:

1. **get_visits**: Retorna 0 si la página no existe
2. **increment_visits**: Usa `if_not_exists(visit_count, :start)` con `:start = 0`
3. **Ambas funciones**: Validación `assertGreaterEqual(count, 0)` en múltiples tests

## CI/CD

Para integrar en pipeline:

```yaml
# Ejemplo para GitHub Actions
- name: Run tests
  run: |
    pip install -r requirements-test.txt
    pytest --cov=. --cov-report=xml
    
- name: Upload coverage
  uses: codecov/codecov-action@v3
```

## Notas

- Los tests usan **mocks** de DynamoDB (no requieren AWS real)
- La variable de entorno `DYNAMODB_TABLE` se configura automáticamente en los tests
- Los tests son independientes y pueden ejecutarse en cualquier orden
