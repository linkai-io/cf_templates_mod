APP_ENV = dev
TEMPLATE_FILES=templates/
ALL_FILES=$(wildcard *)

upload:
	aws s3 sync ${TEMPLATE_FILES} s3://linkai-infra/templates/

consulserver:
	cd infra && zip consul/server.zip -r consul/ 
	aws s3 cp infra/consul/server.zip s3://linkai-infra/dev/consul/server.zip

prodconsulserver:
	cd infra && zip consul/server.zip -r consul/ 
	aws s3 cp infra/consul/server.zip s3://linkai-infra/prod/consul/server.zip