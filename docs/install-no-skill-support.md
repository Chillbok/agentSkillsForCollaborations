# 스킬 미지원 앱에서 사용 (폴백)

Agent Skills 자동 로딩을 지원하지 않는 앱(일반 챗봇, 스킬 개념이 없는 에디터 등)에서는 **`SKILL.md` 본문을 그 앱의 시스템 프롬프트/규칙 파일에 붙여넣어** 동일하게 사용할 수 있습니다.

## 방법

1. 필요한 스킬의 `SKILL.md` 본문(프론트매터 제외)을 복사합니다.
   - `skills/commit/SKILL.md`
   - `skills/issue-create/SKILL.md`
   - `skills/branch-create/SKILL.md`
   - `skills/pr-create/SKILL.md`
2. 해당 앱의 **시스템 프롬프트 / 커스텀 인스트럭션 / 규칙 파일**(예: `AGENTS.md`, `CLAUDE.md`, 커스텀 지침)에 붙여넣습니다.
3. 그 스킬이 참조하는 `references/*.md`도 함께 붙여넣거나, 같은 폴더에 두고 읽도록 안내합니다.

## 예: 여러 스킬을 하나의 규칙 파일로

```markdown
# 협업 git 규칙

## 커밋
<skills/commit/SKILL.md 본문>

## 이슈 생성
<skills/issue-create/SKILL.md 본문>
```

## 전제 조건

- 스킬은 `git` / `gh` CLI와 파일시스템만 사용하므로, 앱이 터미널 명령 실행을 지원하면 그대로 동작합니다.
- 명령 실행이 불가능한 앱이라면, 스킬이 **사용자에게 실행할 명령/메시지를 제시**하는 방식으로 동작합니다(예: 커밋 메시지 초안 출력, `gh issue create` 명령 안내).

## 팁
- 한 번에 다 넣지 말고 필요한 스킬만 넣어 컨텍스트를 아끼세요.
- `description` 문구를 그대로 두면, 스킬 로딩을 지원하는 앱에서는 자동 로드 트리거로도 쓰입니다.
