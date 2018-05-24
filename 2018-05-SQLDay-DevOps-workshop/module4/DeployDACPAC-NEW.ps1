<#
 .SYNOPSIS
 Converts boolean values to boolean types

 .DESCRIPTION
 Converts boolean values to boolean types

 .PARAMETER Value
 The value to convert

 .EXAMPLE
 Format-OctopusArgument "true"
#>
Function Format-OctopusArgument {

	Param(
		[string]$Value
	)

	$Value = $Value.Trim()

	# There must be a better way to do this
	Switch -Wildcard ($Value){

		"True" { Return $True }
		"False" { Return $False }
		"#{*}" { Return $null }
		Default { Return $Value }
	}
}

<#
 .SYNOPSIS
 Removes invalid file name characters

 .DESCRIPTION
 Removes invalid file name characters

 .PARAMETER FileName
 The file name to removes the invalid characters in

 .EXAMPLE
Remove-InvalidFileNameChars -FileName "Not\Allowed"
#>
Function Remove-InvalidFileNameChars {

	Param(
		[string]$FileName
	)

	[IO.Path]::GetinvalidFileNameChars() | ForEach-Object { $FileName = $FileName.Replace($_, "_") }
	Return $FileName
}

<#
 .SYNOPSIS
 Finds the DAC File that you specify

 .DESCRIPTION
 Looks through the supplied PathList array and searches for the file you specify.  It will return the first one that it finds.

 .PARAMETER FileName
 Name of the file you are looking for

 .PARAMETER PathList
 Array of Paths to search through.

 .EXAMPLE
 Find-DacFile -FileName "Microsoft.SqlServer.TransactSql.ScriptDom.dll" -PathList @("${env:ProgramFiles}\Microsoft SQL Server", "${env:ProgramFiles(x86)}\Microsoft SQL Server")
#>
Function Find-DacFile {
	Param(
		[Parameter(Mandatory=$true)]
		[string]$FileName,
		[Parameter(Mandatory=$true)]
		[string[]]$PathList
	)

	$File = $null

	ForEach($Path in $PathList)
	{
		Write-Debug ("Searching: {0}" -f $Path)

		If (!($File))
		{
			$File = (
				Get-ChildItem $Path -ErrorAction SilentlyContinue -Filter $FileName -Recurse |
				Sort-Object FullName -Descending |
				Select -First 1
				)

			If ($File)
			{
				Write-Debug ("Found: {0}" -f $File.FullName)
			}
		}
	}

	Return $File
}

<#
 .SYNOPSIS
 Adds the required types so that they can be used

 .DESCRIPTION
 Adds the DacFX types that are required to do database deploys, scripts and deployment reports from SSDT

 .EXAMPLE
 Add-DACAssemblies
#>
Function Add-DACAssemblies {

	Write-Verbose "Loading the DacFX Assemblies"

	$SearchPathList = @("${env:ProgramFiles}\Microsoft SQL Server\$TargetDatabaseVersion", "${env:ProgramFiles(x86)}\Microsoft SQL Server\$TargetDatabaseVersion")

	Write-Debug "Searching for: Microsoft.SqlServer.TransactSql.ScriptDom.dll"
	$ScriptDomDLL = (Find-DacFile -FileName "Microsoft.SqlServer.TransactSql.ScriptDom.dll" -PathList $SearchPathList)

	Write-Debug "Searching for: Microsoft.SqlServer.Dac.dll"
	$DacDLL = (Find-DacFile -FileName "Microsoft.SqlServer.Dac.dll" -PathList $SearchPathList)

	If (!($ScriptDomDLL))
	{
		Throw "Could not find the file: Microsoft.SqlServer.TransactSql.ScriptDom.dll"
	}
	If (!($DacDLL))
	{
		Throw "Could not find the file: Microsoft.SqlServer.Dac.dll"
	}

	Write-Debug ("Adding the type: {0}" -f $ScriptDomDLL.FullName)
	Add-Type -Path $ScriptDomDLL.FullName

	Write-Debug ("Adding the type: {0}" -f $DacDLL.FullName)
	Add-Type -Path $DacDLL.FullName

	Write-Host "Loaded the DAC assemblies"
}


