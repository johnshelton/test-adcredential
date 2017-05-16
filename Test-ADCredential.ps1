<#
=======================================================================================
File Name: Test-ADCredential.ps1
Created on: 
Created with VSCode
Version 1.0
Last Updated: 
Last Updated by: John Shelton | c: 260-410-1200 | e: john.shelton@lucky13solutions.com

Purpose: Verify if an AD Account password is valid.

Notes: 

Change Log:


=======================================================================================
#>
#
# Define Parameter(s)
#
param (
    [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [string] $UserName = $(throw "-UserName is required.")
)
#
function Test-ADCredential {
    [CmdletBinding()]
    Param
    (
        [string]$UserName,
        [string]$Password
    )
    if (!($UserName) -or !($Password)) {
        Write-Warning 'Test-ADCredential: Please specify both user name and password'
    } else {
        Add-Type -AssemblyName System.DirectoryServices.AccountManagement
        $DS = New-Object System.DirectoryServices.AccountManagement.PrincipalContext('domain')
        $DS.ValidateCredentials($UserName, $Password)
    }
}

$pass = Read-Host 'Please enter the password for $username?' -AsSecureString
$clearpass = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
    [Runtime.InteropServices.Marshal]::SecureStringToBSTR($pass))
$TestResult = Test-ADCredential $username $clearpass
$User = Get-ADUser $UserName -Properties *
IF($TestResult -eq $True){Write-Host "The password supplied for $Username was valid."}
Else{Write-Host "The password supplied for $Username was NOT valid." -ForegroundColor Red
    $User | Select-Object SamAccountName, LockedOut, PasswordLastSet, PasswordExpired, AccountExpirationDate
    }