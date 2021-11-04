# Export-Office365LicenseStatus

Office 365 ユーザーのライセンス付与状況をエクスポートできます。

> :exclamation: Export-Microsoft65LicenseStatus (Microsoft Graph 版) をお探しの場合は, [こちら](READMEs.md) をご参照ください。

## ダウンロード方法

[release](https://github.com/microsoft/Export-Microsoft365LicenseStatus/releases/tag/v1.0) ページから Export-Office365LicenseStatus をダウンロードしてください。

## 実行方法

1. Export-Office365LicenseStatus をダウンロードして、実行端末に保存します。
2. Windows PowerShell を起動して、ファイルを保存したフォルダーへ移動します。
3. すべてのユーザーの情報をエクスポートしたい場合は、以下のようにコマンドを実行します。

  ~~~powershell
.\Export-Office365LicenseStatus.ps1 -All $true
  ~~~

4. 特定のユーザーの情報をエクスポートしたい場合は、以下のようにコマンドを実行します。

  ~~~powershell
.\Export-Office365LicenseStatus.ps1 -UserPrincipalName User01@contoso.onmicrosoft.com
  ~~~

5. CSV ファイルにエクスポートしたい場合は、CsvOutputPath パラメーターを使用します。

  ~~~powershell
.\Export-Office365LicenseStatus.ps1 -UserPrincipalName User01@contoso.onmicrosoft.com -CsvOutputPath C:\temp\exporttest.csv
  ~~~

## 前提条件

PowerShell の Azure AD モジュール (MSOnline) が実行端末にインストールされている必要があります。詳細は[こちら](https://docs.microsoft.com/en-us/powershell/module/msonline/?view=azureadps-1.0)のページをご参照ください。

## 構文

```
.\Export-LicenseStatus.ps1 -UserPrincipalName <String> [-CsvOutputPath <String>] [-ExportNoLicenseUser] [-Force] [<CommonParameters>]
```

```
.\Export-LicenseStatus.ps1 -All <Boolean> [-CsvOutputPath <String>] [-ExportNoLicenseUser] [-Force] [<CommonParameters>]
```

## フィードバック

スクリプトに関するフィードバックは [Issues](https://github.com/Microsoft/Export-Office365LicenseStatus/issues) に投稿してください。日本語でも構いません。

本プロジェクトへの参加に関しては、[英語版 README の Contributing セクション](https://github.com/Microsoft/Export-Office365LicenseStatus/#contributing)をご参照ください。