# Copyright (c) Microsoft. All rights reserved. 
# Licensed under the MIT license. See LICENSE.txt file in the project root for full license information. 

# Version information
# v2.0

<#
.SYNOPSIS
This is a sample script that exports license status information of Microsoft 365 users.

.DESCRIPTION
This script runs Get-MgUser and Get-MgUserLicenseDetail cmdlet to collect license information.
The output of this script is a PSCustomObject.
To export the output to a csv file, you need to use Export-Csv cmdlet.
The Microsoft Graph PowerShell SDK must be installed on your computer, and need to be connected to Microsoft Graph.
You need to have at least 'User.Read.All' and 'Organization.Read.All' permissions to use this script.
If you want to use a delegated permission to connect to Microsoft Graph, run the following command.
e.g. Connect-MgGraph -Scopes "Organization.Read.All","User.ReadWrite.All"

.PARAMETER UserPrincipalName
The UserPrincipalName of the user to be exported.

.PARAMETER All
When exporting all users' information, if this swich parameter is specified, the list of users will be obtained using "Get-MgUser -All".
If this switch parameter is not specified, the list of users will be obtained using "Get-MgUser".

.PARAMETER ExportNoLicenseUser
Switch to include non license assigned users' information.

.PARAMETER Force
Switch to suppress a confirmation when exporting all users' information.

.EXAMPLE
.\Export-Microsoft365LicenseStatus.ps1 -All

Export all users' license status information.

.EXAMPLE
.\Export-Microsoft365LicenseStatus.ps1 -All | Export-Csv c:\Temp\LicenseReport.csv

Export all users' license status information to a CSV file.

.EXAMPLE
.\Export-Microsoft365LicenseStatus.ps1 -UserPrincipalName user01@contoso.onmicrosoft.com

Export the license status information of the specific user.

.EXAMPLE
.\Export-Microsoft365LicenseStatus.ps1 -UserPrincipalName user01@contoso.onmicrosoft.com | Export-Csv c:\Temp\LicenseReport.csv

Export the license status information of the specific user to a CSV file.

.NOTES
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

.LINK
https://github.com/microsoft/Export-Microsoft365LicenseStatus
#>

[CmdletBinding()]
Param(
    [Parameter(ParameterSetName = "User", Mandatory = $true, ValueFromPipeline = $True)]
    [ValidateNotNullOrEmpty()]
    [string]
    $UserPrincipalName,

    [Parameter(ParameterSetName = "All", Mandatory = $true, ValueFromPipeline = $False)]
    [switch]
    $All,

    [Parameter(ParameterSetName = "User", Mandatory = $false, ValueFromPipeline = $False)]
    [Parameter(ParameterSetName = "All", Mandatory = $false, ValueFromPipeline = $False)]
    [Parameter(ParameterSetName = "WithoutAll", Mandatory = $false, ValueFromPipeline = $False)]
    [switch]
    $ExportNoLicenseUser,

    [Parameter(ParameterSetName = "All", Mandatory = $false, ValueFromPipeline = $False)]
    [Parameter(ParameterSetName = "WithoutAll", Mandatory = $false, ValueFromPipeline = $False)]
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
            $SkuPartNumber,

            [Parameter(Mandatory = $True, ValueFromPipeline = $False)]
            [AllowEmptyString()]
            [string]
            $ServicePlanName,

            [Parameter(Mandatory = $True, ValueFromPipeline = $False)]
            [AllowEmptyString()]
            [string]
            $ProvisioningStatus
        )

        Write-Verbose "Enter : CreateOutput"

        $Result = [PSCustomObject]@{
            UserPrincipalName  = $User.UserPrincipalName;
            DisplayName        = $User.DisplayName;
            Department         = $User.Department;
            UsageLocation      = $User.UsageLocation;
            SkuPartNumber      = $SkuPartNumber;
            ServicePlanName    = $ServicePlanName;
            ProvisioningStatus = $ProvisioningStatus
        }

        Write-Verbose "  UserPrincipalName = $($User.UserPrincipalName); SkuPartNumber = $SkuPartNumber; ServicePlanName = $ServicePlanName; ProvisioningStatus = $ProvisioningStatus"
        $Result

        Write-Verbose "Exit : CreateOutput"
    }

    function Setup () {
        Write-Verbose "Enter : Setup"

        Write-Verbose "  PSEdition : $PSEdition"
        Write-Verbose "  PSVersion : $($PSVersionTable.PSVersion)"

        if ($PSEdition -ne "Core" -or $PSVersionTable.PSVersion.Major -lt 7) {
            Write-Error "This script supports only PowerShell 7.  Please try again using PowerShell 7."
        }

        Write-Verbose "  Parameter set name is '$($PSCmdlet.ParameterSetName)'."

        if ($PSCmdlet.ParameterSetName -ne "User") {
            if ($Force -or $PSCmdlet.ShouldContinue("Do you really want to continue?", "This script runs Get-MgUser to get all users and Get-MgUserLicenseDetail for all users. It may take long time to complete, or execution may fail due to Microsoft Graph throttling.")) {
                Write-Verbose "  It was accepted to run Get-MgUser to get all users and Get-MgUserLicenseDetail to all users."
            }
            else {
                Write-Verbose "  It was not accepted to run Get-MgUser to get all users and Get-MgUserLicenseDetail to all users."
                exit
            }
        }

        # Check the connectivity
        Write-Verbose "  Setup : Execute MgContext cmdlet as a test."

        $GetMgContect = Get-Command Get-MgContext -ErrorAction SilentlyContinue

        if ($null -eq $GetMgContect) {
            Write-Error "Get-MgContext was not found. Install Microsoft Graph PowerShell and try again."
            exit
        }

        $MgContext = Get-MgContext

        if ($null -eq $MgContext) {
            Write-Verbose "  Setup : Get-MgContext cmdlet failed."

            Write-Error "You need to execute Connect-MgGraph cmdlet to connect to Microsoft Graph. Run 'Connect-MgGraph -Scopes `"Organization.Read.All`",`"User.ReadWrite.All`"' and try again."
            exit
        }

        if (
            !(
                $MgContext.Scopes.Contains("User.Read.All") -or 
                $MgContext.Scopes.Contains("User.ReadWrite.All") -or
                $MgContext.Scopes.Contains("Directory.Read.All") -or
                $MgContext.Scopes.Contains("Directory.ReadWrite.All")
            ) -or
            !(
                $MgContext.Scopes.Contains("Organization.Read.All") -or 
                $MgContext.Scopes.Contains("Organization.ReadWrite.All") -or
                $MgContext.Scopes.Contains("Directory.Read.All") -or
                $MgContext.Scopes.Contains("Directory.ReadWrite.All")
            )) {
            Write-Error "You need to have at least 'User.Read.All' and 'Organization.Read.All' permissions to use this script."
            exit
        }



        Set-Variable -Name SetupDone -Value $true -Scope 1

        Write-Verbose "Exit : Setup"
    }

    Setup
}

