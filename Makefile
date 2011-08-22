
GIT=git
ECHO=echo
NATURALDOCS=naturaldocs

USER?=nobody
HOST=bug.seguridad.unam.mx
PULL_PATH=/ext/pbscg6/pbscg6_e1
GIT_PORT=9418
PUSH_PATH=/home/repository/ext/pbscg6/pbscg6_e1/
SSH_PORT=2290

DOC_SRC=./
DOC_FORMAT=html
DOC_DIR=../docs
DOC_PROJECT=../project.nd

.PHONY:	config	clone	pull	push	docs
config:	
	${ECHO} ${GIT} config --global user.name  "${USER}"
	${ECHO} ${GIT} config --global user.email "${USER}@server.tld"

clone:	
	${GIT} clone git://${HOST}:${GIT_PORT}${PULL_PATH}

pull:	
	${GIT} pull

push:	
	${GIT} push ssh://${USER}@${HOST}:${SSH_PORT}${PUSH_PATH}

docs:	
	${NATURALDOCS} -i ${DOC_SRC} -o ${DOC_FORMAT} ${DOC_DIR} -p ${DOC_PROJECT}

