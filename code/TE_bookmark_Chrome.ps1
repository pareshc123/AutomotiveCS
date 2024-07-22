# Function to check if Google Chrome is installed
function Test-ChromeExistence {

    # Getting the google key property
    $uninstallKey = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*"
    $chromePath = Get-ItemProperty $uninstallKey | Where-Object { $_.DisplayName -like "Google Chrome*" }
    
    if (Test-Path $chromePath) {
        Write-Output "Google Chrome is installed."
        return $true
    } else {
        Write-Output "Google Chrome is not installed. Try Firefox"
        return $false
    }
}

# Function to export Chrome bookmarks to Edge
function Export-ChromeBookmarksToEdge {
    Write-Output "Exporting bookmarks from Chrome to Edge..."

    $chromeBookmarkPath = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Bookmarks"
    $edgeBookmarkPath = "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Bookmarks"

    if (Test-Path $chromeBookmarkPath) {
        Copy-Item -Path $chromeBookmarkPath -Destination $edgeBookmarkPath -Force
        Write-Output "Bookmarks exported successfully."
    } else {
        Write-Output "Chrome bookmarks not found. Ensure Chrome is installed and has bookmarks."
    }
}

# Function to open Microsoft Edge
function Open-Edge {
    Start-Process "msedge"
    Write-Output "Microsoft Edge opened."
}

# Function to uninstall Google Chrome
function Uninstall-Chrome {
    $userInput = Read-Host "Do you want to uninstall Google Chrome? (Yes/No)"
    if ($userInput -like "yes") {
        Write-Output "Uninstalling Google Chrome..."

        # Get the installer for Google Chrome from the registry
        $chromeUninstallPath = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*" | 
            Where-Object { $_.DisplayName -eq "Google Chrome" }).UninstallString

        if ($chromeUninstallPath) {
            # Run the uninstaller
            Start-Process -FilePath $chromeUninstallPath -ArgumentList "/silent /uninstall" -NoNewWindow -Wait
            Write-Output "Google Chrome has been uninstalled."
        } else {
            Write-Output "Google Chrome is not installed on this machine."
        }
    } else {
        Write-Output "Script ended without uninstalling Google Chrome."
    }
}

# Main script execution
if (Test-ChromeExistence) {
    Export-ChromeBookmarksToEdge
    Open-Edge
    Uninstall-Chrome
} else {
    Write-Output "Google Chrome is not installed. Exiting script."
}
