import os
import json
import boto3

def lambda_handler(event, context):
    print(f"Evento {event}")

    bucket_raw = os.environ['BUCKET_RAW']
    bucket_trusted = os.environ['BUCKET_TRUSTED']

    s3_client = boto3.client('s3')

    message = json.loads(json.loads(event['Records'][0]['body'])['Message'])

    if 'Records' in message.keys():
        # Obtém a chave do objeto do evento
        object_key = message['Records'][0]['s3']['object']['key']
        
        # Define as fontes de cópia e o destino
        copy_source = {'Bucket': bucket_raw, 'Key': object_key}
        target_key = f'sensors/{object_key}'
        
        # Copia o arquivo do bucket RAW para o bucket TRUSTED
        s3_client.copy_object(CopySource=copy_source, Bucket=bucket_trusted, Key=target_key)
        print(f'Arquivo copiado para s3://{bucket_trusted}/{target_key}')
        
        # Exclui o arquivo do bucket RAW após a cópia
        s3_client.delete_object(Bucket=bucket_raw, Key=object_key)
        print(f'Arquivo deletado do bucket RAW: s3://{bucket_raw}/{object_key}')
