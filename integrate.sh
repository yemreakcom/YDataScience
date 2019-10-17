python ../YGitBookIntegration/integrate.py . -ll 1 -l ../YWiki/Veri\ Bilimi/README.md -u https://ds.yemreak.com
echo "---
description: Sitede neler olup bittiğinin raporudur.
---
" > CHANGELOG.md

ygitchangelog.exe >> CHANGELOG.md
bash github .

