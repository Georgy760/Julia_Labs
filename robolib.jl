function count_of_steps(r::Robot, side::HorizonSide, i)
    for _ in 1:i
        move!(r, side)
    end
end

invers(side::HorizonSide) = HorizonSide(mod(Int(side) + 2,4))

"""
mark_MoveBack!
.............
ДАНО: Робот находится в произвольной клетке ограниченного прямоугольного поля без внутренних перегородок и маркеров.
РЕЗУЛЬТАТ: Робот — в исходном положении в центре прямого креста из маркеров, расставленных вплоть до внешней рамки.
"""

function mark_MoveBack!(r::Robot)
    for side in (Nord,West,Sud,Ost)
        while isborder(r, side)==false
            move!(r,side)
            putmarker!(r)
        end

        while ismarker(r) == true
            move!(r, invers(side)) 
        end
    end
    putmarker!(r)
end 

"""
perimetr!
.............
ДАНО: Робот - в произвольной клетке поля (без внутренних перегородок и маркеров)
РЕЗУЛЬТАТ: Робот - в исходном положении, и все клетки по периметру внешней рамки промакированы
"""
function perimetr!(r::Robot)
    left = 0
    down = 0
    
    while isborder(r, West)==false
        move!(r,West)
        left +=1
    end
    while isborder(r, Sud)==false
        move!(r,Sud)
        down +=1
    end

    for side in (Nord, Ost, Sud, West)
        while isborder(r, side)==false
            move!(r,side)
            putmarker!(r)
        end
    end

    for _ in 1:down
        move!(r,Nord)
    end

    for _ in 1:left
        move!(r,Ost)
    end
end
