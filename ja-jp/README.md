# Export-Microsoft365LicenseStatus

Microsoft 365 ユーザーのライセンス付与状況をエクスポートできます。

> :exclamation: Export-Office365LicenseStatus (MSOL 版) をお探しの場合は, [こちら](README_v1.md)をご参照ください。

## ダウンロード方法

[release](https://github.com/microsoft/Export-Microsoft365LicenseStatus/releases) ページから Export-Microsoft365LicenseStatus をダウンロードしてください。

## 前提条件

- このスクリプトは PowerShell 7 のみをサポートしています。
- Microsoft Graph PowerShell SDK が実行端末にインストールされている必要があります。詳細は[こちら](https://docs.microsoft.com/ja-jp/graph/powershell/installation)のページをご参照ください。
- このスクリプトを実行するには少なくとも 'User.Read.All' と 'Organization.Read.All' のアクセス許可が必要です。委任されたアクセス許可を使用して Microsoft Graph に接続する場合は、このスクリプトを実行する前に以下のコマンドを実行してください。必要に応じてアプリケーションのアクセス許可を使用することもできます。
  
  ```powershell
  Connect-MgGraph -Scopes "Organization.Read.All","User.ReadWrite.All"
  ```

## 実行方法

1. Export-Microsoft365LicenseStatus をダウンロードして、実行端末に保存します。
2. PowerShell を起動して、ファイルを保存したフォルダーへ移動します。
3. すべてのユーザーの情報をエクスポートしたい場合は、以下のようにコマンドを実行します。

   ```powershell
   .\Export-Microsoft365LicenseStatus.ps1 -All
   ```

4. すべてのユーザーの情報を CSV ファイルにエクスポートしたい場合は、以下のようにコマンドを実行します。

   ```powershell
   .\Export-Microsoft365LicenseStatus.ps1 -All | Export-Csv c:\Temp\LicenseReport.csv -Encoding ([System.Text.Encoding]::GetEncoding(932))
   ```
   
5. 特定のユーザーの情報をエクスポートしたい場合は、以下のようにコマンドを実行します。

   ```powershell
   .\Export-Microsoft365LicenseStatus.ps1 -UserPrincipalName user01@contoso.onmicrosoft.com
   ```

6. 特定のユーザーの情報を CSV ファイルにエクスポートしたい場合は、以下のようにコマンドを実行します。

   ```powershell
   .\Export-Microsoft365LicenseStatus.ps1 -UserPrincipalName user01@contoso.onmicrosoft.com | Export-Csv c:\Temp\LicenseReport.csv -Encoding ([System.Text.Encoding]::GetEncoding(932))
   ```

## フィードバック

スクリプトに関するフィードバックは [Issues](https://github.com/Microsoft/Export-Office365LicenseStatus/issues) に投稿してください。日本語でも構いません。

本プロジェクトへの参加に関しては、[英語版 README の Contributing セクション](https://github.com/Microsoft/Export-Office365LicenseStatus/#contributing)をご参照ください。