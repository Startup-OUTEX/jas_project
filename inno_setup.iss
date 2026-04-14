[Setup]
; Унікальний ідентифікатор вашого застосунку.
AppId={{2A5C70DB-9C80-4D53-BA0C-52A5D5A6DBAF}
AppName=Draw A Circle — JAS Project
AppVersion=1.0.0
AppPublisher=OUTEX
DefaultDirName={autopf}\JasProject
DisableProgramGroupPage=yes
; Куди буде збережений готовий інсталятор .exe
OutputDir=.\InnoInstaller
OutputBaseFilename=JasProject_Setup
Compression=lzma
SolidCompression=yes
WizardStyle=modern

[Languages]
Name: "ukrainian"; MessagesFile: "compiler:Languages\Ukrainian.isl"
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
; Вказуємо шлях до зібраного EXE та всіх файлів (asset'и, dll тощо)
Source: "build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; Увага: Не використовуйте "Flags: ignoreversion" на системних файлах

[Icons]
; Ярлик в меню Пуск
Name: "{autoprograms}\Jas Project"; Filename: "{app}\jas_project.exe"
; Ярлик на робочому столі
Name: "{autodesktop}\Jas Project"; Filename: "{app}\jas_project.exe"; Tasks: desktopicon

[Run]
; Автоматично запустити програму після встановлення
Filename: "{app}\jas_project.exe"; Description: "{cm:LaunchProgram,Jas Project}"; Flags: nowait postinstall skipifsilent
