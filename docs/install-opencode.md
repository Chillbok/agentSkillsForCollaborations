# OpenCode 설치

## 설치 경로
- 프로젝트: `.opencode/skills/<name>/SKILL.md`
- 사용자: `~/.config/opencode/skills/<name>/SKILL.md`

OpenCode는 `.opencode/`, `.claude/`, `.agents/` 세 경로를 모두 읽습니다. 따라서 **공통 경로 `.agents/skills/`에만 설치해도 OpenCode에서 동작**합니다.

## 방법 1 — 설치 스크립트 (프로젝트 내부, 권장)
```bash
git clone https://github.com/Chillbok/agentSkillsForCollaborations.git /tmp/agsk
bash /tmp/agsk/install/install.sh /경로/내프로젝트
```
- `.agents/skills/`(공통) + `.claude/skills/`에 복사됩니다.
- `.opencode/skills/`에 따로 넣고 싶으면:
```bash
bash /tmp/agsk/install/install.sh /경로/내프로젝트 --agents=opencode
```

## 방법 2 — npx skills
```bash
npx skills add Chillbok/agentSkillsForCollaborations -a opencode
```

## 방법 3 — 수동
```bash
mkdir -p .opencode/skills
cp -R /tmp/agsk/skills/* .opencode/skills/
```

## 검증
프로젝트에 `.agents/skills/commit/SKILL.md` 등이 있는지 확인하고 OpenCode를 재시작합니다.
