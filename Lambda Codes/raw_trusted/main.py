import os
import json
import awswrangler as wr

def lambda_handler(event, context):

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

        df_tratado = apply_all_rules(df)

        # Define o caminho para gravar o CSV no S3 trusted
        path_trusted = f's3://{bucket_trusted}/{object_key}'

        print(f'write s3: {path_trusted = }')

        # Grava o DataFrame como CSV no S3 trusted
        wr.s3.to_csv(
            df=df_tratado,
            path=path_trusted,
            index=False
        )

# Removendo IDs
def remove_ids(df):
    # Identificar colunas com apenas valores únicos (como IDs)
    colunas_unicas = [coluna for coluna in df.columns if df[coluna].nunique() == len(df)]

    # Remover as colunas com valores únicos
    dados_processados = df.drop(columns=colunas_unicas)
    return dados_processados

# Removendo colunas muito variadas (Descrições, Nomes)
def remove_variable_columns(df):
    # Definir o limiar para o número de valores únicos em relação ao tamanho do conjunto de dados
    limiar_valores_unicos = 0.7  # Por exemplo, 50% dos valores únicos

    # Identificar colunas descritivas com muitos valores únicos
    colunas_descritivas = [coluna for coluna in df.columns if df[coluna].nunique() / len(df) > limiar_valores_unicos]

    # Remover as colunas descritivas
    dados_processados = df.drop(columns=colunas_descritivas)
    return dados_processados

def remove_unused_columns(df):
    columns_to_remove = ['Name', 'RescuerID']
    return df.drop(columns=columns_to_remove)

# Aplicando todas as regras
def apply_all_rules(df):
    df = remove_ids(df)
    df = remove_variable_columns(df)
    df = remove_unused_columns(df)
    return df