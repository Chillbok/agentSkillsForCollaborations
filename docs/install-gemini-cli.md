# Gemini CLI 설치

## 설치 경로
- 프로젝트: `.gemini/skills/<name>/SKILL.md` (또는 별칭 `.agents/skills/`)
- 사용자: `~/.gemini/skills/` (또는 별칭 `~/.agents/skills/`)

Gemini CLI는 `.agents/skills/`를 별칭으로 읽으므로 기본 설치로 동작합니다. `.gemini/skills/`에 명시하려면 `--agents=gemini-cli`.

## 방법 1 — 설치 스크립트 (프로젝트 내부, 권장)
```bash
git clone https://github.com/Chillbok/agentSkillsForCollaborations.git /tmp/agsk
bash /tmp/agsk/install/install.sh /경로/내프로젝트
# .gemini/skills/에 추가로 넣으려면:
bash /tmp/agsk/install/install.sh /경로/내프로젝트 --agents=gemini-cli
```

## 방법 2 — Gemini CLI 내장
```bash
gemini skills install Chillbok/agentSkillsForCollaborations
```

## 방법 3 — 수동
```bash
mkdir -p .gemini/skills
cp -R /tmp/agsk/skills/* .gemini/skills/
```

## 검증
```bash
gemini skills list
```