Process {
    if (-not $SetupDone) { Setup }

    Write-Verbose "Enter : Main method."

    $Users = @()

    if ($UserPrincipalName -ne $null -and $UserPrincipalName -ne "") {
        # Get specified user
        Write-Verbose "  Execute Get-MgUser -UserId cmdlet because UserPrincipalName parameter is specified."
        $Users = Get-MgUser -UserId $UserPrincipalName -Property Id, UserPrincipalName, DisplayName, Department, UsageLocation, AssignedLicenses
    }
    else {
        if ($All) {
            # Get all users using Get-MgUser -All
            Write-Verbose "  Execute Get-MgUser -All cmdlet because All parameter is specified."
            $Users = Get-MgUser -All -Property Id, UserPrincipalName, DisplayName, Department, UsageLocation, AssignedLicenses
        }
        else {
            # Get all users using Get-MgUser
            Write-Verbose "  Execute Get-MgUser cmdlet."
            $Users = Get-MgUser -All -Property Id, UserPrincipalName, DisplayName, Department, UsageLocation, AssignedLicenses
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

        if ($null -eq $User.AssignedLicenses -or $User.AssignedLicenses.Count -eq 0) {
            # No license is assigned to this user.
            Write-Verbose "  $($User.UserPrincipalName) has no license."

            if ($ExportNoLicenseUser) {
                Write-Verbose "  Create output object for $($User.UserPrincipalName) ."
                CreateOutput -User $User -SkuPartNumber "" -ServicePlanName "" -ProvisioningStatus ""
            }
        }
        else {
            # This user has license(s).
            Write-Verbose "  $($User.UserPrincipalName) has license(s)."

            # Get detailed license information.
            Write-Verbose "  Execute Get-MgUserLicenseDetail cmdlet."
            $LicenseDetails = Get-MgUserLicenseDetail -UserId $User.UserPrincipalName

            Write-Verbose "  Create output object for $($User.UserPrincipalName) ."

            foreach ($License in $LicenseDetails) {
                foreach ($ServiceStatus in $License.ServicePlans) {
                    CreateOutput -User $User -SkuPartNumber $License.SkuPartNumber -ServicePlanName $ServiceStatus.ServicePlanName -ProvisioningStatus $ServiceStatus.ProvisioningStatus
                }
            }
        }
    }

    Write-Verbose "Exit : Main method."
}

End {}