<#
 .SYNOPSIS
 Generates a connection string

 .DESCRIPTION
 Derive a connection string from the supplied variables

 .PARAMETER ServerName
 Name of the server to connect to

 .PARAMETER Database
 Name of the database to connect to

 .PARAMETER UseIntegratedSecurity
 Boolean value to indicate if Integrated Security should be used or not

 .PARAMETER UserName
 User name to use if we are not using integrated security

 .PASSWORD Password
 Password to use if we are not using integrated security

 .PARAMETER EnableMultiSubnetFailover
 Flag as to whether we should enable multi subnet failover

 .EXAMPLE
 Get-ConnectionString -ServerName localhost -UseIntegratedSecurity -Database OctopusDeploy

 .EXAMPLE
 Get-ConnectionString -ServerName localhost -UserName sa -Password ProbablyNotSecure -Database OctopusDeploy
#>
Function Get-ConnectionString {
	Param(
		[Parameter(Mandatory=$True)]
		[string]$ServerName,
		[bool]$UseIntegratedSecurity,
		[string]$UserName,
		[string]$Password,
		[bool]$EnableMultiSubnetFailover,
		[string]$Database
	)

	$ApplicationName = "OctopusDeploy"
	$connectionString = ("Application Name={0};Server={1}" -f $ApplicationName, $ServerName)

	If ($UseIntegratedSecurity)
	{
		Write-Verbose "Using integrated security"
		$connectionString += ";Trusted_Connection=True"
	}
	Else{
		Write-Verbose "Using standard security"
		$connectionString += (";Uid={0};Pwd={1}" -f $UserName, $Password)
	}

	if ($EnableMultiSubnetFailover)
	{
		Write-Verbose "Enabling multi subnet failover"
		$connectionString += ";MultisubnetFailover=True"
	}

	If ($Database)
	{
		$connectionString += (";Initial Catalog={0}" -f $Database)
	}

	Return $connectionString
}

Function Get-SQLServerVersion {
    Param(
        [string]$serverVersion
    )
    
    $serverVersion = $serverVersion.Trim()
    
    Switch ($serverVersion){
		"100" { Return "SQL Server 2008" }
		"110" { Return "SQL Server 2012" }
		"120" { Return "SQL Server 2014" }
		"130" { Return "SQL Server 2016" }
		Default { Return $null }
    }
}

<#
 .SYNOPSIS
 Invokes the DacPac utility

 .DESCRIPTION
 Used to invoke the actions against the DacFx library.  This utility can generate deployment reports, deployment scripts and execute a deploy

 .PARAMETER Report
 Boolean flag as to whether a deploy report should be generated

 .PARAMETER Script
 Boolean flag as to whether a deployment script should be generated

 .PARAMETER Deploy
 Boolean flag as to whether a deployment should occur

 .PARAMETER DacPacFilename
 Full path as to where we can find the DacPac to use

 .PARAMETER TargetServer
 Name of the server to run the DacPac against

 .PARAMETER TargetDatabase
 Name of the database to run the DacPac against

 .PARAMETER UseIntegratedSecurity
 Flag as to whether we should use integrate security or not

 .PARAMETER EnableMultiSubnetFailover
 Flag as to whether we should enable multi subnet failover

 .PARAMETER UserName
 If we are not using integrated security, we should use this user name to connect to the server

 .PARAMETER Password
 If we are not using integrated security, we should use this password to connect to the server

 .PARAMETER PublishProfile
 Full path to the publish profile we should use

 .EXAMPLE
 Invoke-DacPacUtility

