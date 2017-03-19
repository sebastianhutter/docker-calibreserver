# simple makefile to build and push docker container images
IMAGE_NAME = sebastianhutter/calibreserver

# if the go label is set overwrite the commit id env variable
ifneq ($(GO_PIPELINE_LABEL),"")
export COMMIT_ID := $(GO_PIPELINE_LABEL)
endif

# build
# build a new docker image
build_commit:
	docker build -t $(IMAGE_NAME):$(COMMIT_ID) .

# latest
# set the latest tag for the image with the specified nextcloud version tag
build_latest:
	docker build -t $(IMAGE_NAME):latest .

# push the commit tag
push_commit:
	docker push $(IMAGE_NAME):$(COMMIT_ID)

# push the build containers
push_latest:
	docker push $(IMAGE_NAME):latest
