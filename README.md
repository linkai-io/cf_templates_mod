# AM CloudFormation Templates
This repository contains the templates necessary to stand up a full hakken AM system.

# TODO:
Make a master template to launch the entire stack
## Ordering
If custom resources cfn-secret, cfn-ecs-tasks, etc. have not been deployed, those must be done first:
- s3infra.yaml
- (run ./custom-resources/cfn-secret-provider/deploy-secret-provider.sh)
- (run ./custom-resources/cfn-certificate-provider/deploy-certificate-provider.sh)
- (run ./custom-resources/cfn-ses-provider/deploy-cfn-ses-provider.sh)
- cfn-resource-provider.yaml
- manually create bigquery api key in ssm /am/{env}/bigdata/ct/credentials

cfn-secret-provider:  
- ```aws cloudformation create-stack --stack-name cfn-secret-provider --template-body file://`pwd`/custom-resources/cfn-secret-provider/cfn-secret-provider.yaml --capabilities CAPABILITY_IAM```
ecs-tasks:
- ```aws cloudformation create-stack --stack-name cfn-ecs-tasks --template-body file://`pwd`/custom-resources/cfn-ecs-tasks/cfn-ecs-tasks.yaml```
cfn-certificate-provider:  
- ```aws cloudformation create-stack --stack-name cfn-certificate-provider --template-body file://`pwd`/custom-resources/cfn-certificate-provider/cfn-certificate-provider.yaml --capabilities CAPABILITY_IAM```
cfn-ses-provider:  
- ```aws cloudformation create-stack --stack-name cfn-ses-provider --template-body file://`pwd`/custom-resources/cfn-ses-provider/cfn-ses-provider.yaml --capabilities CAPABILITY_IAM```

## With Master Template
### Prod
First deploy the VPC for your target environment:
- am-vpc.yaml: ```aws cloudformation create-stack --stack-name hakken-prod-vpc --template-body file://`pwd`/am-vpc.yaml --parameters ParameterKey=EnvironmentName,ParameterValue=prod```

Next deploy the supporting services stacks:
- am-supporting-services.yaml: ```aws cloudformation create-stack --stack-name hakken-prod-supporting-services --template-body file://`pwd`/am-supporting-services.yaml --parameters ParameterKey=EnvironmentName,ParameterValue=prod --capabilities CAPABILITY_IAM```
Then the module services stacks:
- am-module-services.yaml: ```aws cloudformation create-stack --stack-name hakken-prod-module-services --template-body file://`pwd`/am-module-services.yaml --parameters ParameterKey=EnvironmentName,ParameterValue=prod --capabilities CAPABILITY_IAM```
Finally the backend services stacks:
- am-backend-services.yaml: ```aws cloudformation create-stack --stack-name hakken-prod-backend-services --template-body file://`pwd`/am-backend-services.yaml --parameters ParameterKey=EnvironmentName,ParameterValue=prod --capabilities CAPABILITY_IAM```
- am-external-services.yaml: ```aws cloudformation create-stack --stack-name hakken-prod-external-services --template-body file://`pwd`/am-external-services.yaml --parameters ParameterKey=EnvironmentName,ParameterValue=prod --capabilities CAPABILITY_NAMED_IAM```

Frontend APIs:
- am-frontend.yaml: ```aws cloudformation create-stack --stack-name hakken-prod-frontend --template-body file://`pwd`/am-frontend.yaml --parameters ParameterKey=EnvironmentName,ParameterValue=prod --capabilities CAPABILITY_IAM```

- templates/am-api-roles.yaml: ```aws cloudformation create-stack --stack-name hakken-prod-api-roles --template-body file://`pwd`/templates/am-api-roles.yaml --parameters ParameterKey=EnvironmentName,ParameterValue=prod --capabilities CAPABILITY_IAM```

- templates/am-support-org-task.yaml: ```aws cloudformation create-stack --stack-name hakken-prod-support-org-provision --template-body file://`pwd`/templates/am-support-org-task.yaml --parameters ParameterKey=EnvironmentName,ParameterValue=prod --capabilities CAPABILITY_IAM```

