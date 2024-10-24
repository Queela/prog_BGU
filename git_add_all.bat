@echo off
setlocal enabledelayedexpansion

xcopy "build\*" "." /e /y /i
git add .
oscript .git/hooks/v8files-extractor.os --git-precommit --use-designer --remove-orig-bin-files src

# Удаление файлов, созданных в xcopy
# Перебираем все папки в папке build
for /d %%d in (build\*) do (
    # Получаем имя папки
    set "foldername=%%~nxd"
    # Проверяем, существует ли папка в корневой директории и удаляем её
    if exist ".\!foldername!" (
        rmdir /s /q ".\!foldername!"
    )
)