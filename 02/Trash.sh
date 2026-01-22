#/bin/bash
# Беру из видео
#Отключаем проверку подключаемых файлов
#shel | chock disable-SC1019 - уточнить что это может быть

source ../01/change_file_name.sh
source ../01/generate_file.sh
source ../01/logger.sh
source ../01/output_info.sh

# $1 - Символы имен поддиректории
# $2 - символы имен файлов
# $3 - размер в мегабайтах
function party_hard() {
    #Файл логов
    local log_file
    log_file="$(pwd)/created_files.log"

    #Текущая дата
    local date
    date="$(date "+%d%m%y")" # как правильно "$(date +"%d%m%y")"
    local available_foldres_names
    available_foldres_names="$1"

    #Доступные символы имени файлов
    local available_files_names
    available_files_names="$(grep -Eo '.*\.' <<<"$2" | sed 's/\.//')"

    #Доступные символы расширения
    local extension
    extension="$(grep -Eo '\..*' <<<"$2" | sed 's\/.//' )"

    local size
    size="$(sed 's/Mb//' <<<"$3")"

    # Список путей куда можно создавать файлы
    local folders_list
    #Список количества созданных файлов в данной директории
    local folders_num
    #Список проверок создана ли данная папка нами
    local create_folders
    #Поиск путей доступных для записи
    local paths

    # Ищем все директроии где можно создать папку, в домашней директории
    paths="$(find "$HOME" -type d -writable 2>/dev/null)"
    for path in $paths; do
        folders_list+=("$path")
        folders_num+=(0)
        create_folders+=(0)
    done


}

