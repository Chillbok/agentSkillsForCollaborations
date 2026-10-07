# Cursor 설치

## 설치 경로
- 프로젝트: `.cursor/skills/` 또는 `.agents/skills/`
- 사용자: `~/.cursor/skills/` 또는 `~/.agents/skills/`

Cursor는 `.agents/skills/`(중립)도 읽으므로 기본 설치로 충분합니다. `.cursor/skills/`에 명시적으로 넣고 싶으면 `--agents=cursor`를 사용합니다.

## 방법 1 — 설치 스크립트 (프로젝트 내부, 권장)
```bash
git clone https://github.com/Chillbok/agentSkillsForCollaborations.git /tmp/agsk
bash /tmp/agsk/install/install.sh /경로/내프로젝트
# .cursor/skills/에 추가로 넣으려면:
bash /tmp/agsk/install/install.sh /경로/내프로젝트 --agents=cursor
```

## 방법 2 — npx skills
```bash
npx skills add Chillbok/agentSkillsForCollaborations -a cursor
```

## 방법 3 — 수동
```bash
mkdir -p .cursor/skills
cp -R /tmp/agsk/skills/* .cursor/skills/
```

## 참고
- Cursor는 `.claude/skills/`, `.codex/skills/`도 호환으로 읽습니다.
- 중첩 디렉터리의 `.cursor/skills/`는 해당 경로에 스코프됩니다(모노레포).

## 검증
스킬 폴더 존재 확인 후 Cursor를 재시작합니다.
