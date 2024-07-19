# Define the path to the Chrome bookmarks file
$chromeBookmarksPath = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Bookmarks"

# Check if the bookmarks file exists
if (Test-Path -Path $chromeBookmarksPath) {
    # Read the content of the bookmarks file
    $bookmarksContent = Get-Content -Path $chromeBookmarksPath -Raw | ConvertFrom-Json

    # Function to recursively extract bookmarks
    function Get-Bookmarks {
        param (
            [Parameter(Mandatory = $true)]
            [object]$bookmarkNode
        )

        # If the node contains children, iterate through them
        if ($bookmarkNode.children) {
            foreach ($child in $bookmarkNode.children) {
                Get-Bookmarks -bookmarkNode $child
            }
        }

        # If the node is a bookmark, output its properties
        if ($bookmarkNode.type -eq 'url') {
            [PSCustomObject]@{
                Name = $bookmarkNode.name
                URL  = $bookmarkNode.url
            }
        }
    }

    # Extract all bookmarks starting from the root
    $bookmarks = Get-Bookmarks -bookmarkNode $bookmarksContent.roots

    if ($bookmarks) {
        # Display the bookmarks
        $bookmarks | Format-Table -AutoSize
    } else {
        Write-Output "No bookmarks found."
    }
} else {
    Write-Output "Chrome bookmarks file not found."
}