import json
import boto3
import os
from decimal import Decimal

dynamodb = boto3.resource('dynamodb')
table_name = os.environ['DYNAMODB_TABLE']
table = dynamodb.Table(table_name)

def lambda_handler(event, context):
    """
    Incrementar el contador de visitas de una página
    """
    try:
        # Obtener page_id del path
        page_id = event.get('pathParameters', {}).get('page_id', 'home')
        
        # Incrementar contador usando UpdateItem con atomic counter
        response = table.update_item(
            Key={'page_id': page_id},
            UpdateExpression='SET visit_count = if_not_exists(visit_count, :start) + :inc',
            ExpressionAttributeValues={
                ':inc': 1,
                ':start': 0
            },
            ReturnValues='UPDATED_NEW'
        )
        
        visit_count = int(response['Attributes']['visit_count'])
        
        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Methods': 'POST,OPTIONS'
            },
            'body': json.dumps({
                'page_id': page_id,
                'visit_count': visit_count,
                'message': 'Visit recorded successfully'
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
