#!/bin/bash
# 매일 DB를 덤프해 EC2에 14일치 + S3에 전부 보관. 시세 기록은 다시 받을 수 없어서(eBay는 지금 글만 줌) 서버 밖에도 남긴다.
# EC2에서 systemd 타이머(partstock-backup.timer, 04:00 UTC)가 부른다.
# S3 올리기는 EC2 역할(partstock-ec2, 백업 버킷에 올리기·목록만)로 한다 → 서버에 AWS 키 없음. 버킷 이름은 .env의 BACKUP_BUCKET.
set -euo pipefail
cd ~/partstock
mkdir -p backups
FILE="backups/partstock-$(date -u +%F).dump"
docker compose -f compose.prod.yaml exec -T postgres pg_dump -U partstock -Fc partstock > "$FILE"
find backups -name 'partstock-*.dump' -mtime +14 -delete

BUCKET=$(grep '^BACKUP_BUCKET=' .env | cut -d= -f2- || true)
if [ -z "$BUCKET" ]; then
  echo "BACKUP_BUCKET이 .env에 없음 → S3에 올리지 않음(EC2에만 보관)" >&2
  exit 1
fi
aws s3 cp "$FILE" "s3://$BUCKET/daily/" --region ap-southeast-2 --only-show-errors
echo "백업 완료: $FILE → s3://$BUCKET/daily/"
