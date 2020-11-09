#CПИСОК ЗАДАЧ ДЛЯ САМОСТОЯТЕЛЬНОГО РЕШЕНИЯ 2
# https://github.com/Vibof/ProgrammingManual/blob/master/lecture-1/%D0%A1%D0%BF%D0%B8%D1%81%D0%BE%D0%BA-%D0%B7%D0%B0%D0%B4%D0%B0%D1%87-1.md

#Задача 1 - example1.jl
#Задача 2 - example2.jl
#Задача 3 - practice1.jl
#Задача 4 - practice1.jl
#Задача 5 - выполнена 

#=
ДАНО: Робот - в произвольной клетке ограниченного прямоугольного поля

РЕЗУЛЬТАТ: Робот - в исходном положении, и все клетки поля промакированы
=#

#УТВ: Робот - в произвольной клетке ограниченного прямоугольного поля
#УТВ: Робот - в Юго-Западном углу
#УТВ: Все клетки поля промакированы
#УТВ: Робот - в исходном положении
#include("robolib.jl")
invers(side::HorizonSide) = HorizonSide(mod(Int(side) + 2,4))

function move_to_Sud_West!(r::Robot)
    num_vert = moves!(r, Sud)
    num_hor = moves!(r, West)
    #УТВ: Робот - в Юго-Западном углу
    side = Nord #задаем начальное направление движения
    putmarker!(r)
    while ((isborder(r, Sud)) && (isborder(r, Ost))) == false #движимся пока нет стенок на юге и на востоке
        move!(r,side)
        putmarker!(r)
        if (isborder(r, side)) == true #проверяем наличие стенки на сервере/юге для поворота
            if (isborder(r, Ost)) == false #проверяем наличии стенки на востоке
                move!(r, Ost) #делаем поворот на восток
                putmarker!(r)
                side = invers(side) #инверсируем движение с сервера/юга -> юг/север
            end
        end
    end
    #УТВ: Все клетки поля промакированы
    movements!(r, West)
    movements!(r, Nord, num_vert)
    movements!(r, Ost, num_hor)
    #УТВ: Робот - в исходном положении
end
