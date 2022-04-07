release ?= develop
image = docker/nginx/app-router

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

