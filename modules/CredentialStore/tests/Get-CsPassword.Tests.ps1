[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingConvertToSecureStringWithPlainText", "")]
param()

. "$PSScriptRoot\..\src\Initialize-CsStore.ps1"
. "$PSScriptRoot\..\src\Get-CsPassword.ps1"
. "$PSScriptRoot\..\src\Get-CsEntry.ps1"

Describe Get-CsPassword {
    $filePath = $(New-TemporaryFile).FullName
    Remove-Item $filePath
    Initialize-CsStore $filePath

    $content = Get-Content -Raw -Path $filePath | ConvertFrom-Json
    $content.Credentials += @{
        Name     = "User1"
        Username = "user1"
        Password = $("pass1" | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString)
    }
    $content.Credentials += @{
        Name     = "User2"
        Username = "user2"
        Password = $("pass2" | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString)
    }
    $content | ConvertTo-Json | Out-File -FilePath $filePath

    Context "Get a single Password" {
        $result = Get-CsPassword -Name User1 -FilePath $filePath
        $decrypted = (New-Object PSCredential 'N/A', $result).GetNetworkCredential().Password

        It "should get a single Password" {
            $decrypted | Should Be "pass1"
        }
    }

    Context "Get a single raw Password" {
        $result = Get-CsPassword -Name User1 -Raw -FilePath $filePath

        It "should get a single Password" {
            $result | Should Be "pass1"
        }
    }

    Context "Entry does not exist" {
        It "should throw a exception" {
            { Get-CsPassword -Name unknown -FilePath $filePath} | Should Throw "Cannot find any entry with entry name 'unknown'."
        }
    }

    Context "CredentialStore file does not exist" {
        It "should throw a validation exception" {
            { Get-CsPassword -Name User1 -FilePath unknown.json } | Should Throw "The path 'unknown.json' does not exist."
        }
    }

    Remove-Item $filePath
}