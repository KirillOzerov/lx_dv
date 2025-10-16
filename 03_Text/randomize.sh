#!/bin/bash

# Файл: randomize.sh

# Обработка параметра времени задержки
delay=0.1
if [ $# -gt 0 ]; then
    delay=$1
fi

# Чтение всего ввода в массив
mapfile -t lines

# Определяем размеры ASCII-арта
height=${#lines[@]}
if [ $height -eq 0 ]; then
    exit 0
fi

# Находим максимальную ширину
width=0
for line in "${lines[@]}"; do
    line_length=${#line}
    if [ $line_length -gt $width ]; then
        width=$line_length
    fi
done

# Создаем массивы для хранения позиций и символов
positions=()
symbols=()

# Заполняем массивы позициями и символами
for ((y=0; y<height; y++)); do
    line="${lines[$y]}"
    line_length=${#line}
    for ((x=0; x<width; x++)); do
        if [ $x -lt $line_length ]; then
            char="${line:$x:1}"
        else
            char=" "
        fi
        positions+=("$x $y")
        symbols+=("$char")
    done
done

# Очищаем экран и перемещаем курсор в начало
clear

# Перемешиваем индексы
total_positions=${#positions[@]}
indices=($(seq 0 $((total_positions-1)) | shuf))

# Выводим символы в случайном порядке
for idx in "${indices[@]}"; do
    pos=(${positions[$idx]})
    x=${pos[0]}
    y=${pos[1]}
    symbol="${symbols[$idx]}"
    
    # Перемещаем курсор на позицию (x,y)
    tput cup $y $x
    echo -n "$symbol"
    
    # Задержка
    sleep $delay
done

# Перемещаем курсор в конец вывода
tput cup $((height)) 0
