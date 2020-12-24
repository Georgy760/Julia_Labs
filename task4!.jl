include("robot.jl")
include("robolib.jl") #библиотека с вспомогательными функциями

function task4!(r::Robot) #ступени
    r=Robot(animate=true)
    steps, _, _ = moveToLeftDownCornerAndReturnArrayOfSteps(r)
    #УТВ: Робот - в Юго-Западном углу

    horizontalSize = moves!(r, Right)
    moves!(r, Left)
    horizontalSize = horizontalSize + 1

    while(!(isborder(r, Up)))
        movesAndPutMarkers!(r, Right, horizontalSize)
        horizontalSize = horizontalSize - 1
        if (horizontalSize < 0)
            horizontalSize = 0
        end
        moves!(r,Left)
        moves!(r, Up, 1)
    end
    movesAndPutMarkers!(r, Right, horizontalSize)
    #УТВ: Все клетки поля промакированы

    moveToLeftDownCorner!(r)
    #УТВ: Робот - в Юго-Западном углу

    returnByStepsIn(r, steps)
    #УТВ: Робот - в исходном положении
end
