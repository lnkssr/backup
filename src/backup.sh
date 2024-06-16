#!/bin/bash

# Скрипт предназначен для резервного копирования домашней директории, он создает в отдельной папке архив с копиями
# тест зеркала репозитория 
echo "Для корректной работы приложения НЕ рекомендуется использовать домашний каталог"

if [ -z "$1" ]; then
    echo "Не указан путь к папке для бекапов."
    echo "Использование: $0 <путь_к_папке_для_бекапов>"
    exit 1
fi

BACKUP_DIR="$1"
SKIP_DEPENDENCIES_INSTALLATION="$2"

install_dependencies() {
    echo "Установка зависимостей..."

    if command -v apt-get &> /dev/null; then
        sudo apt-get update
        sudo apt-get install -y rsync tar pv
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y rsync tar pv
    elif command -v pacman &> /dev/null; then
        sudo pacman -Sy --noconfirm rsync tar pv
    else
        echo "Не удалось определить пакетный менеджер. Установите зависимости вручную."
        exit 1
    fi
}

create_archive() {
    echo "Создание архива..."

    DATE=$(date +%Y-%m-%d_%H-%M-%S)
    ARCHIVE_NAME="backup_$DATE.tar.gz"
    ARCHIVE_PATH="$BACKUP_DIR/$ARCHIVE_NAME"

    if command -v pv &> /dev/null; then
        SIZE=$(du -sb --exclude="$HOME/.cache" --exclude="$HOME/.local/share/gajim/downloads" "$HOME" | awk '{print $1}')
        tar --exclude="$HOME/.cache" --exclude="$HOME/.local/share/gajim/downloads" -czf - -C "$HOME" . | pv -s "$SIZE" > "$ARCHIVE_PATH"
    else
        tar --exclude="$HOME/.cache" --exclude="$HOME/.local/share/gajim/downloads" -czf "$ARCHIVE_PATH" -C "$HOME" .
    fi

    if [ $? -ne 0 ]; then
        echo "Ошибка при создании архива"
        exit 1
    fi

    echo "Архив создан: $ARCHIVE_PATH"
}

main() {
    if [ "$SKIP_DEPENDENCIES_INSTALLATION" != "skip-install" ]; then
        install_dependencies
    fi
    create_archive
}

main
