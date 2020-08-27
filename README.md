# Confluent Cloud Proxy

Sample implementation of dockerized HAProxy to expose peered Confluent Cloud clusters to other networks.

Sample usage:

```bash
docker run -d --net=host -e BOOTSTRAP_HOSTNAME=pkc-l9mv5.eastus2.azure.confluent.cloud justinrlee/cc-proxy:1598567937
```

Also, you'll need to point a number of DNS names at the HAProxy instance (or a TCP load balancer in front of HAProxy):

pkc-l9mv5.eastus2.azure.confluent.cloud
b0-pkc-l9mv5.eastus2.azure.confluent.cloud
b1-pkc-l9mv5.eastus2.azure.confluent.cloud
etc. 

Image currently works for 1 and 2-CKU clusters (I think).