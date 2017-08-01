#param([string]$Path, [string]$Tenant, [string]$CertThumbprint, [string]$InfraSiteUrl, [string]$BuildVersion, [string]$Release, [string]$Filter)


$Path = "$(System.DefaultWorkingDirectory)\PnP Partner Pack\drop\Tmp"
$Tenant = "$(tenant)"
$CertThumbprint = "$(appOnlyCertificateThumbprint)"
$InfraSiteUrl = "$(infrastructureSiteUrl)"
$BuildVersion = "$(Build.BuildNumber)"
$Release = "$(Release.ReleaseName)"
$Filter = ""

# Set which file ending to include in the replace
if($Filter -eq $null -or $Filter -eq ""){
    Write-Host("Files to replace not defined, using default files")
    $Filter = ('app.config','web.config')
}

function ReplaceTokenInFile($file){
    
    Write-Host("Replacing token in file: " + $file.fullname)

    (Get-Content $file.fullname) -replace '{{tenant}}', $Tenant `
                                 -replace '{{appOnlyCertificateThumbprint}}', $CertThumbprint `
                                 -replace '{{infrastructureSiteUrl}}', $InfraSiteUrl `
                                 -replace '{{BuildVersion}}', $BuildVersion `
                                 -replace '{{Release}}', $Release `
                                 | Set-Content $file.fullname

}

# Get all files in path
Write-Host("Getting all files from " + $Path + ", using the filter: " + $Filter)

Get-ChildItem $Path -Recurse -Include $Filter |
    ForEach-Object {
        ReplaceTokenInFile($_)
    }
Write-Host("Replace token completed")