#скрипт предназначен для резевного копировани домашней директрории, он создает в отдельной папке коталог с копиями
#!/bin/bash

echo "для корректной работы приложения НЕ рекомендуется в использовать домашнем каталоге"

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

    create_archive
}

main
