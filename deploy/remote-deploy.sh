#!/usr/bin/env bash
# EC2에서 실행(auto-deploy.sh가 부름): 서버만 새 이미지로 바꿔 켜고, 2분 안에 새 버전으로 응답하지 않으면 이전 이미지로 되돌린다.
#   remote-deploy.sh <새 이미지> <커밋>
# PostgreSQL과 데이터는 건드리지 않는다. 이전 이미지는 .env의 SERVER_IMAGE에 남아 있다.
set -euo pipefail
NEW="$1"
SHA="$2"
cd "$(dirname "$0")"
PREV=$(grep '^SERVER_IMAGE=' .env | cut -d= -f2- || true)

set_image() { sed -i '/^SERVER_IMAGE=/d' .env; echo "SERVER_IMAGE=$1" >> .env; }
up() { docker compose -f compose.prod.yaml up -d --no-build server caddy; }
# 서버 포트는 밖에 열지 않아서 같은 네트워크의 caddy 컨테이너 안에서 묻는다
version() { docker compose -f compose.prod.yaml exec -T caddy wget -qO- -T 3 http://server:8080/api/version 2>/dev/null || true; }
ready() {
  local want="$1"
  for _ in $(seq 1 60); do
    version | grep -q "\"$want\"" && return 0
    sleep 2
  done
  return 1
}

set_image "$NEW"
up
# Caddyfile이 바뀌었을 수 있어 다시 읽힌다(끊김 없음)
docker compose -f compose.prod.yaml exec -T caddy caddy reload --config /etc/caddy/Caddyfile >/dev/null 2>&1 || true

if ready "$SHA"; then
  echo "배포 완료: $NEW"
  docker image prune -af --filter "until=168h" >/dev/null # 1주일 넘은, 쓰지 않는 이미지 정리
  exit 0
fi

echo "새 버전이 2분 안에 응답하지 않음 → 이전 버전으로 되돌림" >&2
docker compose -f compose.prod.yaml logs --tail 40 server >&2 || true
if [ -n "$PREV" ] && [ "$PREV" != "$NEW" ]; then
  set_image "$PREV"
  up
fi
exit 1
