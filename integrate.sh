python ../YGitBookIntegration/integrate.py . -ll 1
echo "---
description: Sitede neler olup bittiğinin raporudur.
---
" > CHANGELOG.md

ygitchangelog.exe >> CHANGELOG.md
bash github .
