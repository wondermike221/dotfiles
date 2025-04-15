# Useful Vars
$HOSTS = "$env:windir\System32\drivers\etc\hosts"
$DOTSSHDIR = "$env:USERPROFILE\.ssh"
$DOTCONFIGDIR = "$env:USERPROFILE\.config"
$NVIMRC = "$env:LOCALAPPDATA\nvim"

# Note Vaults
$life = "C:\Users\mhixon\Not OneDrive\life"
$work = "C:\Users\mhixon\Not OneDrive\work"

# Alias'
Set-Alias -Name n -Value nvim
Set-Alias -Name ls -Value eza

Function l {eza -lh}
Function la {eza -a}
Function lla {eza -lha}
Function lt {eza --tree --git-ignore}
Function fz {nvim $(fzf)}

Function wua {winget update --all --include-unknown --accept-source-agreements --accept-package-agreements}

# Start Starship
# Invoke-Expression (&starship init powershell)
#$ENV:STARSHIP_CONFIG = "$HOME\Documents\starship.toml"

# Start zoxide
Invoke-Expression (& { (zoxide init powershell --cmd cd | Out-String) })

# eBay specific settings
#
$TRACKING_MODULE = "C:\Users\mhixon\OneDrive - eBay Inc\Documents\repos\Tracking.psm1"
Import-Module $TRACKING_MODULE
$CPC_EMAIL_MODULE = "C:\Users\mhixon\OneDrive - eBay Inc\Documents\repos\"
# Import-Module $CPC_EMAIL_MODULE
$PEOPLEX_MODULE = "C:\Users\mhixon\OneDrive - eBay Inc\Documents\repos\peoplex_automation.psm1"
# Import-Module $PEOPLEX_MODULE
# $GET_OUTLOOK_MODULE = "C:\Users\mhixon\OneDrive - eBay Inc\Documents\repos\get_outlookinbox.psm1"
# Import-Module $GET_OUTLOOK_MODULE

# Helpers for dealing with dash a password
$APASS_FILE = "C:\Users\mhixon\OneDrive - eBay Inc\Desktop\macros\apass.txt"
function Set-apass {
	param (
		[Parameter (Mandatory = $False)]
		[string]$value = ""
	)
	if($value -eq ""){
		$value = Get-Clipboard
	}
	if($value -eq $Null){
		write-error "No value supplied by clipboard"
	}
	New-Item $APASS_FILE -ItemType File -Force -Value "$value"
}
function Get-apass {
	Get-Content $APASS_FILE 
}
#Alias for TRACKING_MODULE
function gtsfs {
	Get-TrackingStatus | Format-Table status
}

#WIP helpers for dealing with interops like automating outlook
function interop {
	param (
		[Parameter (Mandatory = $True)]
		[string]$libName
	)
	#See https://stackoverflow.com/a/73976695 for source
	$AssemblyFile = (get-childitem $env:windir\assembly -Recurse "$libName" | Select-Object -first 1).FullName
	Add-Type -Path $AssemblyFile
}

# scans the cwd for files older than the provide date
function Get-Old-Files {
	param (
		[Parameter (Mandatory = $False)]
		[string]$date = (Get-Date).addMonths(-18)
	)
	get-childitem -file -Recurse -Force | Where-Object { $_.LastWriteTime -lt $date }
}

function cascade {
$code = @"
using System;
using System.Runtime.InteropServices;

namespace Utils
{
    public class CascadeWindowsApi
    {
        [DllImport("user32.dll")]
        static extern ushort CascadeWindows(IntPtr hwndParent, uint wHow,
        IntPtr lpRect, uint cKids, IntPtr[] lpKids);

        public static void Cascade()
        {
            CascadeWindows(IntPtr.Zero, 4, IntPtr.Zero, 0, null);
        }    
    }
}
"@

  Add-Type -TypeDefinition $code -Language CSharp 
  iex "[Utils.CascadeWindowsApi]::Cascade()"
}

enum QR_Search_Dirs {
  RECEIVED
  ALL
}

function Search-CsvForName {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$Name,

        [Parameter(Mandatory=$false)]
        [string]$DirectoryPath = "C:\Users\mhixon\OneDrive - eBay Inc\Documents\_CollectPC\qr_exports\All",

        [Parameter(Mandatory=$false)]
        [switch]$StrictMatch
    )

    # Split the name into first and last for fuzzy matching
    $firstName, $lastName = $Name -split ' '

    $csvFiles = Get-ChildItem -Path $DirectoryPath -Filter *.csv

    # Loop through each CSV file
    foreach ($file in $csvFiles) {
        # Import the CSV file into a variable
        $csvData = Import-Csv -Path $file.FullName

        # Loop through each row in the CSV
        foreach ($row in $csvData) {
            if($StrictMatch) {
              if($row.Customer.ToString() -eq "$firstName $lastName".ToLower()) {
                $row
              }
            } else {
              $f_check = ($row.Customer.ToString().ToLower().Contains($firstName.ToLower()))
              $l_check = ($row.Customer.ToString().ToLower().Contains($lastName.ToLower()))
              if ($f_check -or $l_check) {
                  $row
              }
            }
        }
    }
}

function Search-Recieved-CsvForName {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory=$true)]
    [string]$Name,

    [Parameter(Mandatory=$false)]
    [switch]$StrictMatch
  )

  Search-CsvForName -Name $Name -StrictMatch:$StrictMatch -DirectoryPath "C:\Users\mhixon\OneDrive - eBay Inc\Documents\_CollectPC\qr_exports\Received-as-of\"
}

function Search-RMAS {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory=$false)]
    [string]$filePath = "C:\Users\mhixon\OneDrive - eBay Inc\Documents\_CollectPC\qr_exports\qrs.csv"
  )
  $names = (Get-Clipboard) -split "`n"
  $qr = Import-Csv $filePath
  # $received = $qr | where {$_.Status -eq "Received"}
  $qr | where {$_.Customer -in $names}
}

function Search-Received {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory=$false)]
    [string]$filePath = "C:\Users\mhixon\OneDrive - eBay Inc\Documents\_CollectPC\qr_exports\qrs.csv"
  )
  $names = (Get-Clipboard) -split "`n"
  $qr = Import-Csv $filePath
  $received = $qr | where {$_.Status -eq "Received"}
  $names | where { $_ -in $received.Customer }
}

function y {
    $tmp = [System.IO.Path]::GetTempFileName()
    yazi $args --cwd-file="$tmp"
    $cwd = Get-Content -Path $tmp
    if (-not [String]::IsNullOrEmpty($cwd) -and $cwd -ne $PWD.Path) {
        Set-Location -LiteralPath $cwd
    }
    Remove-Item -Path $tmp
}
