<#
.SYNOPSIS
    Set the path to the default CredentialStore
.DESCRIPTION
    The Set-CsDefaultStore cmdlet sets the path to the default CredentialStore.
    This path is not persisted across powershell sessions.
.PARAMETER FilePath
    Specifies the path to the CredentialStore file.
.LINK
    https://github.com/fodonnel/CredentialStore
#>
function Set-CsDefaultStore {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [Alias("File")]
        [string] $FilePath
    )

    if ($pscmdlet.ShouldProcess($FilePath)) {
        $Script:DefaultCredentialStore = $FilePath
    }
}