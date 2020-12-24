include("robot.jl")
include("robolib.jl") #библиотека с вспомогательными функциями

function task3!(r::Robot) #все клетки поля промакированы
    r=Robot(animate=true)
    num_vert = get_num_steps_movements!(r, Down)
    num_hor = get_num_steps_movements!(r, Left)
    #УТВ: Робот в юго-западном углу

    side = Right
    snake!(r,side) #Идем змейкой и ставим маркеры
    putmarker!(r) #последней маркер в северном углу

    #УТВ: Робот - у северной границы (в левом или правом углу)
    movements!(r,Down)
    movements!(r, Left)

    #УТВ: Робот - в Юго-Западном углу
    movements!(r,Right,num_hor)
    movements!(r,Up,num_vert)
    #УТВ: Робот - в исходном положении
end
