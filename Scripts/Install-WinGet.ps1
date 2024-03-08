Write-Host -ForegroundColor DarkGray "$((Get-Date).ToString('yyyy-MM-dd-HHmmss')) Installing WinGet"

If (Get-Command "WinGet" -ErrorAction SilentlyContinue) {
	Write-Host -ForegroundColor Green "$((Get-Date).ToString('yyyy-MM-dd-HHmmss')) WinGet is installed"
}
Else {
	If (Get-AppxPackage -Name "Microsoft.DesktopAppInstaller" -ErrorAction SilentlyContinue) {
		Write-Host -ForegroundColor DarkGray "$((Get-Date).ToString('yyyy-MM-dd-HHmmss')) Install Microsoft.DesktopAppInstaller_8wekyb3d8bbwe"
		Try {
			Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe -ErrorAction Stop
		}
		Catch {
			Write-Host -ForegroundColor Red "$((Get-Date).ToString('yyyy-MM-dd-HHmmss')) Failed to install Microsoft.DesktopAppInstaller_8wekyb3d8bbwe"
			Break
		}
	}
}

If (Get-AppxPackage -Name "Microsoft.DesktopAppInstaller" -ErrorAction SilentlyContinue | Where-Object {$_.Version -ge '1.21.2701.0'}) {
	Write-Host -ForegroundColor Green "$((Get-Date).ToString('yyyy-MM-dd-HHmmss')) The current version of WinGet is up-to-date"
}
Else {
	If (Get-Command "WinGet" -ErrorAction SilentlyContinue) {
		$WingetVersion = & winget.exe --version
		[string]$WingetVersion = $WingetVersion -Replace "[a-zA-Z\-]"
		Write-Host -ForegroundColor Yellow "$((Get-Date).ToString('yyyy-MM-dd-HHmmss')) WinGet ($WingetVersion) requires an update"
	}
	$progressPreference = "silentlyContinue"
	Write-Host -ForegroundColor DarkGray "$((Get-Date).ToString('yyyy-MM-dd-HHmmss')) Downloading Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
	Invoke-WebRequest -Uri https://aka.ms/getwinget -OutFile Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
	Write-Host -ForegroundColor DarkGray "$((Get-Date).ToString('yyyy-MM-dd-HHmmss')) Downloading Microsoft.VCLibs.x64.14.00.Desktop.appx"
	Invoke-WebRequest -Uri https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx -OutFile Microsoft.VCLibs.x64.14.00.Desktop.appx
	Write-Host -ForegroundColor DarkGray "$((Get-Date).ToString('yyyy-MM-dd-HHmmss')) Downloading Microsoft.UI.Xaml.2.8.x64.appx"
	Invoke-WebRequest -Uri https://github.com/microsoft/microsoft-ui-xaml/releases/download/v2.8.6/Microsoft.UI.Xaml.2.8.x64.appx -OutFile Microsoft.UI.Xaml.2.8.x64.appx
	Write-Host -ForegroundColor DarkGray "$((Get-Date).ToString('yyyy-MM-dd-HHmmss')) Installing WinGet and its dependencies"
	Add-AppxPackage Microsoft.VCLibs.x64.14.00.Desktop.appx
	Add-AppxPackage Microsoft.UI.Xaml.2.8.x64.appx
	Add-AppxPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
}