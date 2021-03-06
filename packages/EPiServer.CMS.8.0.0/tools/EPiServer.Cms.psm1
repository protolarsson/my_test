
Function CopyDB($toolsPath, $sitePath, $dbName)
{
	$mdfFile = join-path $toolsPath  "EPiServer.Cms.mdf"
	if ([System.IO.File]::Exists([System.IO.Path]::Combine($sitePath, "App_Data", $dbName)) -eq $false)
	{
		CreateFolder $sitePath "App_Data"
		[void][System.IO.File]::Copy($mdfFile, [System.IO.Path]::Combine($sitePath, "App_Data", $dbName))
	}
}

Function CreateFolder($sitePath, $foldername)
{
	if ([System.IO.File]::Exists([System.IO.Path]::Combine($sitePath, $foldername)) -eq $false)
	{
		[void][System.IO.Directory]::CreateDirectory([System.IO.Path]::Combine($sitePath, $foldername))
	}
}

Function GetEPiDeployPath($installPath, $project)
{
	$frameWorkToolPath = GetPackagesToolPath $installPath $project "EPiServer.Framework"
	$dpeployEXEPath =  join-Path ($frameWorkToolPath) "epideploy.exe"
	return $dpeployEXEPath
}

Function GetEPiServerConnectionString($WebConfigFile)
{
	if (Test-Path $WebConfigFile) 
	{
		$webConfig = [XML] (Get-Content $WebConfigFile)
		if ($webConfig.configuration.connectionStrings.add -ne $null)
		{
			return FindEpiServerConnection($webConfig.configuration.connectionStrings.add)
		}
		if ($webConfig.connectionStrings.add -ne  $null) 
		{
			return FindEpiServerConnection($webConfig.connectionStrings.add)
		}
		if ($webConfig.configuration.connectionStrings.configSource -ne $null) 
		{
			if ([System.IO.Path]::IsPathRooted($webConfig.configuration.connectionStrings.configSource))
			{
				return GetEPiServerConnectionString($webConfig.configuration.connectionStrings.configSource)
			}
			else
			{
				return GetEPiServerConnectionString (Join-path  ([System.IO.Path]::GetDirectoryName($WebConfigFile))  $webConfig.configuration.connectionStrings.configSource)
			}
		}
	}
	return $null
}

Function FindEpiServerConnection($addElements)
{
	foreach($connString in $addElements)
	{
		if ($connString.name -eq 'EPiServerDB')
		{
			return $connString
		}
	}
	return $null
}

Function GetWebConfigPath($sitePath)
{
	$webConfigPath = join-path $sitePath "web.config"
	$appConfigPath = join-path $sitePath "app.config"
	if (Test-Path $webConfigPath) 
	{
		$configPath = $webConfigPath
	}
	elseif (Test-Path $appConfigPath)
	{
		$configPath = $appConfigPath
	}
	else 
	{
		Write-Host "Unable to find a configuration file."
		return
	}
	return $configPath
}

Function GetConnectionConfigPath($sitePath)
{
	$connectionsStringsPath = join-path $sitePath "connectionStrings.config"
	$webConfigPath = join-path $sitePath "web.config"
	if (Test-Path $connectionsStringsPath) 
	{
		$configPath = $connectionsStringsPath
	}
	elseif (Test-Path $webConfigPath)
	{
		$configPath = $webConfigPath
	}
	else 
	{
		Write-Host "Unable to find a Connection configuration file."
		return
	}
	return $configPath
}

Function GetPackagesToolPath($installPath, $project, $packageName)
{
	$thePackage = Get-package -ProjectName $project.ProjectName | where-object { $_.id -eq $packageName} | Sort-Object -Property Version -Descending | select-object -first 1
	$thePackageToolPath =[System.IO.Path]::Combine($installPath,  ".." , $thePackage.Id + "." + $thePackage.Version , "tools")
	return $thePackageToolPath
}