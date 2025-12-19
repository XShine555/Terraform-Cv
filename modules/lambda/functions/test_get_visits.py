import unittest
from unittest.mock import patch, MagicMock
import json
import os
from get_visits import lambda_handler


class TestGetVisits(unittest.TestCase):
    """Tests para la función get_visits Lambda"""
    
    def setUp(self):
        """Configuración inicial para cada test"""
        os.environ['DYNAMODB_TABLE'] = 'test-table'
    
    @patch('get_visits.table')
    def test_get_visits_existing_page(self, mock_table):
        """Test: Obtener visitas de una página existente"""
        # Configurar mock
        mock_table.get_item.return_value = {
            'Item': {
                'page_id': 'home',
                'visit_count': 42
            }
        }
        
        # Evento de prueba
        event = {
            'pathParameters': {'page_id': 'home'}
        }
        
        # Ejecutar lambda
        response = lambda_handler(event, None)
        
        # Verificaciones
        self.assertEqual(response['statusCode'], 200)
        body = json.loads(response['body'])
        self.assertEqual(body['page_id'], 'home')
        self.assertEqual(body['visit_count'], 42)
        mock_table.get_item.assert_called_once_with(Key={'page_id': 'home'})
    
    @patch('get_visits.table')
    def test_get_visits_new_page(self, mock_table):
        """Test: Obtener visitas de una página que no existe (debe retornar 0)"""
        # Configurar mock - página no existe
        mock_table.get_item.return_value = {}
        
        event = {
            'pathParameters': {'page_id': 'new-page'}
        }
        
        response = lambda_handler(event, None)
        
        # Verificaciones
        self.assertEqual(response['statusCode'], 200)
        body = json.loads(response['body'])
        self.assertEqual(body['page_id'], 'new-page')
        self.assertEqual(body['visit_count'], 0)
    
    @patch('get_visits.table')
    def test_get_visits_zero_count(self, mock_table):
        """Test: Página con contador en 0"""
        mock_table.get_item.return_value = {
            'Item': {
                'page_id': 'zero-page',
                'visit_count': 0
            }
        }
        
        event = {
            'pathParameters': {'page_id': 'zero-page'}
        }
        
        response = lambda_handler(event, None)
        
        # Verificaciones
        self.assertEqual(response['statusCode'], 200)
        body = json.loads(response['body'])
        self.assertEqual(body['visit_count'], 0)
        # El contador nunca debe ser negativo
        self.assertGreaterEqual(body['visit_count'], 0)
    
    @patch('get_visits.table')
    def test_get_visits_negative_value_protection(self, mock_table):
        """Test: Verificar que valores negativos se manejan correctamente"""
        # Simular un valor negativo en la base de datos (aunque no debería ocurrir)
        mock_table.get_item.return_value = {
            'Item': {
                'page_id': 'negative-page',
                'visit_count': -5
            }
        }
        
        event = {
            'pathParameters': {'page_id': 'negative-page'}
        }
        
        response = lambda_handler(event, None)
        
        # Verificaciones
        self.assertEqual(response['statusCode'], 200)
        body = json.loads(response['body'])
        # Aunque la DB tenga -5, nunca debería retornar negativo
        # El código actual no valida esto, pero el test documenta el comportamiento esperado
        visit_count = body['visit_count']
        # Asegurar que el contador no sea negativo
        self.assertGreaterEqual(visit_count, 0, "El contador no puede ser negativo")
    
    @patch('get_visits.table')
    def test_get_visits_default_page_id(self, mock_table):
        """Test: Sin page_id debe usar 'home' por defecto"""
        mock_table.get_item.return_value = {
            'Item': {
                'page_id': 'home',
                'visit_count': 10
            }
        }
        
        event = {}
        
        response = lambda_handler(event, None)
        
        # Verificaciones
        self.assertEqual(response['statusCode'], 200)
        body = json.loads(response['body'])
        self.assertEqual(body['page_id'], 'home')
        mock_table.get_item.assert_called_once_with(Key={'page_id': 'home'})
    
    @patch('get_visits.table')
    def test_get_visits_cors_headers(self, mock_table):
        """Test: Verificar que los headers CORS están presentes"""
        mock_table.get_item.return_value = {
            'Item': {'page_id': 'test', 'visit_count': 1}
        }
        
        event = {'pathParameters': {'page_id': 'test'}}
        response = lambda_handler(event, None)
        
        # Verificar headers CORS
        headers = response['headers']
        self.assertEqual(headers['Access-Control-Allow-Origin'], '*')
        self.assertIn('Content-Type', headers)
        self.assertIn('Access-Control-Allow-Methods', headers)


if __name__ == '__main__':
    unittest.main()
