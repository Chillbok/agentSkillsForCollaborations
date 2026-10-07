# agentSkillsForCollaborations

협업용 git 워크플로우 **에이전트 스킬** 모음. 이슈 생성 → 브랜치 생성 → 커밋 → PR 생성을 AI에게 맡기기 위한 독립 스킬입니다.

OpenCode, Claude Code, Codex, Cursor, Gemini CLI, GitHub Copilot 등 [agentskills.io](https://agentskills.io) 표준을 읽는 에이전트 앱에서 동작합니다. 스킬 자동 로딩이 없는 앱에서도 붙여넣기로 사용할 수 있습니다.

## 스킬 목록

| 스킬 | 역할 | gh 필요 |
|---|---|---|
| `git-workflow` | 4단계 루틴 안내·상태 진단·다음 단계 라우팅 (진입점) | ✗ |
| `issue-create` | 작업 설명 → 이슈 생성 (표준 제목/라벨), 이슈 번호 보고 | ✓ |
| `branch-create` | 이슈 번호·type 확인 → `<type>/#<N>` 브랜치 생성 | 선택 |
| `commit` | 저장소 관례 탐지 → 커밋 생성/양식 수정 (Unity 사전 점검) | ✗ |
| `pr-create` | 이슈(계획)와 실제 구현을 대조 → 차이·이유 정리 → PR 생성 | ✓ |

각 스킬은 **자기완결**입니다. 다른 앱의 기능에 의존하지 않고, `git` / `gh` CLI와 파일시스템만 사용합니다. `git-workflow`는 형제 스킬을 이름 수준에서 안내·라우팅하는 진입점입니다(설치 시 함께 복사됨).

## 워크플로우

```
git-workflow  →  현재 상태 진단 + 다음 단계 라우팅 (진입점)
1. issue-create    → 이슈 #N 생성
2. branch-create   → feat/#N 브랜치
3. commit          → 작업하며 커밋 (간단히 커밋 후 양식 수정)
4. pr-create       → 이슈 대비 변경을 정리해 PR 생성
```

## 자동 호출 (트리거 예시)

스킬은 별도 호출 없이 **요청 내용에 따라 자동 로드**됩니다. 아래처럼 말하면 해당 스킬이 뜹니다.

| 이렇게 말하면 | 호출되는 스킬 |
|---|---|
| "작업 시작하자", "루틴대로 하자", "다음 뭐 해야 해", "어디까지 했는지" | `git-workflow` |
| "이슈 만들어줘", "계획용 이슈 좀" | `issue-create` |
| "5번 이슈로 브랜치 파줘" | `branch-create` |
| "커밋해줘", "마지막 커밋 양식에 맞게 수정" | `commit` |
| "PR 만들어줘", "이 브랜치 PR 올려줘" | `pr-create` |

> 개별 스킬은 **행위** 표현에, `git-workflow`는 **흐름·진단** 표현에 반응하도록 트리거를 분리했습니다. 설치 후 앱/세션을 재시작해야 스킬이 스캔됩니다. 자동 로딩을 지원하지 않는 앱은 [docs/install-no-skill-support.md](docs/install-no-skill-support.md)를 참고하세요.


## 빠른 설치 (AI에게 지시)

아래 문구를 그대로 에이전트에게 붙여넣으면 설치됩니다.

```text
이 프로젝트에 협업용 git 스킬을 설치해줘.
1. https://github.com/Chillbok/agentSkillsForCollaborations 를 임시 폴더에 clone
2. install/install.sh . --with-gh 를 실행해 .agents/skills/ 와 .claude/skills/ 에 스킬을 복사하고,
   GitHub CLI(gh)가 없으면 함께 설치해줘 (설치 명령은 실행 전에 나에게 확인받고)
3. 설치된 스킬 목록과 gh 상태를 확인해서 보고해줘
4. 이 스킬들을 커밋(팀 공유)할지 개인 설치로 두고 .gitignore에 추가할지 나에게 물어보고 결정대로 처리
```

Windows는 `install/install.ps1 -Target . -WithGh` 를 사용합니다. 자세한 내용은 [install/README.md](install/README.md).

## 설치 방법

| 방법 | 명령 |
|---|---|
| 설치 스크립트 (프로젝트 내부, 권장) | `bash install/install.sh .` |
| npx skills | `npx skills add Chillbok/agentSkillsForCollaborations` |
| GitHub CLI | `gh skill install Chillbok/agentSkillsForCollaborations --scope user` |
| 수동 복사 | `cp -R skills/* <프로젝트>/.agents/skills/` |

### 설치 경로 (공통 우선, 단독 규격은 예외)

| 도구 | 경로 | 비고 |
|---|---|---|
| **공통** | `.agents/skills/` | Codex·Cursor·Gemini CLI·Copilot·OpenCode·기타 다수 |
| Claude Code | `.claude/skills/` | `.agents/`를 읽지 않아 예외 설치 |

> 설치 스크립트는 위 두 경로에 기본 설치합니다. 다른 도구 전용 폴더가 필요하면 `--agents=opencode,cursor,...`로 추가하세요.

도구별 문서: [OpenCode](docs/install-opencode.md) · [Claude Code](docs/install-claude-code.md) · [Codex](docs/install-codex.md) · [Cursor](docs/install-cursor.md) · [Gemini CLI](docs/install-gemini-cli.md) · [Copilot/VS Code](docs/install-copilot-vscode.md) · [그 외](docs/install-other-agents.md) · [스킬 미지원 앱](docs/install-no-skill-support.md)

## 표준 (이슈·브랜치·커밋·PR 공통)

type 어휘를 하나로 통일합니다: `feat`, `fix`, `refactor`, `docs`, `chore`, `test`, `perf`, `style`

| type | 이슈 라벨 | 브랜치 |
|---|---|---|
| `feat` | `enhancement` | `feat/#N` |
| `fix` | `bug` | `fix/#N` |
| `refactor` | `enhancement` | `refactor/#N` |
| `docs` | `documentation` | `docs/#N` |
| `chore`/`test`/`perf`/`style` | (없음) | `<type>/#N` |

| 산출물 | 형식 |
|---|---|
| 이슈 제목 | `<type>: <한글 명사구>` |
| 브랜치 | `<type>/#<N>` |
| 커밋 제목 | `<type>: <요약함>` |
| PR 제목 | `<type>: <요약> (#<N>)` |

규칙은 저장소에서 **자동 탐지**합니다(`git log`, `gh label list`, `.github/ISSUE_TEMPLATE`). 못 찾으면 Conventional Commits + 저장소 언어를 기본값으로 사용합니다.

## GitHub CLI(gh)

`issue-create`, `pr-create`는 `gh`가 필요합니다. 없으면 스킬이 **OS를 판별해 설치를 묻고, 동의하면 AI가 설치**합니다(macOS/Linux/Windows 지원). 동의 없는 설치는 하지 않습니다. 자세한 절차는 각 스킬의 `references/gh-setup.md`.

## 구조

```
skills/
├── git-workflow/      SKILL.md (진입점·라우터)
├── commit/            SKILL.md + references/unity-git-guard.md
├── issue-create/      SKILL.md + references/{issue-template,gh-setup}.md
├── branch-create/     SKILL.md
└── pr-create/         SKILL.md + references/{pr-template,gh-setup}.md
install/               install.sh, install.ps1, README.md
docs/                  도구별 설치 문서
```

## 라이선스

MIT — [LICENSE](LICENSE)
