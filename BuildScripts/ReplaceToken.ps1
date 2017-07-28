param([string]$Path, [string]$Tenant, [string]$CertThumbprint, [string]$InfraSiteUrl, [string]$BuildVersion, [string]$Release, [string]$Filter)


# Set which file ending to enclude in the replace
if($Filter -eq $null -or $Filter -eq ""){
    Write-Host("Files to replace not defined, using default files")
    $Filter = "*.config"
}

# Get all files in path
Write-Host("Getting all files from " + $Path + ", using the filter: " + $Filter)

Get-ChildItem $Path -Recurse -Filter $Filter |
    ForEach-Object {
        ReplaceTokenInFile($_)
    }

function ReplaceTokenInFile($file){
    
    Write-Host("Replacing token in file: " + $file.name)

    (Get-Content $file.fullname) -replace '{{Office365Tenant}}', $Tenant `
                                 -replace '{{AppOnlyCertificateThumbprint}}', $CertThumbprint `
                                 -replace '{{InfrastructureSiteUrl}}', $InfraSiteUrl `
                                 -replace '{{BuildVersion}}', $BuildVersion `
                                 -replace '{{Release}}', $Release `
                                 | Set-Content $file.fullname

}