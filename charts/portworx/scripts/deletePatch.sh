#! /bin/bash
# Usage deletePatch.sh <cluster-name> <deletestrategy> <namespace>
printf '{"spec": {"deleteStrategy": { "type": "' > /tmp/delete.json
printf $2 >> /tmp/delete.json  
printf '"}}}' >> /tmp/delete.json
kubectl patch stc -n $3 $1  --patch-file=/tmp/delete.json --type=merge
