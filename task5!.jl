include("robot.jl")
include("robolib.jl") #библиотека с вспомогательными функциями

function task5!(r) #углы
    r=Robot(animate=true)
    num_steps, _, _=moveToLeftDownCornerAndReturnArrayOfSteps(r)
    # УТВ: Робот - в юго-западном углу и в num_steps - закодирован пройденный путь

    for side in (Up,Right,Down,Left)
        moves!(r,side) # возвращаемый результат игнорируется
        putmarker!(r)
    end
    # УТВ: Маркеры поставлены и Робот - в юго-западном углу
    returnByStepsIn(r, num_steps)
    #УТВ: Робот - в исходном положении
end
