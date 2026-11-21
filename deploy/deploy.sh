#!/bin/bash
# 맥에서 실행: jar → x86 이미지 → EC2로 보내서 교체. 사용: deploy/deploy.sh <EC2 IP>
# GitHub 레포·CI를 만들기 전 임시 방식(NowStation처럼 레지스트리 + 서버가 가져가는 방식은 나중에).
set -euo pipefail
HOST="ec2-user@$1"
KEY=~/.ssh/partstock.pem
TAG=$(git rev-parse --short HEAD)
cd "$(dirname "$0")/.."

(cd server && ./gradlew bootJar -q)
docker buildx build --platform linux/amd64 -t partstock-server:"$TAG" --load server
docker save partstock-server:"$TAG" | gzip | ssh -i $KEY "$HOST" 'gunzip | docker load'
scp -i $KEY deploy/compose.prod.yaml deploy/backup.sh "$HOST":partstock/
ssh -i $KEY "$HOST" "cd partstock && SERVER_TAG=$TAG docker compose -f compose.prod.yaml up -d && docker image prune -f >/dev/null"
echo "배포 $TAG 완료. 로그: ssh -i $KEY $HOST 'cd partstock && docker compose -f compose.prod.yaml logs --tail 50 server'"
