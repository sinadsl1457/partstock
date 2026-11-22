#!/usr/bin/env bash
# EC2에서 1분마다(systemd 타이머 partstock-deploy.timer) 돈다: GHCR의 main 이미지가 바뀌었으면 받아서 교체한다.
# GitHub은 서버에 들어오지 않는다(pull 방식). 서버에는 이미지 읽기 전용 토큰만 있다(docker login ghcr.io, read:packages).
# NowStation 서버와 같은 구조.
set -euo pipefail
REPO=ghcr.io/sinadsl1457/partstock-server
DIR=/home/ec2-user/partstock
cd "$DIR"

# 교체에 1~2분 걸려 다음 확인과 겹칠 수 있다 → 하나만
exec 9>/tmp/partstock-deploy.lock
flock -n 9 || exit 0

# 이름표가 그대로면 몇 KB짜리 확인만 하고 끝난다
docker pull -q "$REPO:main" >/dev/null
SHA=$(docker image inspect -f '{{index .Config.Labels "org.opencontainers.image.revision"}}' "$REPO:main")
NEW="$REPO:$SHA"
CURRENT=$(grep '^SERVER_IMAGE=' .env | cut -d= -f2- || true)
[ "$NEW" = "$CURRENT" ] && exit 0
# 실패해서 되돌린 버전은 다시 시도하지 않는다(안 그러면 매분 깔았다 되돌리며 서버가 끊긴다)
[ "$SHA" = "$(cat .failed-sha 2>/dev/null || true)" ] && exit 0

echo "새 버전 ${SHA:0:7} 발견 → 교체"
docker pull -q "$NEW" >/dev/null
# 배포 설정 파일을 이미지에서 꺼낸다. 덮어쓰지 않고 이름을 바꿔 넣어, 돌고 있는 이 스크립트가 깨지지 않게 한다
TMP=$(mktemp -d)
cid=$(docker create "$NEW")
docker cp "$cid:/deploy/." "$TMP/"
docker rm "$cid" >/dev/null
for f in compose.prod.yaml Caddyfile backup.sh remote-deploy.sh auto-deploy.sh; do mv -f "$TMP/$f" "$f"; done
rm -rf "$TMP"
chmod +x backup.sh remote-deploy.sh auto-deploy.sh

if bash remote-deploy.sh "$NEW" "$SHA"; then
  rm -f .failed-sha
else
  echo "$SHA" > .failed-sha
  echo "${SHA:0:7} 실패 → 이전 버전 유지, 이 버전은 다시 시도하지 않음" >&2
  exit 1
fi
