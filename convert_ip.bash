#!/bin/bash

# Проверка на количество аргументов
if [[ $# -ne 1 ]]; then
  echo "Передайте ровно один аргумент"
  exit 1
fi

# Получение IP-адреса из аргумента
ip_address=$1

# Разделение IP-адреса на слова (разделитель - ".") и их запись в массив octets
declare -a octets
IFS="." read -r -a octets <<< "$ip_address"

# Проверка, что введенный IP-адрес состоит из четырех октетов
if [[ ${#octets[@]} -ne 4 ]]; then
  echo "IP-адрес должен состоять из 4х октетов"
  exit 1
fi

declare -a octets_binary
for i in "${!octets[@]}"; do
  # Проверка, что текущий октет - натуральное число
  if ! [[ ${octets[$i]} =~ ^[0-9]+$ ]]; then
    echo "Октеты должны быть натуральными числами"
    exit 1
  fi

  # Проверка, что текущий октет - число до 255
  if [[ ${octets[$i]} -ge 256 ]]; then
    echo "Октеты должны быть числами до 255"
    exit 1
  fi

  octets_binary[$i]=$(printf "%08d" "$(echo "obase=2; ${octets[$i]}" | bc)")
done


echo "${octets_binary[0]}.${octets_binary[1]}.${octets_binary[2]}.${octets_binary[3]}"



