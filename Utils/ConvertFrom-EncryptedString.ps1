<#
.SYNOPSIS
    Decrypt the given string with either the given key or default Windows Data Protection API (DPAPI).

.DESCRIPTION
    Decrypt the given string with either the given key or default Windows Data Protection API (DPAPI).

    File-Name:  ConvertFrom-EncryptedString.ps1
    Author:     David Wettstein
    Version:    v1.0.0

    Changelog:
                v1.0.0, 2018-09-05, David Wettstein: First implementation.

.NOTES
    Copyright (c) 2018 David Wettstein,
    licensed under the MIT License (https://dwettstein.mit-license.org/)

.LINK
    https://github.com/dwettstein/PowerShell

.EXAMPLE
    .\ConvertFrom-EncryptedString.ps1 -String "Encrypted String"

.EXAMPLE
    .\ConvertFrom-EncryptedString.ps1 -String "Encrypted String" -Key "changeme0123456789"

.EXAMPLE
    [String] $FILE_DIR = Split-Path -Parent $MyInvocation.MyCommand.Definition
    $PlainTextString = & "$FILE_DIR\Utils\ConvertFrom-EncryptedString.ps1" -string "Encrypted String" -key "changeme0123456789"
#>
[CmdletBinding()]
[OutputType([SecureString])]
Param (
    [Parameter(Mandatory=$true, ValueFromPipeline=$true, Position=0)]
    [String] $String  # secure string or plain text (not recommended)
    ,
    [Parameter(Mandatory=$false, Position=1)]
    [String] $Key = $null  # secure string or plain text (not recommended)
)

$ErrorActionPreference = 'Stop'
$WarningPreference = 'SilentlyContinue'

function Get-PlainText($Text, $KeyInBytes = $null) {
    # If text is given as SecureString string, convert it to plain text.
    try {
        $InputSecureString = ConvertTo-SecureString -String $Text -Key $KeyInBytes
        $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($InputSecureString)
        $Text = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
        $null = [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($BSTR)
    } catch {
        # The text was already given as plain text.
    }
    $Text
}

function Get-KeyInBytes($Text) {
    $Length = $Text.Length
    $Pad = 32 - $Length
    if ($Length -lt 16 -or $Length -gt 32) {
        throw "The key must be between 16 and 32 characters long in plain text!"
    }
    [System.Text.Encoding]::UTF8.GetBytes($KeyPlainText + "0" * $Pad)
}

$KeyInBytes = $null
if (-not [String]::IsNullOrEmpty($Key)) {
    $KeyPlainText = Get-PlainText -Text $Key
    $KeyInBytes = Get-KeyInBytes -Text $KeyPlainText
}

Get-PlainText -Text $String -KeyInBytes $KeyInBytes
