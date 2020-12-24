include("robot.jl")
include("robolib.jl") #библиотека с вспомогательными функциями

r=Robot(animate=true)
function task1!(r::Robot) #крест
    r=Robot(animate=true)
    for side in (DirectionsOfMovement(i) for i=0:3)
        putmarkers!(r,side)
        move_by_markers(r, inverse(side))
    end
    putmarker!(r)
end
