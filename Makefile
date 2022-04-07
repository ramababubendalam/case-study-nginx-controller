release ?= develop
image = docker.adstreamdev.com/nginx/app-router
devimage = docker.adstreamdev.com/nginx/app-router-dev:$(release)
uatimage = docker.adstreamdev.com/nginx/app-router-uat:$(release)

build_number ?= develop
ifdef BUILD_NUMBER
build_number = $(BUILD_NUMBER)
endif

git_branch ?= local
ifdef GIT_BRANCH
git_branch = $(subst origin/,,$(GIT_BRANCH))
endif

ci_image = $(image):$(git_branch)-$(build_number)

default: build

push:
	docker push $(ci_image)
	
build:
	docker build -t $(ci_image) .

################################################ customisation
pushdev:
	docker push $(devimage)

pushuat:
	docker push $(uatimage)
	
builddev:
	docker build -t $(devimage) -f Dockerfile.dev .

builduat:
	docker build -t $(uatimage) -f Dockerfile.uat .

cli:
	docker run -ti -e BABYLON_CLUSTER=foo,bar -e MAINTENANCE_MODE=True $(image):$(release) bash

run:
	docker run -e MAINTENANCE_MODE=True -p 80:80 -p 443:443 -ti $(image):$(release)
