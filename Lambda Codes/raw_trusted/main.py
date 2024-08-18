import os
import json
# import boto3
import awswrangler as wr

def lambda_handler(event, context):  # sourcery skip: extract-method

    print(f"Evento {event}")

    bucket_raw = os.environ['BUCKET_RAW']
    bucket_trusted = os.environ['BUCKET_TRUSTED']

    message = json.loads(json.loads(event['Records'][0]['body'])['Message'])

    if 'Records' in message.keys():
        object_key = message['Records'][0]['s3']['object']['key']
        path_raw = f"s3://{bucket_raw}/{object_key}"

        print(f'{path_raw = }')

        # Lê o arquivo CSV do S3 raw
        df = wr.s3.read_csv(path=path_raw)

        # Conversão dos dados conforme necessário
        # df['velocity'] = df['velocity'].astype(float)
        # df['battery'] = df['battery'].astype(float)

        # Define o caminho para gravar o CSV no S3 trusted
        path_trusted = f's3://{bucket_trusted}/{object_key}'

        print(f'write s3: {path_trusted = }')

        # Grava o DataFrame como CSV no S3 trusted
        wr.s3.to_csv(
            df=df,
            path=path_trusted,
            index=False
        )

        # sns = boto3.client('sns')

        # sns.publish(
        #     Message='Processamento concluído',
        #     TopicArn=os.environ['TRUSTED_CLIENT_TOPIC_ARN'],
        # )