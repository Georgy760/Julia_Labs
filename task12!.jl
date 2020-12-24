include("robot.jl")
include("robolib.jl") #библиотека с вспомогательными функциями

function task12!(r, cellSize)
    r=Robot(animate=true)
    x=0; y=0
    num_steps, _, _ = moveToLeftDownCornerAndReturnArrayOfSteps(r)
    horisontalDirection = Right
    while !(isborder(r, Up) && isborder(r, Right))
        putMarkerIfNecessary(r, x, y, cellSize)
        if isborder(r, Right) || isborder(r, Left) && !(isborder(r, Down) && isborder(r, Left))
            move!(r, Up)
            y+=1
            putMarkerIfNecessary(r, x, y, cellSize)
            horisontalDirection = inverse(horisontalDirection)
        end
        move!(r,horisontalDirection)
        (horisontalDirection == Right) ? x+=1 : x-=1
    end
    putMarkerIfNecessary(r, x, y, cellSize)
    moveToLeftDownCorner!(r)
    returnByStepsIn(r, num_steps)
end
