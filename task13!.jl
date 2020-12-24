include("robot.jl")
include("robolib.jl") #библиотека с вспомогательными функциями

function task13!(r)
    r=Robot(animate=true)
    for side in ((Up,Left),(Up,Right),(Down,Right),(Down,Left))
        moveAndPutMarkersDiagonal!(r,side)
        returnRobotBack!(r, side)
    end
    putmarker!(r)
end
