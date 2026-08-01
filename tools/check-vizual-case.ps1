$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$homepageHtml = Get-Content -Raw -LiteralPath (Join-Path $root 'index.html')
$casePath = Join-Path $root 'cases/vizual-real-estate/index.html'

if ($homepageHtml -notmatch 'id="cases"') { throw 'Homepage is missing #cases' }
if ($homepageHtml -notmatch 'href="#cases"') { throw 'Homepage navigation is missing #cases' }
if (-not (Test-Path -LiteralPath $casePath)) { throw 'Case page is missing' }

$case = Get-Content -Raw -LiteralPath $casePath
$required = @(
  '<html lang="ru">',
  'id="solution"',
  'id="gallery"',
  'id="case-contact"',
  'rel="noopener noreferrer"',
  'href="/#cases"'
)
foreach ($value in $required) {
  if ($case -notlike "*$value*") { throw "Case page is missing: $value" }
}

$ids = [regex]::Matches($case, 'id="([^"]+)"') | ForEach-Object { $_.Groups[1].Value }
$duplicates = $ids | Group-Object | Where-Object Count -gt 1
if ($duplicates) { throw "Duplicate IDs: $($duplicates.Name -join ', ')" }

$sitemap = Get-Content -Raw -LiteralPath (Join-Path $root 'sitemap.xml')
if ($sitemap -notmatch 'https://aiprohar.ru/cases/vizual-real-estate/') {
  throw 'Sitemap is missing the Vizual case URL'
}

Write-Host 'Vizual case audit passed.'
