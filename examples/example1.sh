# Add the stock Python env to your Fission deployment
fission env create --name python --image fission/python-env &&

# A Python function that prints "hello world"
curl -LO https://raw.githubusercontent.com/fission/examples/main/python/hello.py &&

# Upload your function code to fission
fission function create --name hello-py --env python --code hello.py &&

# Test your function.  This takes about 100msec the first time.
fission function test --name hello-py

# export FISSION_ROUTER=$(minikube ip):$(kubectl -n fission get svc router -o jsonpath='{...nodePort}')

# fission route create --method GET --url /hello --function hello 
# curl $FISSION_ROUTER/hello