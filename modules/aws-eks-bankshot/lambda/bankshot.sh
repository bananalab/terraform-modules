function handler () {
    EVENT_DATA=$1
    AWS_PAGER=""
    export KUBECONFIG=/tmp/config.yaml

    _kubeconfig_path=$(echo ${EVENT_DATA} | ./jq -r '.kubeconfig')
    aws/dist/aws s3 cp ${_kubeconfig_path} ${KUBECONFIG}

    ./kubectl --kubeconfig=${KUBECONFIG} create namespace argocd || true
    ./kubectl --kubeconfig=${KUBECONFIG} apply -n argocd -f argocd.yaml

    RESPONSE="{\"statusCode\": 200, \"body\": \"OK\"}"
    echo $RESPONSE
}
