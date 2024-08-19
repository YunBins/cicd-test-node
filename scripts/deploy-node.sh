#!/bin/bash

cd /home/ec2-user/app

DOCKER_APP_NAME=node

# 실행중인 blue가 있는지
EXIST_BLUE=$(sudo docker-compose -p ${DOCKER_APP_NAME}-blue -f docker-compose-node.blue.yml ps | grep Up)

# green이 실행중이면 blue up
if [ -z "$EXIST_BLUE" ]; then
        echo "blue up"
        sudo docker-compose -p ${DOCKER_APP_NAME}-blue -f docker-compose-node.blue.yml up -d

        sleep 30

        sudo docker-compose -p ${DOCKER_APP_NAME}-green -f docker-compose-node.green.yml down
        sudo docker image prune -af # 사용하지 않는 이미지 삭제

# blue가 실행중이면 green up
else
        echo "green up"
        sudo docker-compose -p ${DOCKER_APP_NAME}-green -f docker-compose-node.green.yml up -d

        sleep 30

        sudo docker-compose -p ${DOCKER_APP_NAME}-blue -f docker-compose-node.blue.yml down
        sudo docker image prune -af
fi