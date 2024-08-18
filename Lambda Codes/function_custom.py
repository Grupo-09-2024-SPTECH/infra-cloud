import boto3
import urllib.request
import zipfile
import os

def handler(event, context):

    bucket_utils = os.environ['BUCKET_TRUSTED']

    s3 = boto3.client('s3')
    url = "https://raw.githubusercontent.com/Grupo-09-2024-SPTECH/infra-cloud/df720ad6e54e911d26a9c58bcd151a1e2509a2c1/Lambda%20Codes/lambda_package_raw_trusted.py"  # Coloque a URL do arquivo no GitHub
    file_path = "/tmp/lambda_package_raw_trusted.py"
    zip_path = "/tmp/lambda_package_raw_trusted.zip"
    
    # Download do arquivo do GitHub
    urllib.request.urlretrieve(url, file_path)
    
    # Compactação do arquivo em um arquivo ZIP
    with zipfile.ZipFile(zip_path, 'w') as zipf:
        zipf.write(file_path, os.path.basename(file_path))
    
    # Upload do arquivo ZIP para o S3
    s3.upload_file(zip_path, bucket_utils, 'lambda_zip/lambda_package_raw_trusted.zip')
    
    return {
        'statusCode': 200,
        'body': 'Upload and zip successful'
    }
