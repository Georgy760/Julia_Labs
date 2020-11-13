#CПИСОК ЗАДАЧ ДЛЯ САМОСТОЯТЕЛЬНОГО РЕШЕНИЯ 2
# https://github.com/Vibof/ProgrammingManual/blob/master/lecture-1/%D0%A1%D0%BF%D0%B8%D1%81%D0%BE%D0%BA-%D0%B7%D0%B0%D0%B4%D0%B0%D1%87-1.md

#Задача 1 - practice1.jl
#Задача 2 - practice1.jl
#Задача 3 - practice1.jl
#Задача 4 - practice1.jl
#Задача 5 - practice1.jl 

using HorizonSideRobots

include("robolib.jl") #библиотека с вспомогательными функциями

#УТВ: Робот - в произвольной клетке ограниченного прямоугольного поля

function task1!(r::Robot) #крест
    for side in (Nord,West,Sud,Ost) #перебор направлений
        num_steps=get_num_steps_movements!(r,side)
        movements!(r,invers(side),num_steps)
    end
end

function task2!(r::Robot) #периметр
    num_vert = moves!(r, Sud)
    num_hor = moves!(r, West)
    #УТВ: Робот - в Юго-Западном углу
    
    for side in [Nord, Ost, Sud, West] # движение на север -> восток -> юг -> запад
        putmarkers_until_border!(r, side) 
    end 
    #УТВ: По всему периметру стоят маркеры
    
    movements!(r, Nord, num_vert)
    movements!(r, Ost, num_hor)
    #УТВ: Робот - в исходном положении
end

function task3!(r::Robot) #заполнение всего поля маркерами
    num_vert = get_num_steps_movements!(r, Sud)
    num_hor = get_num_steps_movements!(r, West)
    #УТВ: Робот в юго-западном углу
    side = Ost
    snake!(r,side) #Идем змейкой и ставим маркеры
    putmarker!(r) #последней маркер в северном углу
    #Робот - у северной границы (в левом или правом углу)
    movements!(r,Sud)
    movements!(r, West)
    #УТВ: Робот - в Юго-Западном углу
    movements!(r,Ost,num_hor)
    movements!(r,Nord,num_vert)
    #УТВ: Робот - в исходном положении
end

function task4!(r::Robot)
    num_vert = moves!(r, Sud)
    num_hor = moves!(r, West)
    #УТВ: Робот - в Юго-Западном углу
    side = Ost #задаем начальное направление движения
    putmarker!(r)
    while ((isborder(r, Nord)) && (isborder(r, Ost))) == false #движимся пока нет стенок на сервере и на востоке
        move!(r,side)
        
        if (isborder(r, side)) == true #проверяем наличие стенки на востоке/западе для поворота
            if (isborder(r, Nord)) == false #проверяем наличии стенки на сервере
                move!(r, Nord) #делаем поворот на север
                
                side = invers(side) #инверсируем движение с сервера/юга -> юг/север
            end
        end
    end

    #УТВ: Все клетки поля промакированы
    movements!(r, West)
    movements!(r, Sud)

    #УТВ: Робот - в Юго-Западном углу
    movements!(r, Nord, num_vert)
    movements!(r, Ost, num_hor)

    #УТВ: Робот - в исходном положении
end

function task5!(r)
    num_steps = through_rectangles_into_angle(r,(Sud,West))
    # УТВ: Робот - в юго-западном углу и в num_steps - закодирован пройденный путь
    for side in (Nord,Ost,Sud,West)
        moves!(r,side) # возвращаемый результат игнорируется
        putmarker!(r)
    end
    # УТВ: Маркеры поставлены и Робот - в юго-западном углу
    move!(r,(Ost,Nord),num_steps)
    #УТВ: Робот - в исходном положении
end

"""
    through_rectangles_into_angle(r,angle::NTuple{2,HorizonSide})
-- Перемещает Робота в заданный угол, прокладывая путь межу внутренними прямоугольными перегородками и возвращает массив, содержащий числа шагов в каждом из заданных направлений на этом пути
"""
function through_rectangles_into_angle(r,angle::NTuple{2,HorizonSide})
    num_steps=[]
    while isborder(r,angle[1])==false || isborder(r,angle[2]) # Робот - не в юго-западном углу
        push!(num_steps, moves!(r, angle[2]))
        push!(num_steps, moves!(r, angle[1]))
    end
    return num_steps
end

"""
    moves!(r,sides,num_steps::Vector{Int})
-- перемещает Робота по пути, представленного двумя последовательностями, sides и num_steps 
-- sides - содержит последовательность направлений перемещений
-- num_steps - содержит последовательность чисел шагов в каждом из этих направлений, соответственно; при этом, если длина последовательности sides меньше длины последовательности num_steps, то предполагается, что последовательность sides должна быть продолжена периодически       
"""
function moves!(r,sides,num_steps::Vector{Int})
    for (i,n) in enumerate(reverse!(num_steps))
        moves!(r, sides[mod(i-1, length(sides))+1], n) # - это не рекурсия (не вызов функцией самой себя), это вызов другой, ранее определенной функции
        # выражение индекса массива mod(i-1, length(sides))+1 обеспечисвает периодическое продолжение последовательности из вектора sides до длины вектора num_steps 
    end
end