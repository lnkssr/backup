#!/bin/bash

# Скрипт предназначен для резервного копирования домашней директории, он создает в отдельной папке каталог с копиями

echo "Для корректной работы приложения НЕ рекомендуется использовать домашний каталог"

if [ -z "$1" ]; then
    echo "Не указан путь к папке для бекапов."
    echo "Использование: $0 <путь_к_папке_для_бекапов>"
    exit 1
fi

BACKUP_DIR="$1"

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

check_disk_space() {
    echo "Проверка доступного места на диске..."

    # Проверяем доступное место на диске для папки бэкапов
    AVAILABLE_SPACE=$(df --output=avail "$BACKUP_DIR" | tail -n 1)
    REQUIRED_SPACE=$(du -sb "$HOME" | awk '{print $1}')

    # Проверяем, достаточно ли свободного места для создания архива
    if [ "$AVAILABLE_SPACE" -lt "$REQUIRED_SPACE" ]; then
        echo "Ошибка: Недостаточно свободного места на диске для создания архива."
        echo "Доступно: $AVAILABLE_SPACE байт, требуется: $REQUIRED_SPACE байт."
        exit 1
    fi
}

create_archive() {
    echo "Создание архива..."

    DATE=$(date +%Y-%m-%d_%H-%M-%S)
    ARCHIVE_NAME="backup_$DATE.tar.gz"
    ARCHIVE_PATH="$BACKUP_DIR/$ARCHIVE_NAME"

    if command -v pv &> /dev/null; then
        SIZE=$(du -sb "$HOME" | awk '{print $1}')
        tar -czf - --exclude=".cache" --exclude=".local/share/gajim/downloads" -C "$HOME" . | pv -s "$SIZE" > "$ARCHIVE_PATH"
    else
        tar -czf "$ARCHIVE_PATH" --exclude=".cache" --exclude=".local/share/gajim/downloads" -C "$HOME" .
    fi

    if [ $? -ne 0 ]; then
        echo "Ошибка при создании архива"
        exit 1
    fi

    echo "Архив создан: $ARCHIVE_PATH"
}

main() {
    install_dependencies
    check_disk_space
    create_archive
}

main

