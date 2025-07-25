## <script src="/dist/scripts/cli-bash.js"></script>
## <link href="https://cdnjs.cloudflare.com/ajax/libs/prism/1.16.0/themes/prism-okaidia.min.css" rel="stylesheet" />
## <script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.16.0/components/prism-core.min.js" data-manual></script>
## <script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.16.0/components/prism-powershell.min.js"></script>
## <style>body {color: #272822; background-color: #272822; font-size: 0.8em;} </style>
# Love open-source, dev-tooling and passionate about code as much as we do?
# ---
# We're always looking for awesome hackers like you to join our 100% remote team!
# Check and see if you find any relevant position @ https://appwrite.io/company/careers 👩‍💻 😎
# (and let us know you found this message...)

# This script contains hidden JS code to allow better readability and syntax highlighting
# You can use "View source" of this page to see the full script.

# REPO
$GITHUB_x64_URL = "https://github.com/appwrite/sdk-for-cli/releases/download/8.2.2/appwrite-cli-win-x64.exe"
$GITHUB_arm64_URL = "https://github.com/appwrite/sdk-for-cli/releases/download/8.2.2/appwrite-cli-win-arm64.exe"

$APPWRITE_BINARY_NAME = "appwrite.exe"

# Appwrite download directory
$APPWRITE_DOWNLOAD_DIR = Join-Path -Path $env:TEMP -ChildPath $APPWRITE_BINARY_NAME

# Appwrite CLI location
$APPWRITE_INSTALL_DIR = Join-Path -Path $env:LOCALAPPDATA -ChildPath "Appwrite"
$APPWRITE_INSTALL_PATH = Join-Path -Path "$APPWRITE_INSTALL_DIR" -ChildPath "$APPWRITE_BINARY_NAME"

$USER_PATH_ENV_VAR = [Environment]::GetEnvironmentVariable("PATH", "User")

function Greeting {
    Write-Host @"

     _                            _ _           ___   __   _____
    /_\  _ __  _ ____      ___ __(_) |_ ___    / __\ / /   \_   \
   //_\\| '_ \| '_ \ \ /\ / / '__| | __/ _ \  / /   / /     / /\/
  /  _  \ |_) | |_) \ V  V /| |  | | ||  __/ / /___/ /___/\/ /_
  \_/ \_/ .__/| .__/ \_/\_/ |_|  |_|\__\___| \____/\____/\____/
        |_|   |_|                                                

"@ -ForegroundColor red
    Write-Host "Welcome to the Appwrite CLI install shield."  
}


function CheckSystemInfo {
    Write-Host "[1/4] Getting System Info ..."
    if ((Get-ExecutionPolicy) -gt 'RemoteSigned' -or (Get-ExecutionPolicy) -eq 'ByPass') {
        Write-Host "PowerShell requires an execution policy of 'RemoteSigned'."
        Write-Host "To make this change please run:"
        Write-Host "'Set-ExecutionPolicy RemoteSigned -scope CurrentUser'"
        break
    }
}

function DownloadBinary {
    Write-Host "[2/4] Downloading Appwrite CLI binary ..."
    Write-Host "🚦 Fetching latest version ... " -ForegroundColor green

    if((Get-CimInstance Win32_operatingsystem).OSArchitecture -like '*ARM*') {
      Invoke-WebRequest -Uri $GITHUB_arm64_URL -OutFile $APPWRITE_DOWNLOAD_DIR
    } else {
      Invoke-WebRequest -Uri $GITHUB_x64_URL -OutFile $APPWRITE_DOWNLOAD_DIR
    }

    New-Item -ItemType Directory -Path $APPWRITE_INSTALL_DIR
    Move-Item $APPWRITE_DOWNLOAD_DIR $APPWRITE_INSTALL_PATH
}


function Install {
    Write-Host "[3/4] Starting installation ..."

    if ($USER_PATH_ENV_VAR -like '*Appwrite*') {
        Write-Host "Skipping to add Appwrite to User Path."
    } else {
        [System.Environment]::SetEnvironmentVariable("PATH", $USER_PATH_ENV_VAR + ";$APPWRITE_INSTALL_DIR", "User")
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User") 
    }
}

function CleanUp {
    Write-Host "Cleaning up mess ..."
}

function InstallCompleted {
    Write-Host "[4/4] Finishing Installation ... "
    cleanup
    Write-Host "To get started with Appwrite CLI, please visit https://appwrite.io/docs/command-line"
    Write-Host "As first step, you can login to your Appwrite account using 'appwrite login'"
}


Greeting
CheckSystemInfo
DownloadBinary
Install
CleanUp
InstallCompleted
