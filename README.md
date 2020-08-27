# Confluent Cloud Proxy

Sample implementation of dockerized HAProxy to expose peered Confluent Cloud clusters to other networks.

Sample usage:

```bash
docker run -d --net=host -e BOOTSTRAP_HOSTNAME=pkc-l9mv5.eastus2.azure.confluent.cloud justinrlee/cc-proxy:1598567937
```