NAME=harbor
NAMESPACE=default
PORT=80
MANIFEST=./manifest
URL=gmt.reg.me

all: deploy

cp:
	@find ${MANIFEST} -type f -name "*.sed" | sed s?".sed"?""?g | xargs -I {} cp {}.sed {}

sed:
	@find ${MANIFEST} -type f -name "*.yaml" | xargs sed -i s?"{{.name}}"?"${NAME}"?g
	@find ${MANIFEST} -type f -name "*.yaml" | xargs sed -i s?"{{.namespace}}"?"${NAMESPACE}"?g
	@find ${MANIFEST} -type f -name "*.yaml" | xargs sed -i s?"{{.port}}"?"${PORT}"?g
	@find ${MANIFEST} -type f -name "*.yaml" | xargs sed -i s?"{{.url}}"?"${URL}"?g

deploy: export OP=create
deploy: cp sed
	@kubectl ${OP} -f ${MANIFEST}/endpoint.yaml
	@kubectl ${OP} -f ${MANIFEST}/service.yaml
	@kubectl ${OP} -f ${MANIFEST}/ingress.yaml

del: export OP=delete
del:
	@kubectl ${OP} -f ${MANIFEST}/endpoint.yaml
	@kubectl ${OP} -f ${MANIFEST}/service.yaml
	@kubectl ${OP} -f ${MANIFEST}/ingress.yaml
	@rm -f ${MANIFEST}/endpoint.yaml
	@rm -f ${MANIFEST}/service.yaml
	@rm -f ${MANIFEST}/ingress.yaml

clean: del

.PHONY : test
test:
	@curl http://${URL}
