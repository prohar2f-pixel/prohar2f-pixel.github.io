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

$caseCss = Get-Content -Raw -LiteralPath (Join-Path $root 'assets/case-vizual.css')
$baseHeroTitleRule = [regex]::Match($caseCss, '(?s)\.cv-hero h1\s*\{(.*?)\}').Groups[1].Value
if ($baseHeroTitleRule -notmatch 'overflow-wrap:\s*anywhere') {
  throw 'Mobile case title has no safe wrapping rule'
}
if ($baseHeroTitleRule -notmatch 'font-size:\s*clamp\(3\.2rem,\s*5vw,\s*5\.5rem\)') {
  throw 'Desktop case title exceeds the safe type scale'
}
if ($caseCss -notmatch '(?s)\.cv-case-title\s*\{[^}]*font-size:\s*clamp\(2\.15rem,\s*4vw,\s*3\.8rem\)') {
  throw 'Homepage case title exceeds the safe card width'
}
if ($caseCss -notmatch 'height:\s*clamp\(') {
  throw 'Case preview has no bounded display height'
}
if ($caseCss -notmatch 'linear-gradient\(135deg,\s*#9333ea,\s*#6d28d9\)') {
  throw 'Primary case button is missing the contrast-safe gradient'
}
if ($caseCss -notmatch '(?s)@media \(max-width:\s*700px\).*?\.cv-hero h1\s*\{[^}]*font-size:\s*clamp\(2\.05rem,\s*9vw,\s*2\.55rem\)') {
  throw 'Mobile hero title is larger than the approved compact scale'
}
if ($caseCss -notmatch '(?s)\.cv-carousel--desktop \.cv-carousel-slide\s*\{[^}]*aspect-ratio:\s*16\s*/\s*10') {
  throw 'Desktop carousel is missing the 16:10 presentation viewport'
}
if ($caseCss -notmatch '(?s)\.cv-carousel--mobile \.cv-carousel-slide\s*\{[^}]*aspect-ratio:\s*375\s*/\s*812') {
  throw 'Mobile carousel is missing the phone presentation viewport'
}
if ($caseCss -notmatch '(?s)\.cv-carousel-dots button\s*\{[^}]*width:\s*32px;[^}]*height:\s*32px') {
  throw 'Carousel dots need a touch-friendly 32px hit area'
}
if (([regex]::Matches($case, 'data-carousel="')).Count -ne 2) {
  throw 'Case page must contain exactly two carousels'
}
if (([regex]::Matches($case, 'data-carousel-slide="desktop"')).Count -ne 5) {
  throw 'Desktop carousel must contain five slides'
}
if (([regex]::Matches($case, 'data-carousel-slide="mobile"')).Count -ne 4) {
  throw 'Mobile carousel must contain four slides'
}
if ($case -notmatch 'src="/assets/case-vizual-carousel.js"') {
  throw 'Case page is missing the carousel script'
}
$carouselAssets = @(
  'assets/cases/vizual/vizual-contacts.webp',
  'assets/cases/vizual/vizual-mobile-catalog.webp',
  'assets/cases/vizual/vizual-mobile-object.webp',
  'assets/cases/vizual/vizual-mobile-team.webp'
)
foreach ($asset in $carouselAssets) {
  if (-not (Test-Path -LiteralPath (Join-Path $root $asset))) {
    throw "Carousel asset is missing: $asset"
  }
}
if ($case -notmatch 'src="/assets/cases/vizual/alexander-thinking\.webp"') {
  throw 'Solution section is missing the generated thinking portrait'
}
if ($case -notmatch 'src="/assets/cases/vizual/alexander-thinking\.webp"[^>]+alt="[^\"]+"') {
  throw 'Thinking portrait is missing its meaningful alt text'
}
$carouselScript = Get-Content -Raw -LiteralPath (Join-Path $root 'assets/case-vizual-carousel.js')
foreach ($behavior in @('ArrowLeft', 'ArrowRight', 'pointerdown', 'pointerup', 'aria-current', 'aria-hidden')) {
  if ($carouselScript -notmatch [regex]::Escape($behavior)) {
    throw "Carousel behavior is missing: $behavior"
  }
}

Write-Host 'Vizual case audit passed.'
