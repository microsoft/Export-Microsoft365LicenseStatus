# Copyright (c) Microsoft. All rights reserved. 
# Licensed under the MIT license. See LICENSE.txt file in the project root for full license information. 

[CmdletBinding()]
Param(
    [Parameter(ParameterSetName = "UserCsv", Mandatory = $true, ValueFromPipeline = $True)]
    [Parameter(ParameterSetName = "UserPSObject", Mandatory = $true, ValueFromPipeline = $True)]
    [ValidateNotNullOrEmpty()]
    $UserPrincipalName,

    [Parameter(ParameterSetName = "AllCsv", Mandatory = $true, ValueFromPipeline = $False)]
    [Parameter(ParameterSetName = "AllPSObject", Mandatory = $true, ValueFromPipeline = $False)]
    [bool]
    $All,

    [Parameter(ParameterSetName = "UserCsv", Mandatory = $true, ValueFromPipeline = $False)]
    [Parameter(ParameterSetName = "AllCsv", Mandatory = $true, ValueFromPipeline = $False)]
    [ValidateNotNullOrEmpty()]
    $CsvOutputPath,

    [Parameter(ValueFromPipeline = $False)]
    [switch]
    $ExportNoLicenseUser,

    [Parameter(ValueFromPipeline = $False)]
    [switch]
    $Force
)

Begin {
    function CreateOutput {
        [CmdletBinding()]
        param
        (
            [Parameter(Mandatory = $True, ValueFromPipeline = $False)]
            [object]
            $User,

            [Parameter(Mandatory = $True, ValueFromPipeline = $False)]
            [AllowEmptyString()]
            [string]
            $AccountSkuId,

            [Parameter(Mandatory = $True, ValueFromPipeline = $False)]
            [AllowEmptyString()]
            [string]
            $ServiceName,

            [Parameter(Mandatory = $True, ValueFromPipeline = $False)]
            [AllowEmptyString()]
            [string]
            $ProvisioningStatus,

            [Parameter(Mandatory = $True, ValueFromPipeline = $False)]
            [bool]
            $CSV
        )

        Write-Verbose "Enter : CreateOutput"

        $Result = [PSCustomObject]@{UserPrincipalName = $User.UserPrincipalName; AccountSkuId = $AccountSkuId; ServiceName = $ServiceName; ProvisioningStatus = $ProvisioningStatus }
        Write-Verbose "  UserPrincipalName = $($User.UserPrincipalName); AccountSkuId = $AccountSkuId; ServiceName = $ServiceName; ProvisioningStatus = $ProvisioningStatus"

        if ($CSV) {
            Write-Verbose "  CreateOutput : Writing CSV."
            $Result | Export-Csv -Path $CsvOutputPath -Encoding Default -Append -NoTypeInformation -Force
        }
        else {
            Write-Verbose "  CreateOutput : Writing PSObject."
            $Result
        }

        Write-Verbose "Exit : CreateOutput"
    }

    function Setup () {
        Write-Verbose "Enter : Setup"

        # Check the connectivity
        Write-Verbose "  Setup : Execute Get-MsolUser Cmdlet as a test."
        Get-MsolUser -MaxResults 1 -ErrorVariable MsolError -ErrorAction SilentlyContinue | Out-Null

        if ($MsolError -ne $null) {
            Write-Verbose "  Setup : Get-MsolUser Cmdlet failed."

            # Connect to Azure Active Directory
            Write-Verbose "  Setup : Execute Connect-MsolService Cmdlet."
            Connect-MsolService -ErrorVariable MsolError

            if ($MsolError -ne $null) {
                # Could not connect to Azure Active Directory
                Write-Verbose "  Setup : Connect-MsolService Cmdlet failed."
                exit
            }
        }

        if ($CsvOutputPath -ne $null -and $CsvOutputPath -ne "") {
            # Check the output path
            Write-Verbose "  Setup : Execute New-Item Cmdlet as a test of CsvOutputPath parameter."

            if ($Force) {
                New-Item $CsvOutputPath -ItemType File -ErrorVariable FileError -Force | Out-Null
            }
            else {
                New-Item $CsvOutputPath -ItemType File -ErrorVariable FileError | Out-Null
            }
        
            if ($FileError -ne $null) {
                Write-Verbose "  Setup : New-Item Cmdlet failed."
                exit
            }

            Write-Verbose "  Setup : Output of this script will be CSV."
            Set-Variable -Name ExportToCsv -Value $true -Scope 1
        }
        else {
            Write-Verbose "  Setup : Output of this script will be PSObject."
            Set-Variable -Name ExportToCsv -Value $false -Scope 1
        }

        Set-Variable -Name SetupDone -Value $true -Scope 1

        Write-Verbose "Exit : Setup"
    }

    Setup
}

Process {
    if (-not $SetupDone) { Setup }

    Write-Verbose "Enter : Main method."

    $Users = @();

    if ($UserPrincipalName -ne $null -and $UserPrincipalName -ne "") {
        # Get specified user
        Write-Verbose "  Execute Get-MsolUser -UserPrincipalName Cmdlet because UserPrincipalName parameter is specified."
        $Users = Get-MsolUser -UserPrincipalName $UserPrincipalName
    }
    else {
        if ($All) {
            # Get all users
            Write-Verbose "  Execute Get-MsolUser -All Cmdlet because All parameter is specified."
            $Users = Get-MsolUser -All
        }
        else {
            # Get partial users
            Write-Verbose "  Execute Get-MsolUser Cmdlet."
            $Users = Get-MsolUser
        }
    }

    if ($Users.Count -eq 0) {
        # No users found
        Write-Verbose "  User not found."
        return
    }

    Write-Verbose "  $($Users.Count) user(s) found."

    foreach ($User in $Users) {
        Write-Verbose "  Working with $($User.UserPrincipalName)"
        if ($User.Licenses -eq $null -or $User.Licenses.Count -eq 0) {
            # This user is not assigned a license
            Write-Verbose "  $($User.UserPrincipalName) is not assigned a licens."

            if ($ExportNoLicenseUser) {
                Write-Verbose "  Create output object for $($User.UserPrincipalName) ."
                CreateOutput -User $User -AccountSkuId "" -ServiceName "" -ProvisioningStatus "" -CSV $ExportToCsv
            }
        }
        else {
            # This user is assigned licenses
            Write-Verbose "  $($User.UserPrincipalName) is assigned licenses."
            Write-Verbose "  Create output object for $($User.UserPrincipalName) ."

            foreach ($License in $User.Licenses) {
                foreach ($ServiceStatus in $License.ServiceStatus) {
                    CreateOutput -User $User -AccountSkuId $License.AccountSkuId -ServiceName $ServiceStatus.ServicePlan.ServiceName -ProvisioningStatus $ServiceStatus.ProvisioningStatus -CSV $ExportToCsv
                }
            }
        }
    }

    Write-Verbose "Exit : Main method."
}

End {}