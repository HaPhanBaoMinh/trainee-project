#!/bin/bash

# Lấy danh sách node có taint "node.cloudprovider.kubernetes.io/uninitialized"
nodes=$(kubectl get nodes -o json | jq -r '
  .items[]
  | select(.spec.taints != null)
  | select(.spec.taints[]?.key == "node.cloudprovider.kubernetes.io/uninitialized")
  | .metadata.name
')

if [ -z "$nodes" ]; then
  echo "✅ Không có node nào có taint 'node.cloudprovider.kubernetes.io/uninitialized'."
  exit 0
fi

echo "🧹 Đang xóa taint khỏi các node sau:"
echo "$nodes"

for node in $nodes; do
  echo "🔧 Xóa taint khỏi node: $node"
  kubectl taint nodes "$node" node.cloudprovider.kubernetes.io/uninitialized:NoSchedule-
done

echo "✅ Đã hoàn tất!"

