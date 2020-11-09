#CПИСОК ЗАДАЧ ДЛЯ САМОСТОЯТЕЛЬНОГО РЕШЕНИЯ 2
# https://github.com/Vibof/ProgrammingManual/blob/master/lecture-1/%D0%A1%D0%BF%D0%B8%D1%81%D0%BE%D0%BA-%D0%B7%D0%B0%D0%B4%D0%B0%D1%87-1.md

#Задача 1 - practice1.jl
#Задача 2 - practice1.jl
#Задача 3 - practice1.jl
#Задача 4 - practice1.jl
#Задача 5 - practice1.jl 


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

function task5!(r::Robot)
    
end
