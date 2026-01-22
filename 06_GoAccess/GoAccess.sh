# Что теперь делает этот скрипт:
# Проверяет наличие GoAccess и автоматически устанавливает его, если программа не найдена.
# Дает себе права на исполнение, позволяя самостоятельно запускаться в будущем.
# Сразу запускает GoAccess с выбранным лог-файлом.
# Показывает ссылку на интерактивный отчет в браузере.
# Теперь вам достаточно просто дважды кликнуть по этому файлу или вызвать его из терминала, и всё заработает автоматически.

# Как пользоваться:
# Сохраните этот скрипт в файл, например, run_goaccess.sh.
# Выполните его без передачи аргументов, если хотите использовать лог-файл по умолчанию (/var/log/nginx/access.log), или укажите нужный лог-файл:
# bash
# Копировать
# ./run_goaccess.sh /var/log/myapp/mylog.log

#!/bin/bash

# Проверяем наличие установленного GoAccess
GOACCESS_INSTALLED=$(command -v goaccess)

if [ -z "$GOACCESS_INSTALLED" ]; then
    echo "GoAccess не обнаружен. Устанавливаю..."
    sudo apt update
    sudo apt install -y goaccess
else
    echo "GoAccess уже установлен."
fi

# Добавляем право на исполнение текущего скрипта
chmod +x "$0"

# Проверяем наличие аргументов командной строки
if [ $# -eq 0 ]; then
    LOG_FILE="/var/log/nginx/access.log"
    echo "Выполнено без аргументов. Используется лог-файл по умолчанию: /var/log/nginx/access.log"
    echo "Чтобы задать другой лог-файл, воспользуйтесь следующей командой:"
    echo "./run_goaccess.sh /var/log/myapp/mylog.log"
else
    LOG_FILE=$1
    echo "Используется лог-файл: $LOG_FILE"
fi

# Функция вывода статуса
show_status() {
    echo ""
    echo "GoAccess запущен по адресу:"
    echo "http://localhost:7890/"
    echo ""
    echo "Нажмите Ctrl+C для остановки скрипта."
}

# Очищаем экран
clear

# Проверяем существование файла логов
if [ ! -f "$LOG_FILE" ]; then
    echo "Ошибка: Файл логов не найден или неправильный путь!"
    exit 1
fi

# Запускаем GoAccess с необходимыми параметрами
goaccess \
    --log-format=COMBINED \
    --real-time-html \
    --ignore-crawlers \
    "$LOG_FILE" &

PID=$!

# Показываем статус и ждём завершения процесса
show_status
wait $PID

exit 0