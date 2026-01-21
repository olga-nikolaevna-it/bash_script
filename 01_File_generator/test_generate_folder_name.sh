#!/bin/bash

generate_folder_name() {
  local letters="$1"              # Список букв для папок
  local date_suffix="_$(date +"%d%m%y")"

  # Формируем начальную строку, следуя указанному порядку букв
  result=""
  for ((i=0; i<${#letters}; i++)); do
    result+="${letters:i:1}"
  done

  # Проверяем запрет на обратную запись (только если возможен риск обратной записи)
  reversed="$(rev <<<$letters)"
  if [[ "$result" == "$reversed" && ${#letters} -ge 2 ]]; then
    # Добавляем произвольный символ из исходных букв, чтобы предотвратить обратную запись
    result+="${letters:0:1}"
  fi

  # Добавляем случайные символы, если длина менее 4 символов
  while [[ ${#result} -lt 4 ]]; do
    char=${letters:$((RANDOM % ${#letters})):1}
    result+="$char"
  done

  # Возвращаем итоговую строку с датой
  echo "$result$date_suffix"
}
# ---- Тест-кейсы -----
# Ручные:
# Пример ручного запуска
echo "Результат для abcd:"
generate_folder_name "abcd"

echo "Результат для az:"
generate_folder_name "az"

echo "Результат для ntr:"
generate_folder_name "ntr"

# # 1. Базовый случай с коротким списком букв
# test_case_1="abc"
# expected_output_pattern="^[abc]{4}_[0-9]{6}$"
# output=$(generate_folder_name "$test_case_1")
# if [[ "$output" =~ $expected_output_pattern ]]; then
#   echo "Test case 1 passed!"
# else
#   echo "Test case 1 failed. Output was: '$output'"
# fi

# # 2. Короткий список букв, меньше 4 символов
# test_case_2="ab"
# expected_output_pattern="^[ab]{4}_[0-9]{6}$"
# output=$(generate_folder_name "$test_case_2")
# if [[ "$output" =~ $expected_output_pattern ]]; then
#   echo "Test case 2 passed!"
# else
#   echo "Test case 2 failed. Output was: '$output'"
# fi

# # Тестовый случай №3 (исправленный тест)
# test_case_3="abcd"
# expected_output_pattern="^(?!dcba)[abcd]{4,}_[0-9]{6}$"
# output=$(generate_folder_name "$test_case_3")
# if [[ "$output" =~ $expected_output_pattern ]]; then
#   echo "Test case 3 passed!"
# else
#   echo "Test case 3 failed. Output was: '$output'"
# fi

# # 4. Длинный список букв
# test_case_4="abcdefg"
# expected_output_pattern="^[abcdefg]{4}[abcdefg]*_[0-9]{6}$"
# output=$(generate_folder_name "$test_case_4")
# if [[ "$output" =~ $expected_output_pattern ]]; then
#   echo "Test case 4 passed!"
# else
#   echo "Test case 4 failed. Output was: '$output'"
# fi

# # 5. Буквы одинаковой длины
# test_case_5="aaaaaa"
# expected_output_pattern="^a{4}a*_[0-9]{6}$"
# output=$(generate_folder_name "$test_case_5")
# if [[ "$output" =~ $expected_output_pattern ]]; then
#   echo "Test case 5 passed!"
# else
#   echo "Test case 5 failed. Output was: '$output'"
# fi