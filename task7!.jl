include("robot.jl")
include("robolib.jl") #библиотека с вспомогательными функциями

function task7!(r) #шахматы
    r=Robot(animate=true)
    num_steps=[]
    isMarked = true
    num_steps, x, y= moveToLeftDownCornerAndReturnArrayOfSteps(r)
    isMarked = !(isodd(x+y))
    #змейкой проставляем маркеры до правого верхнего угла
    horisontalDirection = Right
    while !(isborder(r, Up) && isborder(r, Right))
        if (isMarked)
            putmarker!(r)
        end
        if isborder(r, Right) || isborder(r, Left) && !(isborder(r, Down) && isborder(r, Left))
            move!(r, Up)
            isMarked = !isMarked
            if (isMarked)
                putmarker!(r)
            end
            horisontalDirection = inverse(horisontalDirection)
        end
        move!(r,horisontalDirection)
        isMarked = !isMarked
    end
    if isMarked
        putmarker!(r)
    end
    moveToLeftDownCorner!(r)
    returnByStepsIn(r, num_steps)

end
