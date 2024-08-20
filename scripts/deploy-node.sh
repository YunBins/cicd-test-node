#!/bin/bash

cd /home/ec2-user/app

DOCKER_APP_NAME=node

EXIST_BLUE=$(sudo docker-compose -p ${DOCKER_APP_NAME}-blue -f docker-compose-node.blue.yml ps | grep Up)

# 1
if [ -z "$EXIST_BLUE" ]; then
        echo "blue up"
        sudo docker-compose -p ${DOCKER_APP_NAME}-blue -f docker-compose-node.blue.yml up -d

        BEFORE_COLOR="green"
        AFTER_COLOR="blue"
        BEFORE_PORT=7072
        AFTER_PORT=7071

else
        echo "green up"
        sudo docker-compose -p ${DOCKER_APP_NAME}-green -f docker-compose-node.green.yml up -d

        BEFORE_COLOR="blue"
        AFTER_COLOR="green"
        BEFORE_PORT=7071
        AFTER_PORT=7072
fi

echo "${AFTER_COLOR} server up(port:${AFTER_PORT})"

# 2
for cnt in {1..10}
do
        echo "서버 응답 확인중(${cnt}/10)";
        UP=$(curl -s http://127.0.0.1:${AFTER_PORT}/health-check)
        if [ "${UP}" != "up" ]
                then
                        sleep 10
                        continue
                else
                        break
        fi
done

if [ $cnt -eq 10 ]
then
        echo "서버가 정상적으로 구동되지 않았습니다."
        exit 1
fi

# 3
sudo sed -i "s/${BEFORE_PORT}/${AFTER_PORT}/" /etc/nginx/conf.d/service-url.inc
sudo nginx -s reload
echo "배포완료."

# 4
echo "$BEFORE_COLOR server down(port:${BEFORE_PORT})"
sudo docker-compose -p test-${BEFORE_COLOR} -f /home/ubuntu/docker-compose.${BEFORE_COLOR}.yml down