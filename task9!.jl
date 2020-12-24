include("robot.jl")
include("robolib.jl") #библиотека с вспомогательными функциями

function task9!(r) #поиск маркера
    r=Robot("situation_9.sit"; animate=true)
    num_steps=1
    side = Up
    while ismarker(r)==false
        for _ in 1:2
            find_marker(r,side,num_steps)
            side=nextDirection(side)
        end
        num_steps+=1
    end
end
