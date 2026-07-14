#!/usr/bin/env bash
# 볼트의 publish:true 페이지를 공개 사이트로 동기화하고 배포한다.
# 쓰는 법:  bash publish.sh
set -e
SITE="/c/Users/rkdtk/wiki-site"
VAULT="/c/Users/rkdtk/Desktop/WIKI/wiki"
cd "$SITE"

# content 갱신: 손으로 만든 index.md만 남기고, 공개 페이지를 볼트에서 새로 복사
find content -maxdepth 1 -name '*.md' ! -name 'index.md' -delete
n=0
for f in "$VAULT"/*.md; do
  if grep -q '^publish: true' "$f"; then cp "$f" content/; n=$((n+1)); fi
done
echo "공개 페이지 ${n}개 동기화"

git add -A
if git -c user.name=rkdtk -c user.email=rkdtkdwhd@gmail.com commit -m "위키 공개본 갱신" 2>/dev/null; then
  git push origin main
  echo "푸시 완료 → 1~2분 뒤 https://dominkang90.github.io/wiki-site/ 갱신"
else
  echo "바뀐 내용 없음 (배포 생략)"
fi
