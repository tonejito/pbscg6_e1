# = ^ . ^ =

# Programs
GIT=git
ECHO=echo
NATURALDOCS=naturaldocs

# user
USER?=nobody

# ports
GIT_PORT=9418
SSH_PORT=2290

# bug
BUG_HOST=bug.seguridad.unam.mx
BUG_PULL=/ext/pbscg6/pbscg6_e1
BUG_PUSH=/home/repository/ext/pbscg6/pbscg6_e1/
BUG_PULL_URI=git://${BUG_HOST}:${GIT_PORT}${BUG_PULL}
BUG_PUSH_URI=ssh://${USER}@${BUG_HOST}:${SSH_PORT}${BUG_PUSH}

# github
GITHUB_HOST=github.com
GITHUB_REPO=/pbscg6_e1.git
GITHUB_OWNER=tonejito
GITHUB_PULL_URI=git://${GITHUB_HOST}/${GITHUB_OWNER}${GITHUB_REPO}
GITHUB_PUSH_URI=git@${GITHUB_HOST}:${GITHUB_OWNER}${GITHUB_REPO}

# documentation
DOC_SRC=./
DOC_FORMAT=html
DOC_DIR=../docs
DOC_PROJECT=../project.nd

# targets
.PHONY:	config	docs	pull	push	bclone	bpull	bpush	gclone	gpull	gpush
config:	
	${ECHO} ${GIT} config --global user.name  "${USER}"
	${ECHO} ${GIT} config --global user.email "${USER}@server.tld"

docs:	
	${NATURALDOCS} -i ${DOC_SRC} -o ${DOC_FORMAT} ${DOC_DIR} -p ${DOC_PROJECT}

# git meta targets
pull:	bpull	gpull

push:	bpush	gpush

# bug targets
bclone:	
	${GIT} clone ${BUG_PULL_URI}

bpull:	
	${GIT} pull  ${BUG_PULL_URI}

bpush:	
	${GIT} push  ${BUG_PUSH_URI}

# github targets
gclone:	
	${GIT} glone ${GITHUB_PULL_URI}

gpull:	
	${GIT} pull  ${GITHUB_PULL_URI}

gpush:	
	${GIT} push  ${GITHUB_PUSH_URI}

