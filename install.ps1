# Living Codex installer (Windows) — copies the cartographer skill into your AI agent.
# Usage:  .\install.ps1            (auto-detect)
#         .\install.ps1 kiro       (force platform)
#         .\install.ps1 -Uninstall kiro
param(
  [string]$Platform = "",
  [switch]$Uninstall
)
$ErrorActionPreference = "Stop"
$ScriptDir   = Split-Path -Parent $MyInvocation.MyCommand.Path
$SkillSrc    = Join-Path $ScriptDir "skill"
$ProjectRoot = if ($env:LIVING_CODEX_TARGET) { $env:LIVING_CODEX_TARGET } else { (Get-Location).Path }
$SkillName   = "cartographer"

if (-not (Test-Path (Join-Path $SkillSrc "SKILL.md"))) { throw "skill/ not found next to install.ps1" }

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
  if (Test-Path (Join-Path $ProjectRoot ".kiro"))   { $f += "kiro" }
  if (Test-Path (Join-Path $ProjectRoot "CLAUDE.md")){ $f += "claude" }
  if (Test-Path (Join-Path $ProjectRoot ".cursor"))  { $f += "cursor" }
  if (Test-Path (Join-Path $ProjectRoot ".agents"))  { $f += "codex" }
  if ($f.Count -eq 0) { $f += "generic" }
  $f
}

$plats = if ($Platform) { ,$Platform } else { Detect }
Write-Host "[living-codex] target: $ProjectRoot"
Write-Host "[living-codex] platforms: $($plats -join ', ')"
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
if (-not $Uninstall) {
  Write-Host "`n[living-codex] Done. Restart your agent, then: codex map . --depth L2"
}
