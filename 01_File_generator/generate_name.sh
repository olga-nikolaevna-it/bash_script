# Формируем имя
# Универсальная функция:
generate_name() {
  local input="$1"                 # Входные данные (например, "abc" для папок или "abc.de" для файлов)
  local include_extension="$2"     # true/false, нужны ли расширение (для файлов)
  local date_suffix="_$(date +"%d%m%y")"

  # Если требуется расширение, разделяем имя и расширение
  if [[ "$include_extension" == "true" ]]; then
    IFS='.' read -ra parts <<< "$input"
    file_name_letters="${parts[0]}"  # Имя файла
    file_ext_letters="${parts[1]}"   # Расширение файла
  else
    file_name_letters="$input"       # Для папок имя совпадает с входящими данными
  fi

  # Формируем имя файла, используя каждую букву хотя бы один раз
  file_name_result=""
  for ((i=0; i<${#file_name_letters}; i++)); do
    file_name_result+="${file_name_letters:i:1}"
  done

  # Дополняем имя файла случайными символами, если длина недостаточна
  while [[ ${#file_name_result} -lt 4 ]]; do
    char=${file_name_letters:RANDOM % ${#file_name_letters}:1}
    file_name_result+="$char"
  done

  # Если включено расширение, добавляем его
  if [[ "$include_extension" == "true" ]]; then
    # Формируем расширение, используя каждую букву хотя бы один раз
    file_ext_result=""
    for ((i=0; i<${#file_ext_letters}; i++)); do
      file_ext_result+="${file_ext_letters:i:1}"
    done

    # Соединяем имя файла и расширение
    final_name="$file_name_result.$file_ext_result"
  else
    final_name="$file_name_result"
  fi

  # Итоговая строка с датой
  echo "$final_name$date_suffix"
}
# Раздельные функции:

generate_folder_name() {
  local letters="$1"           # Список букв для папок
  local date_suffix="_$(date +"%d%m%y")"

  # Формируем строку, используя каждую букву хотя бы один раз
  result=""
  for ((i=0; i<${#letters}; i++)); do
    result+="${letters:i:1}"
  done

  # Добавляем случайные символы, пока длина строки не станет минимум 4 символа
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

  # Итоговая строка с датой
  echo "$result$date_suffix"
}
generate_file_name() {
  local file_params="$1"       # Параметры для имени и расширения (например, abc.de)
  local date_suffix="_$(date +"%d%m%y")"

  # Разбираем строку на имя и расширение
  IFS='.' read -ra parts <<< "$file_params"
  file_name_letters="${parts[0]}"  # Имя файла
  file_ext_letters="${parts[1]}"   # Расширение файла

  # Генерируем имя файла, используя каждую букву хотя бы один раз
  file_name_result=""
  for ((i=0; i<${#file_name_letters}; i++)); do
    file_name_result+="${file_name_letters:i:1}"
  done

  # Генерируем расширение, используя каждую букву хотя бы один раз
  file_ext_result=""
  for ((i=0; i<${#file_ext_letters}; i++)); do
    file_ext_result+="${file_ext_letters:i:1}"
  done

  # Дополняем имя файла случайными символами, если длина недостаточна
  while [[ ${#file_name_result} -lt 4 ]]; do
    char=${file_name_letters:RANDOM % ${#file_name_letters}:1}
    file_name_result+="$char"
  done
  # Дополняем расширение файла случайными символами, если длина недостаточна
  while [[ ${#file_ext_result} -lt 4 ]]; do
    char=${file_ext_letters:RANDOM % ${#file_ext_letters}:1}
    file_ext_result+="$char"
  done
  
  # Проверяем запрет на обратную запись
  reversed="$(rev <<<$file_name_letters)"
  if [[ "$reversed" == "$file_name_result" ]]; then
    # Если результат оказался обратной записью, добавляем дополнительный символ
    file_name_result+="${file_name_letters:0:1}"
  fi
  reversed="$(rev <<<$file_ext_letters)"
  if [[ "$reversed" == "$file_ext_result" ]]; then
    # Если результат оказался обратной записью, добавляем дополнительный символ
    file_ext_result+="${file_ext_letters:0:1}"
  fi
  
  # Соединяем имя файла и расширение
  final_name="$file_name_result.$file_ext_result"

  # Итоговая строка с датой
  echo "$final_name$date_suffix"
}

generate_folder_name("abcd") — генерирует имя папки, например: abcd_021121.
generate_file_name("abc.de") — генерирует имя файла с расширением, например: abcde_021121.