# 그 외 에이전트 앱 설치

Agent Skills(agentskills.io) 표준을 읽는 대부분의 앱(Goose, Amp, Roo Code, JetBrains Junie, Kiro 등)은 **중립 경로 `.agents/skills/`** 를 인식합니다. 별도 설정 없이 기본 설치로 동작합니다.

## 권장 — 중립 경로 단일 설치
```bash
git clone https://github.com/Chillbok/agentSkillsForCollaborations.git /tmp/agsk
bash /tmp/agsk/install/install.sh /경로/내프로젝트
```
→ `.agents/skills/` + `.claude/skills/`에 복사됩니다.

## 도구별 경로 (참고)

| 도구 | 프로젝트 | 사용자 |
|---|---|---|
| Goose | `.agents/skills/` | `~/.agents/skills/` |
| Amp | `.agents/skills/` | `~/.agents/skills/` |
| Roo Code | `.agents/skills/` | `~/.agents/skills/` |
| JetBrains Junie | 도구 문서의 skills 경로 | — |
| Kiro | 도구 문서의 skills 경로 | — |

정확한 경로는 각 도구의 공식 문서를 확인하세요(버전에 따라 다를 수 있음).

## 규격이 다른 앱이라면
해당 앱이 자체 스킬 폴더를 요구하면, 그 경로에 `skills/*/`를 복사합니다. 스킬은 표준 최소 필드(`name`, `description`)만으로 동작하므로 대부분 그대로 인식됩니다.

스킬 자동 로딩이 **아예 없는** 앱이라면 [install-no-skill-support.md](install-no-skill-support.md)를 참고하세요.
