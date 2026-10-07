# Codex 설치

## 설치 경로
- 프로젝트: `.agents/skills/<name>/SKILL.md`
- 사용자: `~/.agents/skills/<name>/SKILL.md`

Codex는 중립 경로 `.agents/skills/`를 읽습니다. (일부 문서의 legacy `.codex/skills/`도 병행 지원될 수 있으나, 이 저장소는 **`.agents/skills/`를 표준**으로 사용합니다.)

## 방법 1 — 설치 스크립트 (프로젝트 내부, 권장)
```bash
git clone https://github.com/Chillbok/agentSkillsForCollaborations.git /tmp/agsk
bash /tmp/agsk/install/install.sh /경로/내프로젝트
```
- `.agents/skills/`에 복사됩니다(Codex 자동 인식).

## 방법 2 — npx skills
```bash
npx skills add Chillbok/agentSkillsForCollaborations -a codex
```

## 방법 3 — 수동
```bash
mkdir -p .agents/skills
cp -R /tmp/agsk/skills/* .agents/skills/
```

## 호출
`$스킬이름` 또는 `/skills` 로 확인합니다.

## 검증
`.agents/skills/commit/SKILL.md` 존재 확인 후 세션을 재시작합니다.