#>
Function Invoke-DacPacUtility {

	Param(
		[bool]$Report,
		[bool]$Script,
		[bool]$Deploy,
		[string]$DacPacFilename,
		[string]$TargetServer,
		[string]$TargetDatabase,
		[bool]$UseIntegratedSecurity,
		[string]$UserName,
		[string]$Password,
		[string]$PublishProfile
	)

	# We output the parameters (excluding password) so that we can see what was supplied for debuging if required.  Useful for variable scoping problems
	Write-Debug ("Invoke-DacPacUtility called.  Parameter values supplied:")
	Write-Debug ("    Dacpac Filename:                  {0}" -f $DacPacFilename)
	Write-Debug ("    Dacpac Profile:                   {0}" -f $PublishProfile)
	Write-Debug ("    Target server:                    {0}" -f $TargetServer)
	Write-Debug ("    Target database:                  {0}" -f $TargetDatabase)
	Write-Debug ("    Target database version:          {0}" -f (Get-SQLServerVersion $TargetDatabaseVersion))
	Write-Debug ("    Using integrated security:        {0}" -f $UseIntegratedSecurity)
	Write-Debug ("    Username:                         {0}" -f $UserName)
	Write-Debug ("    Report:                           {0}" -f $Report)
	Write-Debug ("    Script:                           {0}" -f $Script)
	Write-Debug ("    Deploy:                           {0}" -f $Deploy)

	$DateTime = ((Get-Date).ToUniversalTime().ToString("yyyyMMddHHmmss"))

	Add-DACAssemblies

	Try {
		$dacPac = [Microsoft.SqlServer.Dac.DacPackage]::Load($DacPacFilename)
		$connectionString = (Get-ConnectionString -ServerName $TargetServer -Database $TargetDatabase -UseIntegratedSecurity $UseIntegratedSecurity -UserName $UserName -Password $Password)
        Write-Verbose "New dac services...";
		$dacServices = New-Object Microsoft.SqlServer.Dac.DacServices -ArgumentList $connectionString

		# Load the publish profile if supplied
		Write-Verbose ("Attempting to load the publish profile: {0}" -f $PublishProfile)

		#Load the publish profile
		$dacProfile = [Microsoft.SqlServer.Dac.DacProfile]::Load($PublishProfile)
		Write-Verbose ("Loaded publish profile: {0}" -f $PublishProfile)

		# Deploy the dacpac
		If ($Deploy)
		{
			Write-Host ("Starting deployment of dacpac against server: {0}, database: {1}" -f $TargetServer, $dacProfile.TargetDatabaseName)
			Write-Host ("using profile: {0}" -f $PublishProfile)
            $options = New-Object Microsoft.SqlServer.Dac.PublishOptions;
            $options.GenerateDeploymentScript = $Script;
            $options.GenerateDeploymentReport = $Report;
            $options.DeployOptions = $dacProfile.DeployOptions;

            $result = $dacServices.Publish($dacPac, $TargetDatabase, $options);

            if ($Report)
            {
			    $reportArtifact = ("{0}\Report_{1}.xml" -f $OutputFileName, $DateTime)
                $result.DeploymentReport | Out-File $reportArtifact
                Write-Host "Output file: $reportArtifact"
            }

            if ($Script)
            {
			    $scriptArtifact = ("{0}\Script_{1}.sql" -f $OutputFileName, $DateTime)
                $result.DatabaseScript | Out-File $scriptArtifact
                Write-Host "Output file: $scriptArtifact"
            }

			Write-Host ("Dacpac deployment complete.")
		}
        else
        {
            if ($Report)
            {
			    $reportArtifact = ("{0}\Report_{1}.xml" -f $OutputFileName, $DateTime)
        	    Write-Host ("Create report for deployment of dacpac against server: {0}, database: {1}" -f $TargetServer, $dacProfile.TargetDatabaseName)
                $dacServices.GenerateDeployReport($dacPac, $TargetDatabase, $dacProfile.DeployOptions) | Out-File $reportArtifact
                Write-Host "Output file: $reportArtifact"
            }
            if ($Script)
            {
			    $scriptArtifact = ("{0}\Script_{1}.sql" -f $OutputFileName, $DateTime)
        	    Write-Host ("Create script for deployment of dacpac against server: {0}, database: {1}" -f $TargetServer, $dacProfile.TargetDatabaseName)
                $dacServices.GenerateDeployScript($dacPac, $TargetDatabase, $dacProfile.DeployOptions) | Out-File $scriptArtifact
                Write-Host "Output file: $scriptArtifact"
            }
        }
		
		Unregister-Event -SourceIdentifier "ProgressChanged"
		Unregister-Event -SourceIdentifier "Message"
	}
	Catch {
		Throw ("Deployment failed: {0} `r`nReason: {1}" -f $_.Exception.Message, $_.Exception.InnerException.Message)
	}
}

<#
.SYNOPSIS
    Determines the install location of the DACPAC package.
.DESCRIPTION
    Determines the install location of the DACPAC package.
.PARAMETER PackageStepName
    The name of the package step which installs the DACPAC.
