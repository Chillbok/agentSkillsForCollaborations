# agentSkillsForCollaborations 설치 스크립트 (Windows / PowerShell)
# 프로젝트 내부에 협업용 git 스킬을 복사합니다.
#
# 사용법:
#   .\install.ps1 [-Target <경로>] [-Agents opencode,claude-code,codex] [-Gitignore] [-Tracked] [-Force]
param(
  [string]$Target = ".",
  [string]$Agents = "",
  [switch]$Gitignore,
  [switch]$Tracked,
  [switch]$Force,
  [switch]$WithGh
)

$ErrorActionPreference = "Stop"
$RepoUrl = "https://github.com/Chillbok/agentSkillsForCollaborations.git"

if (-not (Test-Path $Target)) { Write-Error "타깃 경로가 존재하지 않습니다: $Target"; exit 1 }
$Target = (Resolve-Path $Target).Path

# 스킬 소스 확보: 로컬 repo면 그대로, 아니면 임시 clone
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RootDir = Split-Path -Parent $ScriptDir
$Cleanup = $null
if (Test-Path (Join-Path $RootDir "skills")) {
  $Src = Join-Path $RootDir "skills"
} else {
  $Tmp = Join-Path ([System.IO.Path]::GetTempPath()) ("agsk_" + [System.Guid]::NewGuid().ToString("N"))
  New-Item -ItemType Directory -Path $Tmp | Out-Null
  Write-Host "스킬 저장소를 내려받는 중..."
  git clone --depth 1 $RepoUrl $Tmp | Out-Null
  $Src = Join-Path $Tmp "skills"
  $Cleanup = $Tmp
}

function Get-AgentDest([string]$agent) {
  switch ($agent) {
    "opencode"          { ".opencode/skills" }
    "claude"            { ".claude/skills" }
    "claude-code"       { ".claude/skills" }
    "codex"             { ".agents/skills" }
    "cursor"            { ".cursor/skills" }
    "gemini"            { ".gemini/skills" }
    "gemini-cli"        { ".gemini/skills" }
    "copilot"           { ".github/skills" }
    "github-copilot"    { ".github/skills" }
    default             { "" }
  }
}

# 설치 대상: 공통 .agents/skills + 예외 .claude/skills
$Dests = New-Object System.Collections.Generic.List[string]
$Dests.Add(".agents/skills")
$Dests.Add(".claude/skills")
if ($Agents -ne "") {
  foreach ($a in ($Agents -split ",")) {
    $d = Get-AgentDest ($a.Trim())
    if ($d -eq "") { Write-Warning "알 수 없는 에이전트 '$a' (건너뜀)"; continue }
    if (-not $Dests.Contains($d)) { $Dests.Add($d) }
  }
}

Write-Host "설치 대상: $Target"
Write-Host "스킬 소스: $Src"
Write-Host ""

foreach ($dest in $Dests) {
  $destAbs = Join-Path $Target $dest
  New-Item -ItemType Directory -Force -Path $destAbs | Out-Null
  Get-ChildItem -Directory $Src | ForEach-Object {
    $skill = $_.FullName
    $name = $_.Name
    if (-not (Test-Path (Join-Path $skill "SKILL.md"))) { return }
    $out = Join-Path $destAbs $name
    if ((Test-Path $out) -and (-not $Force)) {
      Write-Host "  건너뜀(이미 존재): $dest/$name  (덮어쓰려면 -Force)"
      return
    }
    if (Test-Path $out) { Remove-Item -Recurse -Force $out }
    Copy-Item -Recurse -Force $skill $out
    Write-Host "  설치됨: $dest/$name"
  }
}

Write-Host ""
Write-Host "=== .gitignore 상태 ==="
$IsGit = $false
try { git -C $Target rev-parse --git-dir *> $null; $IsGit = $true } catch {}