#### Update
- am-backend-services.yaml: ```aws cloudformation update-stack --stack-name hakken-prod-backend-services --template-body file://`pwd`/am-backend-services.yaml --parameters ParameterKey=EnvironmentName,ParameterValue=prod --capabilities CAPABILITY_IAM```
- am-frontend.yaml: ```aws cloudformation update-stack --stack-name hakken-prod-frontend --template-body file://`pwd`/am-frontend.yaml --parameters ParameterKey=EnvironmentName,ParameterValue=prod --capabilities CAPABILITY_IAM```
- am-module-services.yaml: ```aws cloudformation update-stack --stack-name hakken-prod-module-services --template-body file://`pwd`/am-module-services.yaml --parameters ParameterKey=EnvironmentName,ParameterValue=prod --capabilities CAPABILITY_IAM```




### Dev
First deploy the VPC for your target environment:
- am-vpc.yaml: ```aws cloudformation create-stack --stack-name hakken-vpc --template-body file://`pwd`/am-vpc.yaml --parameters ParameterKey=EnvironmentName,ParameterValue=dev```

Next deploy the supporting services stacks:
- am-supporting-services.yaml: ```aws cloudformation create-stack --stack-name hakken-dev-supporting-services --template-body file://`pwd`/am-supporting-services.yaml --parameters ParameterKey=EnvironmentName,ParameterValue=dev --capabilities CAPABILITY_IAM```

Then the module services stacks:
- am-module-services.yaml: ```aws cloudformation create-stack --stack-name hakken-dev-module-services --template-body file://`pwd`/am-module-services.yaml --parameters ParameterKey=EnvironmentName,ParameterValue=dev --capabilities CAPABILITY_IAM```

The backend services stacks:
- am-backend-services.yaml: ```aws cloudformation create-stack --stack-name hakken-dev-backend-services --template-body file://`pwd`/am-backend-services.yaml --parameters ParameterKey=EnvironmentName,ParameterValue=dev --capabilities CAPABILITY_IAM```

The external services (port scanning):
- am-external-services.yaml: ```aws cloudformation create-stack --stack-name hakken-dev-external-services --template-body file://`pwd`/am-external-services.yaml --parameters ParameterKey=EnvironmentName,ParameterValue=dev --capabilities CAPABILITY_NAMED_IAM```


Frontend APIs:
- am-frontend.yaml: ```aws cloudformation create-stack --stack-name hakken-dev-frontend --template-body file://`pwd`/am-frontend.yaml --parameters ParameterKey=EnvironmentName,ParameterValue=dev --capabilities CAPABILITY_IAM```

- templates/am-api-roles.yaml: ```aws cloudformation create-stack --stack-name hakken-dev-api-roles --template-body file://`pwd`/templates/am-api-roles.yaml --parameters ParameterKey=EnvironmentName,ParameterValue=dev --capabilities CAPABILITY_IAM```

- templates/am-support-org-task.yaml: ```aws cloudformation create-stack --stack-name hakken-dev-support-org-provision --template-body file://`pwd`/templates/am-support-org-task.yaml --parameters ParameterKey=EnvironmentName,ParameterValue=dev --capabilities CAPABILITY_IAM```

## Update stack commands
This is just so we don't have to retype everything:
- am-vpc.yaml: ```aws cloudformation update-stack --stack-name hakken-vpc --template-body file://`pwd`/am-vpc.yaml --parameters ParameterKey=EnvironmentName,ParameterValue=dev```

- am-supporting-services.yaml: ```aws cloudformation update-stack --stack-name hakken-dev-supporting-services --template-body file://`pwd`/am-supporting-services.yaml --parameters ParameterKey=EnvironmentName,ParameterValue=dev --capabilities CAPABILITY_IAM```

Then the module services stacks:
- am-module-services.yaml: ```aws cloudformation update-stack --stack-name hakken-dev-module-services --template-body file://`pwd`/am-module-services.yaml --parameters ParameterKey=EnvironmentName,ParameterValue=dev --capabilities CAPABILITY_IAM```
Finally the backend services stacks:
- am-backend-services.yaml: ```aws cloudformation update-stack --stack-name hakken-dev-backend-services --template-body file://`pwd`/am-backend-services.yaml --parameters ParameterKey=EnvironmentName,ParameterValue=dev --capabilities CAPABILITY_IAM```

