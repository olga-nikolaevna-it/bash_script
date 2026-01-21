#!/bin/bash
#Часть 1. Генератор файлов (src/01/create_files.sh)

#_____________Вспомогательные__________________#

# Настройки логирования
LOG_FILE="/tmp/create_structure.log"

# Функция для логирования с отметкой времени
log() {
  local message="$1"
  local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
  echo "$timestamp - $message" >> "$LOG_FILE"
}

# Проверка свободного места на диске Минимальный порог свободного места (1 ГБ)
check_disk_space() {
  free_space=$(df -k / | awk '/^\// {print $4}') # Получаем свободное место на корневом разделе в килобайтах
  threshold=1048576  # 1 GB in kilobytes

  if [[ $free_space -le $threshold ]]; then
    log "Недостаточно свободного места ($(($free_space / 1024)) MB)"
    return 1
  fi
  return 0
}

# Генерация уникальных имен папок и файлов
generate_name() {
  local letters="$1"
  local is_file="$2"  # Дополнительный аргумент: true/false, чтобы различать папки и файлы
  local date_suffix="_$(date +"%d%m%y")"

  # Формируем базовую строку из заданных букв, каждый символ хотя бы один раз
  result=""
  for ((i = 0; i < ${#letters}; i++)); do
    result+="${letters:i:1}"
  done

  # Дополняем строку случайными символами из исходного набора,
  # пока длина строки не станет равна минимум четырем символам
  while [[ ${#result} -lt 4 ]]; do
    char=${letters:RANDOM % ${#letters}:1}
    result+="$char"
  done
# Проверяем запрет на обратную запись
  reversed="$(rev <<<$letters)"
  if [[ "$reversed" == "$result" ]]; then
    # Если результат оказался обратной записью, добавляем дополнительный символ
    result+="${letters:0:1}"
  fi

# Если это файл, добавляем расширение (если задано)
  if [[ "$is_file" == "true" ]]; then
    # Зафиксированное расширение (например, .txt или .jpg)
    local fixed_extension=".txt"  # Тут можно подставить любое подходящее расширение
    result="$result$fixed_extension"
  fi

  # Итоговая строка
  echo "$result$date_suffix"
}

#_______________Основные____________________#


#Работаем с параметром 1 проверяем наличие указанной папки при ее отстутствии создаем, после переходим в нее.

# Проверка и создание папки
prepare_root_dir() {
  local root_dir="$1"

  # Проверяем существование папки
  if [[ ! -d "$root_dir" ]]; then
    mkdir -p "$root_dir" || { log "Ошибка при создании папки: $root_dir"; return 1; }
    log "Создана папка: $root_dir"
  fi

  # Переходим в папку
  cd "$root_dir" || { log "Ошибка при переходе в папку: $root_dir"; return 1; }
  log "Рабочая директория установлена: $root_dir"
}

#Разбираемся со вторыми и третьими переменными создаем папки согласно параметру 2 

create_folders() {
  local base_dir="$1"          # Локальная копия абсолютного пути
  local num_folders="$2"       # Локальная копия количества папок
  local letters_folders="$3"   # Локальная копия букв для папок
  
  # Проверяем свободное место перед созданием папок
  if ! check_disk_space "/"; then
    log "Работа приостановлена из-за нехватки места на диске."
    exit 1  # Выход из всего скрипта

  fi

  # Цикл по числу папок
  for ((i=0; i<$num_folders; i++)); do
    # Генерируем уникальное имя папки
    folder_name=$(generate_name "$letters_folders") # generate_name - это отдельная функция для генерации имен и файлов и папок
    full_path="$base_dir/$folder_name"

    # Создаем папку
    mkdir -p "$full_path" || { log "Ошибка при создании папки: $full_path"; return 1; }
    
    # Записываем в лог: папка, путь, дата создания
    log "Создана папка: $full_path, дата создания: $(date '+%Y-%m-%d %H:%M:%S')"
  done

}

# Это создание файлов согласно парамету 4,5, 6

create_files() {
  local folder_path="$1"        # Полный путь к папке
  local num_files="$2"          # Количество файлов
  local file_letters="$3"       # Буквы для файлов
  local file_size_kb="$4"       # Размер файлов в КБ

  # Цикл по числу файлов
  for ((i=0; i<$num_files; i++)); do
    # Проверяем свободное место перед созданием очередного файла
    if ! check_disk_space "/"; then
      log "Работа приостановлена из-за нехватки места на диске."
      exit 1  # Выход из всего скрипта

    fi

    # Генерируем уникальное имя файла
    file_name=$(generate_name "$file_letters")
    full_file_path="$folder_path/$file_name"

    # Создаем файл заданного размера
    dd if=/dev/urandom of="$full_file_path" bs=1K count=$file_size_kb &>/dev/null ||
      { log "Ошибка при создании файла: $full_file_path"; return 1; }

    # Логируем полное описание файла
    log "Создан файл: $full_file_path, дата создания: $(date '+%Y-%m-%d %H:%M:%S'), размер: $file_size_kb KB"
  done
}

# Основная функция создания структуры
create_structure() {
  local absolute_path="$1"     # **Параметр 1** — это абсолютный путь. \Корневая директория 
  local folders_num="$2"       # **Параметр 2** — количество вложенных папок. \
  local folder_letters="$3"    # **Параметр 3** - Буквы для папок 
  local files_per_folder="$4"  # **Параметр 4** - Количество файлов в каждой папке
  local file_letters="$5"      # **Параметр 5** — Буквы для файлов и расширение
  local file_size_kb="$6"      # **Параметр 6** — размер файлов (в килобайтах, но не более 100). 


Вот это тут нужно? 
    # Проверка свободного места на диске
  if ! check_disk_space "/"; then
    log "Работа приостановлена из-за нехватки места на диске."
    exit 1  # Выход из всего скрипта

  fi
  
  # Подготовливаем корневую директорию
  prepare_root_dir "$absolute_path" || return 1

  # Создаем вложенные папки
  create_folders "$absolute_path" "$folders_num" "$folder_letters" || return 1

  # Создаем файлы в каждой папке
  find "$absolute_path" -type d -maxdepth 1 -mindepth 1 |
  while read -r folder_path; do
    create_files "$folder_path" "$files_per_folder" "$file_letters" "$file_size_kb" || return 1
  done
}

# Экспорт функций
export -f create_structure
export -f log
export -f check_disk_space
export -f generate_name
export -f prepare_root_dir
export -f create_folders
export -f create_files




задание что нужно реализовать:
#Имена папок и файлов должны состоять только из букв, указанных в параметрах, и использовать каждую из них хотя бы один раз.  
#Длина этой части имени должна быть от четырех знаков, плюс дата запуска скрипта в формате DDMMYY, отделённая нижним подчёркиванием, например: \
#**./aaaz_021121/**, **./aaazzzz_021121** 

#При этом если для имени папок или файлов были заданы символы `az`, то в названии файлов или папок не может быть обратной записи: \
#**./zaaa_021121/**, т. е. порядок указанных символов в параметре должен сохраняться.

#При запуске скрипта в месте, указанном в Параметре 1, должны быть созданы папки и файлы в них с соответствующими именами и размером.  
#Скрипт должен остановить работу, если в файловой системе (в разделе /) останется 1 Гб свободного места.  
#Запиши лог-файл с данными по всем созданным папкам и файлам (полный путь, дата создания, размер для файлов).
начало реализации 





