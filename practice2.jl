#CПИСОК ЗАДАЧ ДЛЯ САМОСТОЯТЕЛЬНОГО РЕШЕНИЯ 2
# https://github.com/Vibof/ProgrammingManual/blob/master/lecture-2/%D0%A1%D0%BF%D0%B8%D1%81%D0%BE%D0%BA-%D0%B7%D0%B0%D0%B4%D0%B0%D1%87-2.md

#Задача 6 - practice2.jl
#Задача 7 - practice2.jl
#Задача 8 - practice2.jl
#Задача 9 - practice2.jl

using HorizonSideRobots

include("robolib.jl") #библиотека с вспомогательными функциями

invers(side::HorizonSide) = HorizonSide(mod(Int(side) + 2,4))

#УТВ: Робот - в произвольной клетке ограниченного прямоугольного поля

# Задача 6

function task6!(r::Robot)
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

# Задача 7

function task7!(r::Robot)
     num_hor = moves!(r,West)
     num_vert = moves!(r,Sud)
    #Левый нижний угол

    side = Ost
    if ((num_hor % 2) == 0) #если слево расстояние четна
        if ((num_vert % 2) == 0) # если вертикаль четна
            putmarks2!(r,side)
        else # если вертикаль нечетна
            putmarks1!(r,side)
        end
    else
        putmarks1!(r,side)
    end
    #алгоритм - выполнен

    movements!(r,West)
    movements!(r,Sud)

    movements!(r,Ost,num_hor)
    movements!(r,Nord,num_vert)
end

# Задача 9

function task9!(r)
    num_steps_max=1
    side=Nord
    while ismarker(r)==false
        for _ in 1:2
            find_marker(r,side,num_steps_max)
            side=next(side)
        end
        num_steps_max+=1
    end
end






