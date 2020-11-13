# 1 - ф-ия {инверсия направления}
invers(side::HorizonSide) = HorizonSide(mod(Int(side) + 2,4))

# 2 - ф-ия {возвращение на num_steps шагов}
function movements!(r::Robot,side::HorizonSide,num_steps::Int)
    for _ in 1:num_steps
        move!(r,side)
    end
end

# 3 - ф-ия {запоминаем кол-во шагов в направлении side}
function get_num_steps_movements!(r::Robot, side::HorizonSide)
    num_steps = 0
    while isborder(r, side) == false #пока нет стенки идем в направлении side\запоминаем кол-во шагов\маркеруем их
        putmarker!(r)
        move!(r,side)
        num_steps += 1
    end
    if (isborder(r,side) == true)
        putmarker!(r)
    end
    return num_steps
end
# 4 - ф-ия {идем в направлении side до стенки}
function movements!(r::Robot,side::HorizonSide)
    while isborder(r,side) == false
        move!(r,side)
    end
end

# 5 - ф-ия {идем в направлении side до стенки и запоминаем шаги}
function moves!(r::Robot,side::HorizonSide)
    num_steps=0
    while isborder(r,side)==false
        move!(r,side)
        num_steps+=1
    end
    return num_steps
end

# 6 - ф-ия {Дойти до стороны, двигаясь змейкой вверх-вниз и вернуть последнее перед остановкой направление}
function find_border!(r::Robot, direction_to_border::HorizonSide, direction_of_movement::HorizonSide)
    while isborder(r,direction_to_border)==false  
        if isborder(r,direction_of_movement)==false
            move!(r,direction_of_movement)
        else
            move!(r,direction_to_border)
            direction_of_movement=inverse(direction_of_movement)
        end
    end
    #УТВ: непосредственно справа от Робота - внутренняя пергородка
end

# 7 - ф-ия {движение змейкой с простановкой маркеров}
function snake!(r::Robot,side::HorizonSide) 
    while isborder(r,side) == false #пока нет стенки идем в сторону side и ставим маркеры
        putmarker!(r)
        move!(r,side)
    end

    if (isborder(r,Nord) == false)#Передвигаемся на одну строчку вверх
        putmarker!(r)
        move!(r,Nord)
        side = invers(side::HorizonSide)
        mark_row!(r,side)
    end
end

# 8 - ф-ия 
function mark_row!(r::Robot,side::HorizonSide)
    while isborder(r,side) == false #пока нет стенки идем в сторону side и ставим маркеры
        putmarker!(r)
        move!(r,side)
    end
    if (isborder(r,Nord) == false)#Передвигаемся на одну строчку вверх
        putmarker!(r)
        move!(r,Nord)
        side = invers(side::HorizonSide)
        mark_row!(r,side)
    end
end

# 9 - ф-ия {движение до стенки с простановкой маркеров}
function putmarkers_until_border!(r::Robot, side::HorizonSide)
    while isborder(r,side)==false
        move!(r,side)
        putmarker!(r)
    end
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