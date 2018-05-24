##########################################
# Deployment with dbatools.io function
# Publish-DbaDacpac
##########################################
#Get-Help Publish-DbaDacpac -Detailed

Clear-Host

# Get the supplied parameters
$SourcePath = "x:\!SQL\!Moje\2018-05 SQLDay2018\module4\db"
$TargetServer = "localhost\SQL2016"
$TargetDatabase = "StackOverflow"
$ProjectName = "StackOverflow"
$UseIntegratedSecurity = $true;
$Username = ""
$Password = ""
[Switch]$Report = $true
[Switch]$Script = $true
[Switch]$Deploy = $false

$SourcePath = $SourcePath + "\" + $ProjectName
$PublishProfile = Join-Path $SourcePath "\Localhost.$ProjectName.publish.xml"
$DACPACPackageName = Join-Path $SourcePath "bin\Release"
$DACPACPackageName = Join-Path $DACPACPackageName "$ProjectName.dacpac"


#Deploy (only)
Publish-DbaDacpac -Verbose -SqlInstance $TargetServer -Database $TargetDatabase -Path $DACPACPackageName -PublishXml $PublishProfile `



#Script + Report
$ScriptOnly = $true;
Publish-DbaDacpac -Verbose -SqlInstance $TargetServer -Database $TargetDatabase -Path $DACPACPackageName -PublishXml $PublishProfile `
    -GenerateDeploymentScript:$Script -GenerateDeploymentReport:$Report -ScriptOnly:$ScriptOnly



#Script + Output Directory
[Switch]$Report = $false
[Switch]$Script = $true
[Switch]$Deploy = $false
$ScriptOnly = $true;
$OutputPath = Join-Path $SourcePath ".."
Publish-DbaDacpac -Verbose -SqlInstance $TargetServer -Database $TargetDatabase -Path $DACPACPackageName -PublishXml $PublishProfile `
    -GenerateDeploymentScript:$Script -GenerateDeploymentReport:$Report -ScriptOnly:$ScriptOnly `
    -OutputPath $OutputPath -EnableException:$true





#HELP
# Get-Help Publish-DbaDacpac -Detailed
