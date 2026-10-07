#!/usr/bin/env bash
# agentSkillsForCollaborations 설치 스크립트
# 프로젝트 내부에 협업용 git 스킬을 복사합니다.
#
# 사용법:
#   install.sh [타깃프로젝트경로] [옵션]
#
# 옵션:
#   --agents=opencode,claude-code,codex,cursor,gemini-cli,github-copilot
#                            기본(.agents, .claude) 외 도구별 폴더에 추가 설치
#   --gitignore              스킬 경로를 타깃 .gitignore에 추가 (개인 설치)
#   --tracked                .gitignore를 건드리지 않음 (팀 공유)
#   --force                  이미 설치된 스킬을 덮어씀
#   --with-gh                GitHub CLI(gh)가 없으면 함께 설치
#   --prerequisites          --with-gh 와 동일
#   -h, --help               도움말
set -euo pipefail

REPO_URL="https://github.com/Chillbok/agentSkillsForCollaborations.git"

TARGET="."
AGENTS=""
GITIGNORE_MODE=""   # "", "gitignore", "tracked"
FORCE=0
WITH_GH=0

usage() {
  sed -n '2,16p' "$0" | sed 's/^# \{0,1\}//'
}

while [ $# -gt 0 ]; do
  case "$1" in
    --agents=*) AGENTS="${1#*=}"; shift ;;
    --gitignore) GITIGNORE_MODE="gitignore"; shift ;;
    --tracked) GITIGNORE_MODE="tracked"; shift ;;
    --force) FORCE=1; shift ;;
    --with-gh|--prerequisites) WITH_GH=1; shift ;;
    -h|--help) usage; exit 0 ;;
    --*) echo "알 수 없는 옵션: $1" >&2; exit 1 ;;
    *) TARGET="$1"; shift ;;
  esac
done

if [ ! -d "$TARGET" ]; then
  echo "오류: 타깃 경로가 존재하지 않습니다: $TARGET" >&2
  exit 1
fi
TARGET="$(cd "$TARGET" && pwd)"

# 스킬 소스 확보: 로컬 repo면 그대로, 아니면 임시 clone
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
CLEANUP=""
if [ -d "$ROOT_DIR/skills" ]; then
  SRC="$ROOT_DIR/skills"
else
  TMP="$(mktemp -d)"
  echo "스킬 저장소를 내려받는 중..."
  git clone --depth 1 "$REPO_URL" "$TMP" >/dev/null 2>&1
  SRC="$TMP/skills"
  CLEANUP="$TMP"
fi
trap '[ -n "$CLEANUP" ] && rm -rf "$CLEANUP"' EXIT

# 설치 대상 디렉터리 결정 (상대 경로)
#   공통: .agents/skills   예외: .claude/skills (Claude Code)
DESTS=".agents/skills .claude/skills"

agent_dest() {
  case "$1" in
    opencode) echo ".opencode/skills" ;;
    claude|claude-code) echo ".claude/skills" ;;
    codex) echo ".agents/skills" ;;
    cursor) echo ".cursor/skills" ;;
    gemini|gemini-cli) echo ".gemini/skills" ;;
    copilot|github-copilot) echo ".github/skills" ;;
    *) echo "" ;;
  esac
}

if [ -n "$AGENTS" ]; then
  IFS=',' read -r -a _agents <<< "$AGENTS"
  for a in "${_agents[@]}"; do
    d="$(agent_dest "$(echo "$a" | tr -d ' ')")"
    if [ -z "$d" ]; then
      echo "경고: 알 수 없는 에이전트 '$a' (건너뜀)" >&2
      continue
    fi
    case " $DESTS " in *" $d "*) ;; *) DESTS="$DESTS $d" ;; esac
  done
fi

echo "설치 대상: $TARGET"
echo "스킬 소스: $SRC"
echo

