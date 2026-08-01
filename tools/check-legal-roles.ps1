$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$checks = @(
    @{ File = 'offer.html'; Pattern = 'data-legal-role="provider"'; Message = 'Offer provider role is missing.' },
    @{ File = 'offer.html'; Pattern = 'data-legal-role="project-contact"'; Message = 'Offer project contact role is missing.' },
    @{ File = 'privacy.html'; Pattern = 'data-legal-role="data-operator"'; Message = 'Data operator role is missing.' },
    @{ File = 'privacy.html'; Pattern = 'data-legal-role="operator-agent"'; Message = 'Operator agent role is missing.' },
    @{ File = 'confidentiality.html'; Pattern = 'data-legal-role="site-owner"'; Message = 'Site owner role is missing.' },
    @{ File = 'confidentiality.html'; Pattern = 'data-legal-role="provider"'; Message = 'Confidentiality provider role is missing.' },
    @{ File = 'index.html'; Pattern = 'name="name"'; Message = 'Name field contract is missing.' },
    @{ File = 'index.html'; Pattern = 'name="contact"'; Message = 'Contact field contract is missing.' },
    @{ File = 'index.html'; Pattern = 'name="email"'; Message = 'Email field contract is missing.' },
    @{ File = 'index.html'; Pattern = 'name="service"'; Message = 'Service field contract is missing.' },
    @{ File = 'index.html'; Pattern = 'name="comment"'; Message = 'Comment field contract is missing.' },
    @{ File = 'index.html'; Pattern = 'id="fconsent"[^>]*name="consent"[^>]*required'; Message = 'Required consent is missing.' },
    @{ File = 'index.html'; Pattern = 'for="fconsent"'; Message = 'Consent label is missing.' },
    @{ File = 'index.html'; Pattern = 'form\.checkValidity\(\)'; Message = 'Form validity guard is missing.' }
)

$errors = @()
foreach ($check in $checks) {
    $path = Join-Path $repoRoot $check.File
    $content = Get-Content -Raw -Encoding UTF8 -LiteralPath $path
    if ($content -notmatch $check.Pattern) {
        $errors += $check.Message
    }
}

if ($errors.Count -gt 0) {
    $errors | ForEach-Object { Write-Error $_ -ErrorAction Continue }
    exit 1
}

Write-Output 'Legal roles and consent audit passed.'
