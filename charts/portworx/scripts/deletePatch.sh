#! /bin/bash
printf '{"spec": {"deleteStrategy": { "type": "' > /tmp/delete.json
printf $2 >> /tmp/delete.json  
printf '"}}}' >> /tmp/delete.json
kubectl patch stc -n kube-system $1  --patch-file=/tmp/delete.json --type=merge
