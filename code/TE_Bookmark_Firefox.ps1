# Function to check if Mozilla Firefox is installed
function Test-FirefoxExistence {

    $uninstallKey = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*"
    $firefoxPath = Get-ItemProperty $uninstallKey | Where-Object {$_.DisplayName -like "Mozilla Firefox"}
    
    if (Test-Path $firefoxPath) {
        Write-Output "Mozilla Firefox is installed."
        return $true
    } else {
        Write-Output "Mozilla Firefox is not installed."
        return $false
    }
}

# Function to export Firefox bookmarks to Edge
function Export-FirefoxBookmarksToEdge {
    Write-Output "Exporting bookmarks from Firefox to Edge..."
    
    $firefoxProfilePath = "$env:APPDATA\Mozilla\Firefox\Profiles"
    $firefoxBookmarkFile = Get-ChildItem -Path $firefoxProfilePath -Recurse -Include "places.sqlite" | Select-Object -First 1

    if ($firefoxBookmarkFile) {
        # Create a temporary HTML file to store the bookmarks
        $tempHtmlFile = [System.IO.Path]::GetTempFileName() + ".html"
        
        # Use sqlite3 to extract bookmarks (requires sqlite3 to be installed on the system)
        $sqlite3Path = "C:\path\to\sqlite3.exe"
        & $sqlite3Path $firefoxBookmarkFile.FullName "SELECT * FROM moz_bookmarks" > $tempHtmlFile

        # Import the bookmarks into Edge
        $edgeBookmarkPath = "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Bookmarks"
        Import-EdgeBookmarks -Path $tempHtmlFile -Destination $edgeBookmarkPath
        
        Write-Output "Bookmarks exported successfully."
        Remove-Item $tempHtmlFile
    } else {
        Write-Output "Firefox bookmarks not found. Ensure Firefox is installed and has bookmarks."
    }
}

# Function to open Microsoft Edge
function Open-Edge {
    Start-Process "msedge"
    Write-Output "Microsoft Edge opened."
}

# Function to uninstall Mozilla Firefox
function Uninstall-Firefox {
    $userInput = Read-Host "Do you want to uninstall Mozilla Firefox? (yes/no)"
    if ($userInput -like "yes") {
        Write-Output "Uninstalling Mozilla Firefox..."

        # Get the installer for Mozilla Firefox from the registry
        $firefoxUninstallPath = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*" | 
            Where-Object { $_.DisplayName -like "Mozilla Firefox" }).UninstallString

        if ($firefoxUninstallPath) {
            # Run the uninstaller
            Start-Process -FilePath $firefoxUninstallPath -ArgumentList "/S" -NoNewWindow -Wait
            Write-Output "Mozilla Firefox has been uninstalled."
        } else {
            Write-Output "Mozilla Firefox is not installed on this machine."
        }
    } else {
        Write-Output "Script ended without uninstalling Mozilla Firefox."
    }
}

# Main script execution
if (Test-FirefoxExistence) {
    Export-FirefoxBookmarksToEdge
    Open-Edge
    Uninstall-Firefox
} else {
    Write-Output "Mozilla Firefox is not installed. Exiting script."
}
