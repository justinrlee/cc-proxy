# Confluent Cloud Proxy

**Use for POCs _only_**

Sample implementation of dockerized HAProxy to expose peered Confluent Cloud clusters to other networks.

Example usage:

```bash
docker run -d --net=host \
    -e CKU_COUNT=2 \
    -e ADMIN_API_HOSTNAME=pkac-4rnxk.eastus2.azure.confluent.cloud \
    -e BOOTSTRAP_HOSTNAME=pkc-l9mv5.eastus2.azure.confluent.cloud \
    justinrlee/cc-proxy:1598576167
```

You can get both the ADMIN API and the HOSTNAME from the Confluent Cloud CLI (leave off the protocol and port for both in the environment variables)

```bash
ccloud kafka cluster describe lkc-mp73q
+--------------+---------------------------------------------------------+
| Id           | lkc-mp73q                                               |
| Name         | justin-azure-peered                                     |
| Type         | DEDICATED                                               |
| Ingress      |                                                     100 |
| Egress       |                                                     300 |
| Storage      |                                                   60000 |
| Provider     | azure                                                   |
| Availability | LOW                                                     |
| Region       | eastus2                                                 |
| Status       | UP                                                      |
| Endpoint     | SASL_SSL://pkc-l9mv5.eastus2.azure.confluent.cloud:9092 |
| ApiEndpoint  | https://pkac-4rnxk.eastus2.azure.confluent.cloud        |
| ClusterSize  |                                                       2 |
+--------------+---------------------------------------------------------+
```

Also, you'll need to point a number of DNS names at the HAProxy instance (or a TCP load balancer in front of HAProxy):

* pkc-l9mv5.eastus2.azure.confluent.cloud
* b0-pkc-l9mv5.eastus2.azure.confluent.cloud
* b1-pkc-l9mv5.eastus2.azure.confluent.cloud
* b2-pkc-l9mv5.eastus2.azure.confluent.cloud
* b3-pkc-l9mv5.eastus2.azure.confluent.cloud
* b4-pkc-l9mv5.eastus2.azure.confluent.cloud
* b5-pkc-l9mv5.eastus2.azure.confluent.cloud
* pkac-4rnxk.eastus2.azure.confluent.cloud
