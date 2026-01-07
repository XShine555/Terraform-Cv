import json
import boto3
import os
from decimal import Decimal

# Inicialización lazy de DynamoDB
_dynamodb = None
_table = None

def get_table():
    global _dynamodb, _table
    if _table is None:
        region = os.environ.get('AWS_DEFAULT_REGION', 'us-east-1')
        _dynamodb = boto3.resource('dynamodb', region_name=region)
        table_name = os.environ.get('DYNAMODB_TABLE', 'visits-table')
        _table = _dynamodb.Table(table_name)
    return _table

def lambda_handler(event, context):
    """
    Obtener el contador de visitas de una página
    """
    try:
        # Obtener page_id del path
        page_id = event.get('pathParameters', {}).get('page_id', 'home')
        
        # Consultar DynamoDB
        table = get_table()
        response = table.get_item(Key={'page_id': page_id})
        
        # Si la página no existe, retornar 0
        if 'Item' not in response:
            visit_count = 0
        else:
            visit_count = int(response['Item'].get('visit_count', 0))
            # Asegurar que el contador nunca sea negativo
            visit_count = max(0, visit_count)
        
        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Methods': 'GET,OPTIONS'
            },
            'body': json.dumps({
                'page_id': page_id,
                'visit_count': visit_count
            })
        }
    
    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({
                'error': 'Internal server error',
                'message': str(e)
            })
        }