Frontend APIs:
- am-frontend.yaml: ```aws cloudformation update-stack --stack-name hakken-dev-frontend --template-body file://`pwd`/am-frontend.yaml --parameters ParameterKey=EnvironmentName,ParameterValue=dev --capabilities CAPABILITY_IAM```



- templates/am-support-org-task.yaml: ```aws cloudformation update-stack --stack-name hakken-dev-support-org-provision --template-body file://`pwd`/templates/am-support-org-task.yaml --parameters ParameterKey=EnvironmentName,ParameterValue=dev --capabilities CAPABILITY_IAM```

## DEPRECATED
- am-remote-sg.yaml: ```aws cloudformation create-stack --stack-name hakken-remoteworkerssg --template-body file://`pwd`/am-remote-sg.yaml --parameters ParameterKey=EnvironmentName,ParameterValue=dev```
- am-unbound-build.yaml: ```aws cloudformation create-stack --stack-name hakken-unbound --template-body file://`pwd`/am-unbound-build.yaml --parameters ParameterKey=EnvironmentName,ParameterValue=dev```

- am-consul.yaml: ```aws cloudformation create-stack --stack-name hakken-consul-server --template-body file://`pwd`/am-consul-server.yaml --parameters ParameterKey=EnvironmentName,ParameterValue=dev --capabilities CAPABILITY_IAM```
- am-loadbalancer.yaml: ```aws cloudformation create-stack --stack-name hakken-loadbalancer --template-body file://`pwd`/am-loadbalancer.yaml --parameters ParameterKey=EnvironmentName,ParameterValue=dev --capabilities CAPABILITY_IAM```

- am-elasticcache.yaml: ```aws cloudformation create-stack --stack-name hakken-cache --template-body file://`pwd`/am-elasticcache.yaml --parameters ParameterKey=EnvironmentName,ParameterValue=dev```
- am-db.yaml: ```aws cloudformation create-stack --stack-name hakken-db --template-body file://`pwd`/am-db.yaml --parameters ParameterKey=EnvironmentName,ParameterValue=dev```
- am-modules-ecs.yaml: ```aws cloudformation create-stack --stack-name hakken-modules-ecs --template-body file://`pwd`/am-modules-ecs.yaml --parameters ParameterKey=EnvironmentName,ParameterValue=dev --capabilities CAPABILITY_IAM```
(run ECS module services)
- am-module-services.yaml: ```aws cloudformation create-stack --stack-name hakken-module-services --template-body file://`pwd`/am-module-services.yaml --parameters ParameterKey=EnvironmentName,ParameterValue=dev --capabilities CAPABILITY_IAM```
- am-ecs-backend.yaml: ```aws cloudformation create-stack --stack-name hakken-backend-ecs --template-body file://`pwd`/am-backend-ecs.yaml --parameters ParameterKey=EnvironmentName,ParameterValue=dev --capabilities CAPABILITY_IAM```
- am-db-migrations: ```aws cloudformation create-stack --stack-name hakken-db-migrations --template-body file://`pwd`/am-db-migrations.yaml --parameters ParameterKey=EnvironmentName,ParameterValue=dev --capabilities CAPABILITY_IAM```
(run ECS tasks to migrate db to latest schema)
- ```aws ecs run-task --cluster dev-backend-ecs-cluster --task-definition pg-migrations```
- ```aws ecs run-task --cluster dev-backend-ecs-cluster --task-definition am-migrations```
(start backend services)
- am-backend-services: ```aws cloudformation create-stack --stack-name hakken-backend-services --template-body file://`pwd`/am-backend-services.yaml --parameters ParameterKey=EnvironmentName,ParameterValue=dev --capabilities CAPABILITY_IAM```
- am-module-web-instances.yaml: ```aws cloudformation create-stack --stack-name hakken-module-web-instances --template-body file://`pwd`/am-module-web-instances.yaml --parameters ParameterKey=EnvironmentName,ParameterValue=dev --capabilities CAPABILITY_IAM```

## Deleting Stacks:
```aws cloudformation delete-stack --stack-name hakken-$$$```



## Getting parameter keys:
```aws ssm get-parameter --name /am/dev/consul/key --with-decryption | jq .Parameter.Value | sed -e 's/\\n/\n/g' -e 's/"//g' > ~/.ssh/dev.consul```