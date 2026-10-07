# GitHub Copilot / VS Code 설치

## 설치 경로
- 프로젝트: `.github/skills/` (`.claude/skills/`, `.agents/skills/`도 읽음)
- 사용자: `~/.copilot/skills/` 또는 `~/.agents/skills/`

Copilot/VS Code는 `.agents/skills/`를 읽으므로 기본 설치로 동작합니다. `.github/skills/`에 명시하려면 `--agents=github-copilot`.

## 방법 1 — 설치 스크립트 (프로젝트 내부, 권장)
```bash
git clone https://github.com/Chillbok/agentSkillsForCollaborations.git /tmp/agsk
bash /tmp/agsk/install/install.sh /경로/내프로젝트
# .github/skills/에 추가로 넣으려면:
bash /tmp/agsk/install/install.sh /경로/내프로젝트 --agents=github-copilot
```

## 방법 2 — 수동
```bash
mkdir -p .github/skills
cp -R /tmp/agsk/skills/* .github/skills/
```

## 참고
- Copilot 코드 리뷰(에이전트)도 `.github/skills/`를 인식합니다.
- 조직/저장소 스코프 스킬을 함께 쓸 수 있습니다.

## 검증
스킬 폴더 존재 확인 후 VS Code / Copilot 세션을 재시작합니다.
