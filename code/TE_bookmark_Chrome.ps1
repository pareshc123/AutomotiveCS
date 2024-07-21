# Function to check if Google Chrome is installed
function Test-ChromeExistence {
    $chromePath = "C:\Program Files\Google\Chrome\Application\chrome.exe"
    if (Test-Path $chromePath) {
        Write-Output "Google Chrome is installed."
        return $true
    } else {
        Write-Output "Google Chrome is not installed."
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

# Function to prompt user for uninstallation of Chrome
function Uninstall-Chrome {
    $userInput = Read-Host "Do you want to uninstall Google Chrome? (Yes/No)"
    if ($userInput -eq "Yes") {
        Write-Output "Uninstalling Google Chrome..."
        Start-Process "appwiz.cpl"
        Write-Output "Please find and uninstall Google Chrome from the Control Panel."
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
