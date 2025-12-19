import unittest
from unittest.mock import patch, MagicMock
import json
import os
from increment_visits import lambda_handler


class TestIncrementVisits(unittest.TestCase):
    """Tests para la función increment_visits Lambda"""
    
    def setUp(self):
        """Configuración inicial para cada test"""
        os.environ['DYNAMODB_TABLE'] = 'test-table'
    
    @patch('increment_visits.table')
    def test_increment_visits_new_page(self, mock_table):
        """Test: Incrementar visitas en una página nueva (debe empezar en 1)"""
        # Configurar mock - primera visita
        mock_table.update_item.return_value = {
            'Attributes': {
                'visit_count': 1
            }
        }
        
        event = {
            'pathParameters': {'page_id': 'new-page'}
        }
        
        response = lambda_handler(event, None)
        
        # Verificaciones
        self.assertEqual(response['statusCode'], 200)
        body = json.loads(response['body'])
        self.assertEqual(body['page_id'], 'new-page')
        self.assertEqual(body['visit_count'], 1)
        self.assertIn('message', body)
        
        # Verificar que se llamó update_item correctamente
        mock_table.update_item.assert_called_once()
        call_args = mock_table.update_item.call_args
        self.assertEqual(call_args[1]['Key'], {'page_id': 'new-page'})
    
    @patch('increment_visits.table')
    def test_increment_visits_existing_page(self, mock_table):
        """Test: Incrementar visitas en una página existente"""
        mock_table.update_item.return_value = {
            'Attributes': {
                'visit_count': 43
            }
        }
        
        event = {
            'pathParameters': {'page_id': 'home'}
        }
        
        response = lambda_handler(event, None)
        
        # Verificaciones
        self.assertEqual(response['statusCode'], 200)
        body = json.loads(response['body'])
        self.assertEqual(body['visit_count'], 43)
        self.assertGreaterEqual(body['visit_count'], 1)
    
    @patch('increment_visits.table')
    def test_increment_never_negative(self, mock_table):
        """Test: El contador NUNCA puede ser negativo después de incrementar"""
        # Simular múltiples incrementos
        test_cases = [1, 5, 10, 100, 1000]
        
        for count in test_cases:
            with self.subTest(count=count):
                mock_table.update_item.return_value = {
                    'Attributes': {'visit_count': count}
                }
                
                event = {'pathParameters': {'page_id': f'page-{count}'}}
                response = lambda_handler(event, None)
                
                body = json.loads(response['body'])
                # CRÍTICO: El contador nunca debe ser negativo
                self.assertGreaterEqual(body['visit_count'], 0, 
                                       f"El contador no puede ser negativo. Valor: {body['visit_count']}")
                self.assertGreater(body['visit_count'], 0,
                                  "Después de incrementar, el contador debe ser mayor que 0")
    
    @patch('increment_visits.table')
    def test_increment_from_zero(self, mock_table):
        """Test: Incrementar desde 0 debe dar 1"""
        mock_table.update_item.return_value = {
            'Attributes': {'visit_count': 1}
        }
        
        event = {'pathParameters': {'page_id': 'zero-page'}}
        response = lambda_handler(event, None)
        
        body = json.loads(response['body'])
        self.assertEqual(body['visit_count'], 1)
        # Asegurar que no es negativo
        self.assertGreaterEqual(body['visit_count'], 0)
    
    @patch('increment_visits.table')
    def test_increment_atomic_operation(self, mock_table):
        """Test: Verificar que la operación es atómica"""
        mock_table.update_item.return_value = {
            'Attributes': {'visit_count': 1}
        }
        
        event = {'pathParameters': {'page_id': 'atomic-test'}}
        lambda_handler(event, None)
        
        # Verificar que se usa UpdateExpression con if_not_exists
        call_args = mock_table.update_item.call_args
        update_expr = call_args[1]['UpdateExpression']
        self.assertIn('if_not_exists', update_expr)
        self.assertIn(':start', call_args[1]['ExpressionAttributeValues'])
        # Verificar que :start es 0 (nunca negativo)
        self.assertEqual(call_args[1]['ExpressionAttributeValues'][':start'], 0)
    
    @patch('increment_visits.table')
    def test_increment_default_page_id(self, mock_table):
        """Test: Sin page_id debe usar 'home' por defecto"""
        mock_table.update_item.return_value = {
            'Attributes': {'visit_count': 1}
        }
        
        event = {}
        response = lambda_handler(event, None)
        
        body = json.loads(response['body'])
        self.assertEqual(body['page_id'], 'home')
        
        # Verificar que se llamó con 'home'
        call_args = mock_table.update_item.call_args
        self.assertEqual(call_args[1]['Key'], {'page_id': 'home'})
    
    @patch('increment_visits.table')
    def test_increment_cors_headers(self, mock_table):
        """Test: Verificar headers CORS"""
        mock_table.update_item.return_value = {
            'Attributes': {'visit_count': 1}
        }
        
        event = {'pathParameters': {'page_id': 'test'}}
        response = lambda_handler(event, None)
        
        headers = response['headers']
        self.assertEqual(headers['Access-Control-Allow-Origin'], '*')
        self.assertIn('Access-Control-Allow-Methods', headers)
        self.assertIn('POST', headers['Access-Control-Allow-Methods'])
    
    @patch('increment_visits.table')
    def test_increment_large_numbers(self, mock_table):
        """Test: Incrementar con números grandes"""
        mock_table.update_item.return_value = {
            'Attributes': {'visit_count': 999999}
        }
        
        event = {'pathParameters': {'page_id': 'popular-page'}}
        response = lambda_handler(event, None)
        
        body = json.loads(response['body'])
        self.assertEqual(body['visit_count'], 999999)
        # Siempre positivo
        self.assertGreater(body['visit_count'], 0)


if __name__ == '__main__':
    unittest.main()
