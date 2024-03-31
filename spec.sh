#!/bin/bash
source lib_utility

NAMESPACE=default
print_message "1. deleting existing fn, pkg and env"
# fission spec destroy &&
# fission spec destroy ./specs --force &&
sleep 5
fission fn delete --name consumer --ignorenotfound true &&
sleep 5
fission fn delete --name producer --ignorenotfound true &&
sleep 5
fission pkg delete --name consumer-pkg --ignorenotfound true -f &&
sleep 5
fission pkg delete --name producer-pkg --ignorenotfound true -f &&
sleep 5
fission environment delete --name python --force &&
sleep 5
fission mqt delete --name rabbitmq-test --ignorenotfound true &&
sleep 5
fission pkg delete --orphan &&
sleep 20
print_message "2. deleting existing achieves and specs directories"
rm *.zip
rm -rf specs

print_message "3. grant permission on files in the functions directories"
print_message "4. archieving the funtion files"
(cd producer/ && zip -r producer.zip *) &&
(cd producer/ && sudo chmod a+x  *) && 
mv producer/producer.zip .

(cd consumer/ && zip -r consumer.zip *) &&
(cd consumer/ && sudo chmod a+x *) &&
mv consumer/consumer.zip .

print_message "5. initializing the specs"
fission spec init && 
sleep 5
print_message "6. creating new environment 'python' "
fission env get --name python || fission environment create --name python --image fission/python-env:latest --builder fission/python-builder:latest --spec --namespace $NAMESPACE &&

print_message "7. create packages for the funtion"
sleep 15
fission package create --name consumer-pkg --sourcearchive consumer.zip --env python --buildcmd "./build.sh" --spec --namespace $NAMESPACE &&
sleep 5
fission fn create --name consumer --pkg consumer-pkg --entrypoint "consumer.main" --spec --namespace $NAMESPACE &&

sleep 15
print_message "8. create funtions"
fission package create --name producer-pkg --sourcearchive producer.zip --env python --buildcmd "./build.sh" --spec --namespace $NAMESPACE 
fission fn create --name producer --pkg producer-pkg --entrypoint "producer.main" --secret keda-rabbitmq-secret --spec --namespace $NAMESPACE && 

sleep 5
print_message "9. create triggers"
fission mqt create --spec --name rabbitmq-test --function consumer --mqtype rabbitmq --mqtkind keda \
    --topic request-topic --resptopic response-topic --errortopic error-topic --maxretries 3 \
    --metadata queueName=request-topic --metadata topic=request-topic --cooldownperiod=30 \
    --metadata host="amqp://admin:admin!@rabbitmq.rabbitmq-system.svc.cluster.local:5672/" \
    --pollinginterval=5 --secret keda-rabbitmq-secret --namespace $NAMESPACE &&

print_message "10. apply spec"
sleep 5
fission spec apply --namespace $NAMESPACE --wait --watch 
# fission fn list -A &&
# fission mqt list -A &&
# sleep 30

# print_message "11. checking if producer function successfully deployed"
# fission pkg info --name producer-pkg --namespace $NAMESPACE 

# print_message "checking if consumer function successfully deployed"
# fission pkg info --name consumer-pkg --namespace $NAMESPACE 