$ignoreRel = @()
if ($IsGit) {
  foreach ($dest in $Dests) {
    git -C $Target check-ignore -q $dest 2>$null
    if ($LASTEXITCODE -eq 0) {
      Write-Host "  $dest  → 이미 무시됨"
    } else {
      Write-Host "  $dest  → 무시 안 됨 (추적 대상)"
      $ignoreRel += "/$dest/"
    }
  }
} else {
  Write-Host "  (git 저장소가 아님 — .gitignore 처리 생략)"
}

if ($Gitignore -and $IsGit -and $ignoreRel.Count -gt 0) {
  $gi = Join-Path $Target ".gitignore"
  Add-Content -Path $gi -Value ""
  Add-Content -Path $gi -Value "# 협업 스킬 (로컬 설치)"
  foreach ($r in $ignoreRel) { Add-Content -Path $gi -Value $r }
  Write-Host ""
  Write-Host ".gitignore에 스킬 경로를 추가했습니다 (개인 설치)."
} elseif ($Tracked) {
  Write-Host ""
  Write-Host ".gitignore를 수정하지 않았습니다 (팀 공유 — 커밋 대상)."
} elseif ($IsGit -and $ignoreRel.Count -gt 0) {
  Write-Host ""
  Write-Host "질문: 이 스킬들을 커밋(팀 공유)할까요, 개인 설치로 두고 .gitignore에 추가할까요?"
  Write-Host "  · 개인 설치: -Gitignore 로 다시 실행"
  Write-Host "  · 팀 공유:   그대로 커밋 (-Tracked)"
}

if ($Cleanup) { Remove-Item -Recurse -Force $Cleanup }

# ── 사전 요구사항 (git / gh) ────────────────────────────────
Write-Host ""
Write-Host "=== 사전 요구사항 ==="

try {
  Write-Host "  [OK] git: $(git --version)"
} catch {
  Write-Host "  [X] git이 없습니다. https://git-scm.com 에서 설치하세요." -ForegroundColor Red
}

function Install-Gh {
  if (Get-Command winget -ErrorAction SilentlyContinue) {
    Write-Host "  실행: winget install --id GitHub.cli"
    winget install --id GitHub.cli --accept-source-agreements --accept-package-agreements
  } elseif (Get-Command scoop -ErrorAction SilentlyContinue) {
    Write-Host "  실행: scoop install gh"
    scoop install gh
  } elseif (Get-Command choco -ErrorAction SilentlyContinue) {
    Write-Host "  실행: choco install gh -y"
    choco install gh -y
  } else {
    Write-Host "  패키지 매니저(winget/scoop/choco)를 찾지 못했습니다. https://github.com/cli/cli/releases 에서 설치하세요." -ForegroundColor Red
    return $false
  }
  return $true
}

if (Get-Command gh -ErrorAction SilentlyContinue) {
  $ghv = (gh --version | Select-Object -First 1)
  Write-Host "  [OK] gh: $ghv"
  gh auth status *> $null
  if ($LASTEXITCODE -eq 0) {
    Write-Host "  [OK] gh 인증됨"
  } else {
    Write-Host "  [ ] gh 인증이 필요합니다. 'gh auth login' 을 실행하세요."
  }
} elseif ($WithGh) {
  Write-Host "  [ ] gh가 없어 설치를 시도합니다."
  if ((Install-Gh) -and (Get-Command gh -ErrorAction SilentlyContinue)) {
    Write-Host "  [OK] gh 설치됨. 다음: 'gh auth login' 으로 인증하세요."
  } else {
    Write-Host "  [X] gh 자동 설치 실패. https://github.com/cli/cli/releases 를 참고하세요." -ForegroundColor Red
  }
} else {
  Write-Host "  [ ] gh가 없습니다(issue-create/pr-create에 필요). -WithGh 로 함께 설치할 수 있습니다."
}

Write-Host ""
Write-Host "설치 완료. 에이전트를 재시작하면 스킬이 인식됩니다."