for dest in $DESTS; do
  dest_abs="$TARGET/$dest"
  mkdir -p "$dest_abs"
  for skill in "$SRC"/*/; do
    name="$(basename "$skill")"
    [ -f "$skill/SKILL.md" ] || continue
    out="$dest_abs/$name"
    if [ -e "$out" ] && [ "$FORCE" -ne 1 ]; then
      echo "  건너뜀(이미 존재): $dest/$name  (덮어쓰려면 --force)"
      continue
    fi
    rm -rf "$out"
    cp -R "$skill" "$out"
    echo "  설치됨: $dest/$name"
  done
done

echo
echo "=== .gitignore 상태 ==="
is_git=0
if git -C "$TARGET" rev-parse --git-dir >/dev/null 2>&1; then
  is_git=1
fi

ignore_rel=""
if [ "$is_git" -eq 1 ]; then
  for dest in $DESTS; do
    if git -C "$TARGET" check-ignore -q "$dest" 2>/dev/null; then
      echo "  $dest  → 이미 무시됨"
    else
      echo "  $dest  → 무시 안 됨 (추적 대상)"
      ignore_rel="$ignore_rel/$dest/
"
    fi
  done
else
  echo "  (git 저장소가 아님 — .gitignore 처리 생략)"
fi

if [ -n "$GITIGNORE_MODE" ] && [ "$GITIGNORE_MODE" = "gitignore" ] && [ "$is_git" -eq 1 ] && [ -n "$ignore_rel" ]; then
  GI="$TARGET/.gitignore"
  {
    echo ""
    echo "# 협업 스킬 (로컬 설치)"
    printf '%s' "$ignore_rel"
  } >> "$GI"
  echo
  echo ".gitignore에 스킬 경로를 추가했습니다 (개인 설치)."
elif [ "$GITIGNORE_MODE" = "tracked" ]; then
  echo
  echo ".gitignore를 수정하지 않았습니다 (팀 공유 — 커밋 대상)."
elif [ "$is_git" -eq 1 ] && [ -n "$ignore_rel" ]; then
  echo
  echo "질문: 이 스킬들을 커밋(팀 공유)할까요, 개인 설치로 두고 .gitignore에 추가할까요?"
  echo "  · 개인 설치: 이 스크립트를 --gitignore 로 다시 실행"
  echo "  · 팀 공유:   그대로 커밋 (--tracked)"
fi

# ── 사전 요구사항 (git / gh) ────────────────────────────────
echo
echo "=== 사전 요구사항 ==="

if command -v git >/dev/null 2>&1; then
  echo "  [OK] git: $(git --version)"
else
  echo "  [X] git이 없습니다. https://git-scm.com 에서 설치하세요." >&2
fi

install_gh() {
  local os; os="$(uname -s)"
  case "$os" in
    Darwin)
      if command -v brew >/dev/null 2>&1; then
        echo "  실행: brew install gh"
        brew install gh
      else
        echo "  Homebrew가 없습니다. https://github.com/cli/cli/releases 에서 설치하세요." >&2
        return 1
      fi ;;
    Linux)
      if command -v apt-get >/dev/null 2>&1; then
        echo "  실행: 공식 apt repo 등록 후 sudo apt-get install gh (비밀번호 입력 필요)"
        type -p wget >/dev/null || sudo apt-get install -y wget
        sudo mkdir -p -m 755 /etc/apt/keyrings
        wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg \
          | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null
        sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
          | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
        sudo apt-get update && sudo apt-get install -y gh
      elif command -v dnf >/dev/null 2>&1; then
        echo "  실행: sudo dnf install -y gh"
        sudo dnf install -y gh
      elif command -v pacman >/dev/null 2>&1; then
        echo "  실행: sudo pacman -S --noconfirm github-cli"
        sudo pacman -S --noconfirm github-cli
      elif command -v snap >/dev/null 2>&1; then
        echo "  실행: sudo snap install gh"
        sudo snap install gh
      else
        echo "  패키지 매니저를 찾지 못했습니다. https://github.com/cli/cli/releases 에서 설치하세요." >&2
        return 1
      fi ;;
    *)
      echo "  지원하지 않는 OS: $os. https://github.com/cli/cli/releases 에서 설치하세요." >&2
      return 1 ;;
  esac
}

if command -v gh >/dev/null 2>&1; then
  echo "  [OK] gh: $(gh --version | head -1)"
  if gh auth status >/dev/null 2>&1; then
    echo "  [OK] gh 인증됨"
  else
    echo "  [ ] gh 인증이 필요합니다. 터미널에서 'gh auth login' 을 실행하세요."
  fi
elif [ "$WITH_GH" -eq 1 ]; then
  echo "  [ ] gh가 없어 설치를 시도합니다."
  if install_gh && command -v gh >/dev/null 2>&1; then
    echo "  [OK] gh 설치됨: $(gh --version | head -1)"
    echo "  다음: 'gh auth login' 으로 인증하세요."
  else
    echo "  [X] gh 자동 설치 실패. https://github.com/cli/cli/releases 를 참고하세요." >&2
  fi
else
  echo "  [ ] gh가 없습니다(issue-create/pr-create에 필요). --with-gh 로 함께 설치할 수 있습니다."
fi

echo
echo "설치 완료. 에이전트를 재시작하면 스킬이 인식됩니다."
