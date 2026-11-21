#!/bin/bash
# 매일 DB를 덤프해 14일치 보관. 시세 기록은 다시 받을 수 없어서(eBay는 지금 글만 줌) 꼭 남긴다.
# EC2에서 systemd 타이머(partstock-backup.timer)가 부른다. 맥으로 가져가기: deploy/pull-backup.sh
set -euo pipefail
cd ~/partstock
mkdir -p backups
docker compose -f compose.prod.yaml exec -T postgres pg_dump -U partstock -Fc partstock > "backups/partstock-$(date -u +%F).dump"
find backups -name 'partstock-*.dump' -mtime +14 -delete
