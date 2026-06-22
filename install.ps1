# Living Codex installer (Windows).
# Piped:  irm https://raw.githubusercontent.com/andoop/living-codex/main/install.ps1 | iex
# Local:  .\install.ps1 [-Platform kiro] [-Uninstall]
param(
  [string]$Platform = "",
  [switch]$Uninstall
)
$ErrorActionPreference = "Stop"
$RepoUrl   = "https://github.com/andoop/living-codex.git"
$SkillName = "cartographer"
$ProjectRoot = if ($env:LIVING_CODEX_TARGET) { $env:LIVING_CODEX_TARGET } else { (Get-Location).Path }

# Locate skill: local copy next to script, else download repo.
$SkillSrc = $null
$cleanup  = $null
if ($PSScriptRoot -and (Test-Path (Join-Path $PSScriptRoot "skill\SKILL.md"))) {
  $SkillSrc = Join-Path $PSScriptRoot "skill"
} else {
  if (-not (Get-Command git -ErrorAction SilentlyContinue)) { throw "git is required for the piped install (or clone the repo and run .\install.ps1 locally)." }
  $cleanup = Join-Path ([System.IO.Path]::GetTempPath()) ("living-codex-" + [guid]::NewGuid())
  Write-Host "[living-codex] downloading skill from $RepoUrl ..."
  git clone --depth 1 $RepoUrl (Join-Path $cleanup "living-codex") 2>$null | Out-Null
  $SkillSrc = Join-Path $cleanup "living-codex\skill"
}
if (-not (Test-Path (Join-Path $SkillSrc "SKILL.md"))) { throw "skill\SKILL.md not found at $SkillSrc" }

function Dest($plat) {
  switch ($plat) {
    "kiro"    { Join-Path $ProjectRoot ".kiro\skills\$SkillName" }
    "claude"  { Join-Path $ProjectRoot ".claude\skills\$SkillName" }
    "cursor"  { Join-Path $ProjectRoot ".cursor\skills\$SkillName" }
    "codex"   { Join-Path $ProjectRoot ".agents\skills\$SkillName" }
    default   { Join-Path $ProjectRoot "skills\$SkillName" }
  }
}
function Detect {
  $f = @()
  if (Test-Path (Join-Path $ProjectRoot ".kiro"))    { $f += "kiro" }
  if (Test-Path (Join-Path $ProjectRoot "CLAUDE.md")){ $f += "claude" }
  if (Test-Path (Join-Path $ProjectRoot ".cursor"))  { $f += "cursor" }
  if (Test-Path (Join-Path $ProjectRoot ".agents"))  { $f += "codex" }
  if ($f.Count -eq 0) { $f += "generic" }
  $f
}

try {
  $plats = if ($Platform) { ,$Platform } else { Detect }
  Write-Host "[living-codex] target: $ProjectRoot"
  Write-Host "[living-codex] platform(s): $($plats -join ', ')"
  foreach ($p in $plats) {
    $d = Dest $p
    if ($Uninstall) {
      if (Test-Path $d) { Remove-Item -Recurse -Force $d; Write-Host "[living-codex] removed $d" }
    } else {
      New-Item -ItemType Directory -Force -Path $d | Out-Null
      Copy-Item -Recurse -Force (Join-Path $SkillSrc "*") $d
      Write-Host "[living-codex] installed -> $d"
    }
  }
  if (-not $Uninstall) { Write-Host "`n[living-codex] Done. Restart your agent, then: codex map . --depth L2" }
} finally {
  if ($cleanup -and (Test-Path $cleanup)) { Remove-Item -Recurse -Force $cleanup }
}
