#!/usr/bin/env bats

setup() {
    TEST_DIR=$(mktemp -d)
    HOME_DIR=$(mktemp -d)
}

teardown() {
    rm -rf "$TEST_DIR"
    rm -rf "$HOME_DIR"
}

@test "Скрипт завершает работу с ошибкой, если не указан путь к папке для бэкапов" {
    run bash backup.sh
    [ "$status" -eq 1 ]
    [[ "$output" == *"Не указан путь к папке для бекапов."* ]]
}

@test "Скрипт создает архив" {
    HOME="$HOME_DIR" run bash backup.sh "$TEST_DIR"
    [ "$status" -eq 0 ]
    # Проверяем, что архив создан
    ARCHIVE_COUNT=$(ls -1q "$TEST_DIR"/*.tar.gz | wc -l)
    [ "$ARCHIVE_COUNT" -gt 0 ]
}
