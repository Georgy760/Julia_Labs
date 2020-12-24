include("robot.jl")
include("robolib.jl") #библиотека с вспомогательными функциями

function task2!(r::Robot) #периметр
    r=Robot(animate=true)
    num_steps, _, _ =moveToLeftDownCornerAndReturnArrayOfSteps(r)
    #УТВ: Робот - в Юго-Западном углу

    for side in [Up, Right, Down, Left] # движение на север -> восток -> юг -> запад (т.е. по периметру)
        putmarkers_until_border!(r, side)
    end
    #УТВ: По всему периметру стоят маркеры

    returnByStepsIn(r, num_steps)
    #УТВ: Робот - в исходном положении
end
