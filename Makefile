
GIT=git
NATURALDOCS=naturaldocs

USER?=nobody
HOST=bug.seguridad.unam.mx
PULL_PATH=/ext/pbscg6/pbscg6_e1
GIT_PORT=9418
PUSH_PATH=/home/repository/ext/pbscg6/pbscg6_e1/
SSH_PORT=2290

.PHONY:	clone	pull	push
#config:	
#	${GIT} config --global user.name  "Tonejito"
#	${GIT} config --global user.email "Tonejito@comunidad.unam.mx"
#
clone:	
	${GIT} clone git://${HOST}:${GIT_PORT}${PULL_PATH}

pull:	
	${GIT} pull

push:	
	${GIT} push ssh://${USER}@${HOST}:${SSH_PORT}${PUSH_PATH}

docs:	
	${NATURALDOCS} -i ./ -o html ../docs -p ../Project