#>
function Get-DacpacInstallPath
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true)]
        [String]$PackageStepName
    )

    try
    {
        # Attempt to retrieve the install path from the package step.
        $InstallPathKey = ("Octopus.Action[{0}].Output.Package.InstallationDirectoryPath" -f $DACPACPackageStep)
        $InstallPath = $OctopusParameters[$InstallPathKey]
        if ($InstallPath -ne $null) {
            Write-Verbose ("Install path determined from '{0}' output variables as '{1}'." -f $PackageStepName, $InstallPath)
            return $InstallPath
        }

        # Install path hasn't been found yet so try to determine the path from the parameters of the package step.
        $InstallPathCustomDirectoryKey = ("Octopus.Action[{0}].Package.CustomInstallationDirectory" -f $DACPACPackageStep)
        $InstallPath = $OctopusParameters[$InstallPathCustomDirectoryKey]
        if ($InstallPath -ne $null) {
            Write-Verbose ("Install path determined from '{0}' custom installation directory parameter as '{1}'." -f $PackageStepName, $InstallPath)
            return $InstallPath
        }

        # Install path hasn't been found yet so try to determine the path from the parameters of the package step.
        $PackageIdKey = ("Octopus.Action[{0}].Package.PackageId" -f $DACPACPackageStep)
        $PackageId = $OctopusParameters[$PackageIdKey]

        $PackageVersionKey = ("Octopus.Action[{0}].Package.PackageVersion" -f $DACPACPackageStep)
        $PackageVersion = $OctopusParameters[$PackageVersionKey]

        if ($PackageVersion -ne $null -and $PackageId -ne $null) {
            $AgentApplicationDirectoryPath = $OctopusParameters["Octopus.Tentacle.Agent.ApplicationDirectoryPath"]
            $TenantName = $OctopusParameters["Octopus.Deployment.Tenant.Name"]
            $EnvironmentName = $OctopusParameters["Octopus.Environment.Name"]

            $InstallPath = Join-Path $AgentApplicationDirectoryPath "$TenantName\$EnvironmentName\$PackageId\$PackageVersion"

            Write-Verbose ("Install path calculated using default path from '{0}' parameters as '{1}'." -f $PackageStepName, $InstallPath)
            return $InstallPath
        }

        throw "Could not determine the install location of the package."
    }
    catch
    {
        $_ | Format-List -Force | Out-String | Write-Debug;
        throw;
    }
}

# Get the supplied parameters
$DACPACPackageStep = $OctopusParameters["DACPACPackageStep"]
$DACPACPackageName = $OctopusParameters["DACPACPackageName"]
$PublishProfile = $OctopusParameters["DACPACPublishProfile"]
$Report = Format-OctopusArgument -Value $OctopusParameters["Report"]
$Script = Format-OctopusArgument -Value $OctopusParameters["Script"]
$Deploy = Format-OctopusArgument -Value $OctopusParameters["Deploy"]
$TargetServer = $OctopusParameters["TargetServer"]
$TargetDatabase = $OctopusParameters["TargetDatabase"]
$TargetDatabaseVersion = $OctopusParameters["TargetDatabaseVersion"]
$UseIntegratedSecurity = Format-OctopusArgument -Value $OctopusParameters["UseIntegratedSecurity"]
$Username = $OctopusParameters["SQLUsername"]
$Password = $OctopusParameters["SQLPassword"]

$InstallPath = Get-DacpacInstallPath -PackageStepName $DACPACPackageStep
if(!(Test-Path $InstallPath)) {
    Throw ("The package extraction folder '{0}' does not exist or the Octopus Tentacle does not have permission to access it." -f $InstallPath)
}

# Expand the publish dacpac filename
$DACPACPackageName = ($InstallPath + "\" + $DACPACPackageName)
if(!(Test-Path $DACPACPackageName)) {
    Throw ("Could not find the file '{0}'" -f $DACPACPackageName)
}

# Expand the publish profile filename if a value has been supplied
If ($PublishProfile)
{
    $PublishProfile = ($InstallPath + "\" + $PublishProfile)
    if(!(Test-Path $PublishProfile)) {
        Throw ("Could not find the file '{0}'" -f $PublishProfile)
    }
}

# Invoke the DacPac utility
try
{
    Invoke-DacPacUtility -Report $Report -Script $Script -Deploy $Deploy -DacPacFilename $DACPACPackageName -TargetServer $TargetServer -TargetDatabase $TargetDatabase -UseIntegratedSecurity $UseIntegratedSecurity -Username $Username -Password $Password -PublishProfile $PublishProfile 
}
catch
{
    $_.Exception.Message
    $_.Exception.StackTrace 
    Exit 1
}