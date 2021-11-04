# Export-Office365LicenseStatus

[日本語版 README はこちら](https://github.com/Microsoft/Export-Office365LicenseStatus/tree/master/ja-jp/README_v1.md)

You can export license status information of Office 365 users.

> :exclamation: If you are looking for Export-Microsoft65LicenseStatus (Microsoft Graph version), please see [here](README.md)

## Download option

Download Export-Office365LicenseStatus from [Release](https://github.com/microsoft/Export-Microsoft365LicenseStatus/releases/tag/v1.0) page.

## Usage

1. Download Export-Office365LicenseStatus and save on your computer.
2. Start Windows PowerShell and go to the folder where you saved the file.
3. If you want to export all users' information, run the following command.

  ~~~powershell
.\Export-Office365LicenseStatus.ps1 -All $true
  ~~~

4. If you want to export the specific user's information, run the following command.

  ~~~powershell
.\Export-Office365LicenseStatus.ps1 -UserPrincipalName User01@contoso.onmicrosoft.com
  ~~~

5. If you want to export as a CSV file, use CsvOutputPath option.

  ~~~powershell
.\Export-Office365LicenseStatus.ps1 -UserPrincipalName User01@contoso.onmicrosoft.com -CsvOutputPath C:\temp\exporttest.csv
  ~~~

## Prerequisites

You have to install the Azure AD Module (MSOnline) on your computer. Please refer to [this](https://docs.microsoft.com/en-us/powershell/module/msonline/?view=azureadps-1.0) page for more information.


## Syntax

```
.\Export-LicenseStatus.ps1 -UserPrincipalName <String> [-CsvOutputPath <String>] [-ExportNoLicenseUser] [-Force] [<CommonParameters>]
```

```
.\Export-LicenseStatus.ps1 -All <Boolean> [-CsvOutputPath <String>] [-ExportNoLicenseUser] [-Force] [<CommonParameters>]
```

## Feedback

If you have any feedback, please post on the [Issues](https://github.com/Microsoft/Export-Office365LicenseStatus/issues) list.

## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.microsoft.com.

When you submit a pull request, a CLA-bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., label, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.
