:: Deletes the entry created by install_host.bat
REG DELETE "HKCU\Software\Google\Chrome\NativeMessagingHosts\org.factpub.factify" /f
REG DELETE "HKLM\Software\Google\Chrome\NativeMessagingHosts\org.factpub.factify" /f
