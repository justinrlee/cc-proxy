# Confluent Cloud Proxy

**Use for POCs _only_**

Sample implementation of dockerized HAProxy to expose peered Confluent Cloud clusters to other networks.

Example usage:

```bash
docker run -d --net=host \
    -e BOOTSTRAP_HOSTNAME=pkc-l9mv5.eastus2.azure.confluent.cloud \
    justinrlee/cc-proxy:1598567937
```

Also, you'll need to point a number of DNS names at the HAProxy instance (or a TCP load balancer in front of HAProxy):

* pkc-l9mv5.eastus2.azure.confluent.cloud
* b0-pkc-l9mv5.eastus2.azure.confluent.cloud
* b1-pkc-l9mv5.eastus2.azure.confluent.cloud
* b2-pkc-l9mv5.eastus2.azure.confluent.cloud
* b3-pkc-l9mv5.eastus2.azure.confluent.cloud
* b4-pkc-l9mv5.eastus2.azure.confluent.cloud
* b5-pkc-l9mv5.eastus2.azure.confluent.cloud

Image currently works for clusters with exactly 6 backend brokers.  Currently listens on port 9092 and forwards to the correct broker.  Does not currently handle Admin API.