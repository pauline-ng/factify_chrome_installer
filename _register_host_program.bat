:: Change HKCU to HKLM if you want to install globally.
:: %~dp0 is the directory containing this bat script and ends with a backslash.
REG ADD "HKCU\Software\Google\Chrome\NativeMessagingHosts\org.factpub.factify" /ve /t REG_SZ /d "%~dp0_org.factpub.factify.win.json" /f
