!include "Library.nsh"
!include "Registry.nsh"
!include "Sections.nsh"

!define INSTDIR "$PROFILE\factify_chrome"
!define RegistryKey "HKCU\Software\Google\Chrome\NativeMessagingHosts\org.factpub.factify"
!define RegistryKey_ "Software\Google\Chrome\NativeMessagingHosts\org.factpub.factify"
!define RegistryValue "$PROFILE\factify_chrome\_org.factpub.factify.win.json"

Name "Factify Chrome Host Program Installer"
OutFile "setup.exe"

; -------------------Install-------------------
InstallDir ${INSTDIR}

Page directory ; Show destination directory/
Page instfiles ; Show the files that are installed.

Section "Install"
  SetOutPath $INSTDIR

  ; Write registry key and value that are required to call native host from chrome extension.
  ; https://developer.chrome.com/extensions/nativeMessaging
  ${registry::Write} ${RegistryKey} "" "$1" "REG_SZ" $R0
  ${registry::WriteExtra} ${RegistryKey} "" ${RegistryValue} $R0

  File .\_factify.jar
  File .\_factify_launcher.bat
  File .\_org.factpub.factify.win.json
  File .\_checkJavaVer.bat

  ;FIXME: Error when it runs saying - not valid Win 32 Application.
  ;WriteUninstaller ${INSTDIR}\uninstaller.exe

  ;---------------Java Version Check 1.8+---------------
  ExecWait '"$INSTDIR\_checkJavaVer.bat"'

SectionEnd

; -------------------Uninstall-------------------
UninstPage uninstConfirm ; Confirm uninstallation
UninstPage instfiles ; Show uninstalled files

Section "Uninstall"
  Delete $INSTDIR\_factify.jar
  Delete $INSTDIR\_factify_launcher.bat
  Delete $INSTDIR\_org.factpub.factify.win.json
  Delete $INSTDIR\uninstaller.exe
  RMDir $INSTDIR
  DeleteRegKey HKCU ${RegistryKey_}
SectionEnd
