$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$homeHtml = Get-Content -Raw -LiteralPath (Join-Path $root 'index.html')

foreach ($pattern in @(
  '(?s)@media\(max-width:768px\).*?\.hero-content\s*\{[^}]*order:\s*1',
  '(?s)@media\(max-width:768px\).*?\.hero-photo\s*\{[^}]*order:\s*2',
  '#cookieBanner\.is-visible\s*\{\s*display:flex',
  '(?s)@media\(max-width:600px\).*?#cookieBanner\s*\{[^}]*right:\s*12px[^}]*left:\s*12px',
  'class="cookie-ok"',
  'document\.body\.classList\.add\(''cookie-visible''\)'
)) {
  if ($homeHtml -notmatch $pattern) {
    throw "Mobile UX contract is missing: $pattern"
  }
}

Write-Host 'Mobile UX audit passed.'
