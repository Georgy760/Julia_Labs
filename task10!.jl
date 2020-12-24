include("robot.jl")
include("robolib.jl") #библиотека с вспомогательными функциями

function task10!(r)
    r=Robot("situation_10.sit"; animate=true)
    countOfElements = 0
    sumOfElements = 0
    horisontalDirection = Right
    while !(isborder(r, Up) && isborder(r, Right))
        countOfElements += Int(ismarker(r))
        sumOfElements += getTeperatureIfMarkedElseGitZero(r)
        if isborder(r, Right) || isborder(r, Left) && !(isborder(r, Down) && isborder(r, Left))
            move!(r, Up)
            horisontalDirection = inverse(horisontalDirection)
        end
        move!(r,horisontalDirection)
    end
    println(sumOfElements/countOfElements)
end
