$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
$required = @(
  'index.html', 'aeo/index.html', 'offer.html', 'privacy.html',
  'confidentiality.html', 'robots.txt', 'sitemap.xml', 'CNAME'
)
$missing = [System.Collections.Generic.List[string]]::new()

foreach ($relative in $required) {
  if (-not (Test-Path -LiteralPath (Join-Path $repoRoot $relative))) {
    $missing.Add("required: $relative")
  }
}

$htmlFiles = Get-ChildItem -LiteralPath $repoRoot -Filter '*.html' -File -Recurse |
  Where-Object { $_.FullName -notlike "$repoRoot\.git\*" }

foreach ($file in $htmlFiles) {
  $html = Get-Content -Raw -LiteralPath $file.FullName
  $matches = [regex]::Matches($html, '(?:href|src)=["'']([^"'']+)["'']')
  foreach ($match in $matches) {
    $url = $match.Groups[1].Value
    if ($url -match '^(#|https?:|mailto:|tel:|data:|javascript:)') { continue }
    $pathPart = ($url -split '[?#]', 2)[0]
    if ([string]::IsNullOrWhiteSpace($pathPart)) { continue }
    if ($pathPart.StartsWith('/')) {
      $target = Join-Path $repoRoot $pathPart.TrimStart('/')
    } else {
      $target = Join-Path $file.DirectoryName $pathPart
    }
    if ($pathPart.EndsWith('/')) { $target = Join-Path $target 'index.html' }
    if (-not (Test-Path -LiteralPath $target)) {
      $relativeFile = $file.FullName.Substring($repoRoot.Length).TrimStart('\')
      $missing.Add("$relativeFile -> $url")
    }
  }
}

if ($missing.Count -gt 0) {
  $missing | Sort-Object -Unique | ForEach-Object { Write-Host "MISSING: $_" }
  exit 1
}
Write-Host 'Local link audit passed.'
