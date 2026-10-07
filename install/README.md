# 설치 스크립트 안내

스킬을 **프로젝트 내부에 복사**합니다. 기본 설치 대상은 `.agents/skills/`(공통)와 `.claude/skills/`(Claude Code 예외)입니다.

## AI에게 설치를 지시하기 (권장)

사용자는 아래 문구를 그대로 에이전트에게 붙여넣으면 됩니다.

```text
이 프로젝트에 협업용 git 스킬을 설치해줘.
1. https://github.com/Chillbok/agentSkillsForCollaborations 를 임시 폴더에 clone
2. install/install.sh . 를 실행해 .agents/skills/ 와 .claude/skills/ 에 스킬을 복사
3. 설치된 스킬 목록을 확인해서 보고해줘
4. 설치 후, 이 스킬들을 커밋(팀 공유)할지 개인 설치로 두고 .gitignore에 추가할지 나에게 물어보고,
   내 결정대로 처리해줘 (개인 설치면 --gitignore 로 재실행, 팀 공유면 --tracked)
```

Windows(PowerShell)라면:

```text
이 프로젝트에 협업용 git 스킬을 설치해줘.
1. https://github.com/Chillbok/agentSkillsForCollaborations 를 임시 폴더에 clone
2. install/install.ps1 -Target . 를 실행
3. 설치된 스킬 목록을 확인해서 보고
4. 커밋할지 개인 설치(gitignore)로 둘지 물어보고 결정대로 처리
```

## 직접 실행

### macOS / Linux
```bash
git clone https://github.com/Chillbok/agentSkillsForCollaborations.git /tmp/agsk
bash /tmp/agsk/install/install.sh /경로/내프로젝트
```

### Windows (PowerShell)
```powershell
git clone https://github.com/Chillbok/agentSkillsForCollaborations.git $env:TEMP\agsk
powershell -ExecutionPolicy Bypass -File $env:TEMP\agsk\install\install.ps1 -Target .\내프로젝트
```

## 옵션

| 옵션 | 설명 |
|---|---|
| `[타깃경로]` / `-Target` | 설치할 프로젝트 경로 (기본: 현재 디렉터리) |
| `--agents=` / `-Agents` | 추가 도구 폴더. 쉼표 구분 (`opencode`, `codex`, `cursor`, `gemini-cli`, `github-copilot`) |
| `--gitignore` / `-Gitignore` | 스킬 경로를 `.gitignore`에 추가 (개인 설치) |
| `--tracked` / `-Tracked` | `.gitignore`를 건드리지 않음 (팀 공유) |
| `--force` / `-Force` | 이미 설치된 스킬을 덮어씀 |
| `-h`, `--help` | 도움말 |

> 옵션 없이 실행하면 `.gitignore`를 **수정하지 않고**, 커밋/개인설치 여부를 묻는 문구만 출력합니다. 결정은 AI가 사용자에게 물어 처리합니다.

## 동작

1. 스킬 저장소를 확보(로컬이면 그대로, 아니면 임시 clone)
2. `skills/*/`를 `.agents/skills/` + `.claude/skills/`로 복사 (기본)
3. `.gitignore` 현재 상태 진단 + 질문 출력
