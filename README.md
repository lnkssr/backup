# Скрипт для создания резервной копии домашней директории

## Описание

Данный скрипт предназначен для создания резервной копии данных из домашней директории текущего пользователя на Linux. Он выполняет копирование данных во временный каталог, а затем создание архива этих данных с использованием `tar` с возможностью отображения прогресса с помощью утилиты `pv` (Pipe Viewer), если она установлена.

## Требования

- Linux операционная система
- Установленные утилиты `rsync` (для копирования данных) и `tar` (для создания архива)
- Опционально: утилита `pv` для отображения прогресса (если установлена, будет использоваться для улучшенного пользовательского интерфейса)

## Использование

1. **Установка зависимостей:**
   - Скрипт автоматически проверяет наличие необходимых зависимостей (`rsync`, `tar`, `pv`) и, если они отсутствуют, предлагает их установить с помощью системного пакетного менеджера.

2. **Запуск скрипта:**
   - Переидите в каталог `src`
   - Выдайте права исполнения скрипта командой
     ```bash
     chmod +x backup_script
     ```
   - Запустите скрипт с указанием пути к папке, куда будет сохранена резервная копия. Например:
     ```bash
     ./backup_script.sh /path/for/backup
     ```
   - Замените `/path/for/backup` на желаемый путь для сохранения резервной копии.

3. **Процесс выполнения:**
   - Скрипт создаст временный каталог для хранения копируемых данных.
   - Данные из домашней директории пользователя будут скопированы в этот временный каталог с использованием `rsync`.
   - После копирования данные будут архивированы в `tar.gz` архив, который будет сохранен в указанной папке для бекапов.
   - В процессе архивации (если установлен `pv`), скрипт отобразит прогресс операции.
   - После успешного создания архива временный каталог будет автоматически удален.

4. **Завершение:**
   - По завершении работы скрипта проверьте указанную папку для бекапов на наличие созданного архива.

## Примечания
- **Установка зависимостей:** В случае, если необходимые зависимости (`rsync`, `tar`, `pv`) не установлены на системе, скрипт предложит установить их автоматически с помощью системного пакетного менеджера. Установка требует прав администратора (sudo).

- **Отображение прогресса:** Использование `pv` для отображения прогресса операций копирования и архивации значительно улучшает пользовательский интерфейс и позволяет лучше контролировать процесс.

- **Удаление временного каталога:** После успешного создания архива временный каталог автоматически удаляется, чтобы освободить место на диске.

- **Расположение файлов:** Для корректной работы рекомендуется переносить фаил скрипта из домашнего каталога.
   тест тест тест
## Пример использования

```bash
./backup_script.sh /mnt/disk/all_system_backup

