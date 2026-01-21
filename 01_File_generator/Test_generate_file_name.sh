# Формируем имя

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
  while [[ ${#file_ext_result} -lt 3 ]]; do
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
  
  # Соединяем имя файла дату и расширение
  final_name="$file_name_result$date_suffix.$file_ext_result"

  # Итоговая строка с датой
  echo "$final_name"
}

# ---- Тест-кейсы -----
# Простой интерфейс для тестирования
while true; do
  echo "Введите имя файла и расширение в формате имя.расширение (например, abc.def):"
  read input_string
  if [[ -z "$input_string" ]]; then break; fi
  generated_filename=$(generate_file_name "$input_string")
  echo "Сгенерировано имя файла: $generated_filename"
done

# Ручные:
# Пример ручного запуска
# echo "Результат для abcd.as:"
# generate_file_name "abcd.as"

# echo "Результат для az.za:"
# generate_file_name "oooooooooo.ooooooooo"

# echo "Результат для ntrowreyrmcnxhddggdds.edtkiwytdsffl"
# generate_file_name "ntrowreyrmcnxhddggdds.edtkiwytdsffl"

# ---- Авто -----

# # Тестовый случай №1 (базовый): короткое имя и расширение
# test_case_1="abc.def"
# expected_output_pattern="^[abc]{4}_[0-9]{6}\.[def]{3}$"
# output=$(generate_file_name "$test_case_1")
# if [[ "$output" =~ $expected_output_pattern ]]; then
#   echo "Test case 1 passed!"
# else
#   echo "Test case 1 failed. Output was: '$output'"
# fi

# # Тестовый случай №2 (одинаковые символы)
# test_case_2="aaaa.bbb"
# expected_output_pattern="^a{4}_[0-9]{6}\.b{3}$"
# output=$(generate_file_name "$test_case_2")
# if [[ "$output" =~ $expected_output_pattern ]]; then
#   echo "Test case 2 passed!"
# else
#   echo "Test case 2 failed. Output was: '$output'"
# fi

# # Тестовый случай №3 (длинные имена и расширения)
# test_case_3="abcdefgh.ijk"
# expected_output_pattern="^[abcdefgh]{4}_[0-9]{6}\.[ijk]{3}$"
# output=$(generate_file_name "$test_case_3")
# if [[ "$output" =~ $expected_output_pattern ]]; then
#   echo "Test case 3 passed!"
# else
#   echo "Test case 3 failed. Output was: '$output'"
# fi
