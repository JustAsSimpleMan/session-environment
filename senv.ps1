<#
.Description
Session Environments
存储键值对 name - path，快速切换会话环境变量

Thanks for JEnv: https://github.com/FelixSelter/JEnv-for-Windows
#>

# Setup params
param (
    <#
    "senv list"                     List all registered environments.
    "senv add <name> <path>"        Adds an alias and a path(to the executable file directory) for the session environments.
    "senv remove <name>"            Removes the specified environment from the config.
    "senv use <name>"               Applies the given environment for the current shell session.
    #>
    [Parameter(Position = 0)][validateset("list", "add", "use", "remove", "getEnv")] [string]$action,

    # Displays this helpful message
    [Alias("h")]
    [Switch]$help,

    [parameter(mandatory = $false, position = 1, ValueFromRemainingArguments = $true)]$arguments
)


function Invoke-List {
    param (
        [Parameter(Mandatory = $true)][object]$config
    )

    Write-Host "All entries:"
    Write-Host ($config.senvs | Format-Table | Out-String)
}


function Invoke-Add {
    param (
        [Parameter(Mandatory = $true)][object]$config,
        [Parameter(Mandatory = $true)][string]$name,
        [Parameter(Mandatory = $true)][string]$path
    )


    # Check if name is already used
    foreach ($senv in $config.senvs) {
        if ($senv.name -eq $name) {
            Write-Output "Theres already a SEnv with the name $name. Consider using ""senv list"""
            return
        }
    }


    # Add new SEnv
    $config.senvs += [PSCustomObject]@{
        name = $name
        path = $path
    }
    Write-Output ("Successfully added the new SEnv: " + $name)
}


function Invoke-Remove {
    param (
        [Parameter(Mandatory = $true)][object]$config,
        [Parameter(Mandatory = $true)][string]$name
    )


    # Remove the SEnv
    $config.senvs = @($config.senvs | Where-Object { $_.name -ne $name })
    Write-Output 'Your SEnv was removed successfully'
}


function Invoke-Use {
    param(
        [Parameter(Mandatory = $true)][object]$config,
        [Parameter(Mandatory = $true)][string]$name
    )


    # Check if specified SEnv is avaible
    $senv = $config.senvs | Where-Object { $_.name -eq $name }
    if ($null -eq $senv) {
        Write-Host ('Theres no SEnv with name {0}, Consider using "senv list"' -f $name)
    }
    else {
        $Env:PATH = $senv.path + ";$Env:PATH"
        Write-Host ('SEnv changed to {0} for the current shell session.' -f $name)
    }
}


function Get-Env {
    param (
        [Parameter(Mandatory = $true)][object]$config,
        [Parameter(Mandatory = $true)][string]$name
    )

    # Check if specified SEnv is avaible
    $senv = $config.senvs | Where-Object { $_.name -eq $name }
    if ($null -eq $senv) {
        Write-Output "None"
    }
    else {
        Write-Output $senv.path
    }
}


#region Load the config
# Create folder if neccessary. Pipe to null to avoid created message
if (!(test-path $PSScriptRoot\data\)) {
    New-Item -ItemType Directory -Force -Path $PSScriptRoot\data\ | Out-Null
}
# Creates the config file if neccessary
if (!(test-path $PSScriptRoot\data\tenv.config.json)) {
    New-Item -type "file" -path $PSScriptRoot\data\ -name tenv.config.json | Out-Null
}
# Load the config
$config = Get-Content -Path ($PSScriptRoot + "\data\tenv.config.json") -Raw |  ConvertFrom-Json
# Initialize with empty object if config file is empty so Add-Member works
if ($null -eq $config) {
    $config = New-Object -TypeName psobject
}
# Add senvs property if it does not exist
if (!($config | Get-Member senvs)) {
    Add-Member -InputObject $config -MemberType NoteProperty -Name senvs -Value @()
}
#endregion


if ($help -and $action -eq "") {
    Write-Host '"senv list"                     List all registered environments.'
    Write-Host '"senv add <name> <path>"        Adds an alias and a path(to the executable file directory) for the session environments.'
    Write-Host '"senv remove <name>"            Removes the specified environment from the config.'
    Write-Host '"senv use <name>"               Applies the given environment for the current shell session.'
    Write-Host 'Thanks for JEnv: https://github.com/FelixSelter/JEnv-for-Windows'
}
else {

    # Call the specified command
    # Action has to be one of the following because of the validateset
    switch ( $action ) {
        list { Invoke-List $config }
        add { Invoke-Add $config @arguments }
        remove { Invoke-Remove $config @arguments }
        use { Invoke-Use $config @arguments }
        getEnv { Get-Env $config @arguments }
    }

    #region Save the config
    ConvertTo-Json $config | Out-File $PSScriptRoot\data\tenv.config.json
    #endregion
}
