#CПИСОК ЗАДАЧ ДЛЯ САМОСТОЯТЕЛЬНОГО РЕШЕНИЯ 2
# https://github.com/Vibof/ProgrammingManual/blob/master/lecture-2/%D0%A1%D0%BF%D0%B8%D1%81%D0%BE%D0%BA-%D0%B7%D0%B0%D0%B4%D0%B0%D1%87-2.md

#Задача 6 - practice2.jl
#Задача 7 - practice2.jl
#Задача 8 - practice2.jl
#Задача 9 - practice2.jl

using HorizonSideRobots

include("robolib.jl") #библиотека с вспомогательными функциями

#УТВ: Робот - в произвольной клетке ограниченного прямоугольного поля

function mark_innerrectangle_perimetr!(r::Robot)
    num_steps=fill(0,3) # - вектор-столбец из 3-х нулей
    for (i,side::HorizonSide) in enumerate((Sud,West,Sud))
        num_steps[i]=moves!(r,side)
    end
    #УТВ: Робот - в Юго-западном углу внешней рамки

    side = find_border!(r,Ost,side)
    #УТВ: Робот - у западной границы внутренней перегородки

    mark_innerrectangle_perimetr!(r,side)
    #УТВ: Робот - снова у западной границы внутренней прямоугольной перегородки

    moves!(r,Sud)
    moves!(r,West)
    #УТВ: Робот - в Юго-западном улу внешней рамки

    for (i,side) in enumerate((Nord,Ost,Nord))
        movements!(r,side, num_steps[i])
    end
    #УТВ: Робот - в исходном положении
end

function mark_innerrectangle_perimetr!(r::Robot, side::HorizonSide)

    direction_of_movement, direction_to_border = get_directions(side)

    for i ∈ 1:4   
        # надо ставить маркеры вдоль очередной стороны внутренней перегородки 
        # (перемещаться надо в одном направлении, а следить за перегородеой в - 
        # перпендикулярном ему)
        putmarkers!(r,  direction_of_movement[i], direction_to_border[i]) 
    end
end

function get_directions(side::HorizonSide)
    if side == Nord # - обход будет по часовой стрелке      
        return (Nord,Ost,Sud, West), (Ost,Sud,West,Nord)
    else # - обход будет против часовой стрелки
        return (Sud,Ost,Nord,West), (Ost,Nord,West,Sud) 
    end
end

function putmarkers!(r::Robot, direction_of_movement::HorizonSide, direction_to_border::HorizonSide)
    while isborder(r,direction_to_border)==true
        move!(r,direction_of_movement)
    end
end