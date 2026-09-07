<#
.SYNOPSIS
    Automated Terraform Deployment & Application Trigger Script
.DESCRIPTION
    Runs terraform fmt, init, validate, plan, and apply for the dev environment,
    triggering Azure infrastructure deployment and application provisioning on VMs.
#>

$ErrorActionPreference = "Stop"

# Set target environment path
$EnvPath = Join-Path -Path $PSScriptRoot -ChildPath "environment\dev"

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "🚀 Starting Automated Azure Infrastructure & App Deployment" -ForegroundColor Cyan
Write-Host "Target Directory: $EnvPath" -ForegroundColor Yellow
Write-Host "================================================" -ForegroundColor Cyan

# Step 1: Formatting Terraform Code
Write-Host "`n🎨 Step 1: Running 'terraform fmt -recursive'..." -ForegroundColor Green
Push-Location $PSScriptRoot
try {
    terraform fmt -recursive
} catch {
    Write-Host "⚠️ Warning: Formatting had non-fatal issues." -ForegroundColor Yellow
}
Pop-Location

# Change directory to Dev Environment
Push-Location $EnvPath

# Step 2: Initialize Terraform
Write-Host "`n📦 Step 2: Running 'terraform init'..." -ForegroundColor Green
terraform init
if ($LASTEXITCODE -ne 0) {
    Write-Error "❌ 'terraform init' failed!"
    Pop-Location
    exit $LASTEXITCODE
}

# Step 3: Validate Terraform Configuration
Write-Host "`n🔍 Step 3: Running 'terraform validate'..." -ForegroundColor Green
terraform validate
if ($LASTEXITCODE -ne 0) {
    Write-Error "❌ 'terraform validate' failed!"
    Pop-Location
    exit $LASTEXITCODE
}

# Step 4: Generate Execution Plan
Write-Host "`n📋 Step 4: Running 'terraform plan'..." -ForegroundColor Green
terraform plan -out=tfplan
if ($LASTEXITCODE -ne 0) {
    Write-Error "❌ 'terraform plan' failed!"
    Pop-Location
    exit $LASTEXITCODE
}

# Step 5: Apply Infrastructure & Trigger App Deployment
Write-Host "`n⚡ Step 5: Running 'terraform apply' (Auto-Approving)..." -ForegroundColor Green
terraform apply -auto-approve tfplan
if ($LASTEXITCODE -ne 0) {
    Write-Error "❌ 'terraform apply' failed!"
    Pop-Location
    exit $LASTEXITCODE
}

Write-Host "`n================================================" -ForegroundColor Green
Write-Host "✅ Deployment Completed Successfully!" -ForegroundColor Green
Write-Host "React App (Spoke 1) & .NET Core App (Spoke 2) provisioning triggered." -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Green

Pop-Location
