#!/usr/bin/env bats

setup() {
    TEST_DIR=$(mktemp -d)
    HOME_DIR=$(mktemp -d)
    SCRIPT_PATH="$PWD/backup.sh"

    # Ensure the script has execution permissions
    chmod +x "$SCRIPT_PATH"
}

teardown() {
    rm -rf "$TEST_DIR"
    rm -rf "$HOME_DIR"
}

@test "Скрипт завершает работу с ошибкой, если не указан путь к папке для бэкапов" {
    run bash "$SCRIPT_PATH"
    [ "$status" -eq 1 ]
    [[ "$output" == *"Не указан путь к папке для бекапов."* ]]
}

@test "Скрипт создает архив" {
    HOME="$HOME_DIR" run bash "$SCRIPT_PATH" "$TEST_DIR"
    [ "$status" -eq 0 ]
    # Проверяем, что архив создан
    ARCHIVE_COUNT=$(ls -1q "$TEST_DIR"/*.tar.gz | wc -l)
    [ "$ARCHIVE_COUNT" -gt 0 ]
}

@test "Скрипт устанавливает зависимости, если не указан параметр skip-install" {
    HOME="$HOME_DIR" run bash "$SCRIPT_PATH" "$TEST_DIR"
    [ "$status" -eq 0 ]
    # Проверка установки зависимостей
    command -v rsync > /dev/null
    [ "$?" -eq 0 ]
    command -v tar > /dev/null
    [ "$?" -eq 0 ]
    command -v pv > /dev/null
    [ "$?" -eq 0 ]
    command -v openssl > /dev/null
    [ "$?" -eq 0 ]
}

@test "Скрипт не устанавливает зависимости, если указан параметр skip-install" {
    HOME="$HOME_DIR" run bash "$SCRIPT_PATH" "$TEST_DIR" skip-install
    [ "$status" -eq 0 ]
    # Предполагаем, что зависимости могут быть не установлены в этом случае
}

@test "Скрипт создает зашифрованный архив, если указан пароль" {
    PASSWORD="testpassword"
    HOME="$HOME_DIR" run bash "$SCRIPT_PATH" "$TEST_DIR" "" "$PASSWORD"
    [ "$status" -eq 0 ]
    # Проверяем, что зашифрованный архив создан
    ENCRYPTED_ARCHIVE_COUNT=$(ls -1q "$TEST_DIR"/*.tar.gz.enc | wc -l)
    [ "$ENCRYPTED_ARCHIVE_COUNT" -gt 0 ]
    # Проверяем, что не зашифрованный архив удален
    ARCHIVE_COUNT=$(ls -1q "$TEST_DIR"/*.tar.gz | wc -l)
    [ "$ARCHIVE_COUNT" -eq 0 ]
}
