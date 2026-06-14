#!/usr/bin/env bash
set -euo pipefail

chown -R elasticsearch:elasticsearch /var/log/elasticsearch
chown -R elasticsearch:elasticsearch /var/lib/elasticsearch

# Start Elasticsearch in background
su -s /bin/bash elasticsearch -c 'ES_PATH_CONF=/etc/elasticsearch /usr/share/elasticsearch/bin/elasticsearch -d -p /tmp/elasticsearch.pid'

# Wait for Elasticsearch
until curl -s http://127.0.0.1:9200 >/dev/null; do
  sleep 5
done
curl -X PUT "localhost:9200/_all/_settings" -H 'Content-Type: application/json' -d '{
  "index.blocks.read_only_allow_delete": null
}'
# Start Filebeat in background
/usr/share/filebeat/bin/filebeat -e \
  --path.config /etc/filebeat \
  --path.home /usr/share/filebeat \
  --path.data /var/lib/filebeat \
  --strict.perms=false > /var/log/filebeat-console.log 2>&1 &

# Start Kibana in foreground
exec su -s /bin/bash kibana -c 'KBN_PATH_CONF=/etc/kibana /usr/share/kibana/bin/kibana'