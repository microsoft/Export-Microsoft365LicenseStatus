# Export-Microsoft365LicenseStatus

[日本語版 README はこちら](https://github.com/microsoft/Export-Microsoft365LicenseStatus/tree/master/ja-jp)

You can export license status information of Microsoft 365 users.

> :exclamation: If you are looking for Export-Office365LicenseStatus (MSOL version), please see [here](README_v1.md)

## Download option

Download Export-Microsoft365LicenseStatus from [Releases](https://github.com/microsoft/Export-Microsoft365LicenseStatus/releases) page.

## Prerequisites

- This script supports only PowerShell 7.
- You have to install the Microsoft Graph PowerShell SDK on your computer. Please refer to [this](https://docs.microsoft.com/en-us/graph/powershell/installation) page for more information.
- You need to have at least 'User.Read.All' and 'Organization.Read.All' permissions to use this script. If you want to use the delegated permissions to connect to Microsoft Graph, run the following command before running this script. You can also use the application permissions if you want.
  
  ```powershell
  Connect-MgGraph -Scopes "Organization.Read.All","User.ReadWrite.All"
  ```

## Usage

1. Download Export-Microsoft365LicenseStatus and save on your computer.
2. Start PowerShell and go to the folder where you saved the file.
3. If you want to export all users' information, run the following command.

   ```powershell
   .\Export-Microsoft365LicenseStatus.ps1 -All
   ```

4. If you want to export all users' information to a CSV file, run the following command.

   ```powershell
   .\Export-Microsoft365LicenseStatus.ps1 -All | Export-Csv c:\Temp\LicenseReport.csv
   ```

5. If you want to export the specific user's information, run the following command.

   ```powershell
   .\Export-Microsoft365LicenseStatus.ps1 -UserPrincipalName user01@contoso.onmicrosoft.com
   ```

6. If you want to export the specific user's information to a CSV file, run the following command.

   ```powershell
   .\Export-Microsoft365LicenseStatus.ps1 -UserPrincipalName user01@contoso.onmicrosoft.com | Export-Csv c:\Temp\LicenseReport.csv
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
