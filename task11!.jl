include("robot.jl")
include("robolib.jl") #библиотека с вспомогательными функциями

function task11!(r)
    r=Robot("situation_11.sit"; animate=true)
    steps, verticalPos, horizontalPos = moveToLeftDownCornerAndReturnArrayOfSteps(r)
    for side in (Up, Right, Down, Left)
        if (side == Up || side == Down)
            verticalPos = specialMove(r, verticalPos, side)
        else
            horizontalPos = specialMove(r, horizontalPos, side)
        end
    end
    returnByStepsIn(r, steps)
end
