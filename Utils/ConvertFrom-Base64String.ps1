<#
.SYNOPSIS
    Convert the given Base64 encoded string to username and password strings (hashtable).

.DESCRIPTION
    Convert the given Base64 encoded string to username and password strings (hashtable).

    File-Name:  ConvertFrom-Base64String.ps1
    Author:     David Wettstein
    Version:    v1.0.0

    Changelog:
                v1.0.0, 2018-08-01, David Wettstein: First implementation.

.NOTES
    Copyright (c) 2018 David Wettstein,
    licensed under the MIT License (https://dwettstein.mit-license.org/)

.LINK
    https://github.com/dwettstein/PowerShell

.EXAMPLE
    .\ConvertFrom-Base64String.ps1 -String "dXNlcm5hbWU6cGFzc3dvcmQ="

.EXAMPLE
    [String] $FILE_DIR = Split-Path -Parent $MyInvocation.MyCommand.Definition
    $String = & "$FILE_DIR\Utils\ConvertFrom-Base64String.ps1" -String "dXNlcm5hbWU6cGFzc3dvcmQ="
#>
[CmdletBinding()]
[OutputType([String])]
Param (
    [Parameter(Mandatory=$true, ValueFromPipeline=$true, Position=0)]
    [String] $String
)

$ErrorActionPreference = 'Stop'
$WarningPreference = 'SilentlyContinue'

$StringInBytes = [System.Convert]::FromBase64String($String)
$StringPlainText = [System.Text.Encoding]::UTF8.GetString($StringInBytes, 0, $StringInBytes.length)
$StringPlainText
