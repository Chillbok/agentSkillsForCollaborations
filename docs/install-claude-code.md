# Claude Code 설치

## 설치 경로
- 프로젝트: `.claude/skills/<name>/SKILL.md`
- 사용자: `~/.claude/skills/<name>/SKILL.md`

Claude Code는 `.agents/skills/`를 읽지 않으므로 **반드시 `.claude/skills/`에 설치**해야 합니다. (이 스킬 저장소의 설치 스크립트는 `.claude/skills/`를 기본 포함합니다.)

## 방법 1 — 설치 스크립트 (프로젝트 내부, 권장)
```bash
git clone https://github.com/Chillbok/agentSkillsForCollaborations.git /tmp/agsk
bash /tmp/agsk/install/install.sh /경로/내프로젝트
```
- `.agents/skills/` + `.claude/skills/`에 복사되어 Claude Code에서 인식됩니다.

## 방법 2 — npx skills
```bash
npx skills add Chillbok/agentSkillsForCollaborations -a claude-code
```

## 방법 3 — 수동
```bash
mkdir -p .claude/skills
cp -R /tmp/agsk/skills/* .claude/skills/
```

## 호출
스킬은 `/스킬이름` 슬래시 커맨드로도, description 매칭으로 자동 로드되기도 합니다. (예: `/commit`, `/issue-create`)

## 검증
`.claude/skills/commit/SKILL.md` 존재 확인 후 세션을 재시작합니다.
