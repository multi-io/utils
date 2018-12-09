#!/bin/sh

# remove unused volumes
docker volume ls -qf dangling=true | xargs docker volume rm

# remove stopped containers
docker rm $(docker ps -a -q)

# remove untagged images
docker rmi $(docker images | grep "^<none>" | awk "{print $3}")

#remove "dangling" images (i.e. -- images that aren't parents of tagged images?):
docker images -a --filter=dangling=true -q | xargs docker rmi
