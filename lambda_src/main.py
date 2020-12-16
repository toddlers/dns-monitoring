import socket
import boto3
import os

# variables from lambda env
DNS_ENDPOINTS = os.getenv('DNS_ENDPOINTS')

# boto3 config
cloudwatch = boto3.client('cloudwatch')

def dns_lookup(host):
    try:
        socket.getaddrinfo(host, 80)
    except socket.gaierror:
        return False
    return True

def send_metric(value,dns_name):
    response = cloudwatch.put_metric_data(
        MetricData = [
            {
                'MetricName': 'ResolutionCount',
                'Dimensions': [
                    {
                        'Name': 'endpoint',
                        'Value': dns_name
                    },
                ],
                'Unit': 'Count',
                'Value': value
            },
        ],
        Namespace = 'DNSMonitoring'
    )
    print(f'Added metric count : {response}')



def handler(event, context):
    def check_and_send_metric(dns_name):
        if dns_lookup(dns_name):
            print(f'DNS Status for {dns_name}: Working')
            send_metric(1,dns_name)
        else:
            print(f'DNS Status for {dns_name}: Failed')
            send_metric(0,dns_name)
    dns_endpoints = DNS_ENDPOINTS.split(',')
    for dns_endpoint in dns_endpoints:
        check_and_send_metric(dns_endpoint)
