inverse(side::DirectionsOfMovement) = DirectionsOfMovement(mod(Int(side)+2, 4))
nextDirection(side::DirectionsOfMovement)=DirectionsOfMovement(mod(Int(side)+1,4))
prevDirection(side::DirectionsOfMovement)=DirectionsOfMovement(mod(Int(side)-1,4))

MoveByMarkers(r::Robot,side::DirectionsOfMovement) = while ismarker(r)==true
    move!(r,side)
end

function returnByStepsIn(r, num_steps)
    for element in reverse(num_steps)
        if (element == "Up")
            move!(r, Up)
        elseif (element == "Right")
            move!(r, Right)
        end
    end
end

function moveToLeftDownCorner!(r::Robot)
    moves!(r, Down)
    moves!(r, Left)
end

function moveToLeftDownCornerAndReturnArrayOfSteps(r)
    num_steps=[]
    verticalPos = 0
    horizontalPos = 0
    while (isborder(r,Down)==false || isborder(r,Left)==false)
        if (isborder(r, Down) == false)
            push!(num_steps, "Up")
            verticalPos+=1
            move!(r, Down)
        end
        if (isborder(r, Left) == false)
            push!(num_steps, "Right")
            horizontalPos+=1
            move!(r, Left)
        end
    end
    return num_steps, verticalPos, horizontalPos
end

function movements!(r::Robot,side::DirectionsOfMovement,num_steps::Int) #возвращение на num_steps шагов
    for _ in 1:num_steps
        move!(r,side)
    end
end

move_by_markers(r::Robot,side::DirectionsOfMovement) = while ismarker(r)==true
    move!(r,side)
end

function get_num_steps_movements!(r::Robot, side::DirectionsOfMovement) #запоминаем кол-во шагов в направлении side
    num_steps = 0
    while isborder(r, side) == false #пока нет стенки идем в направлении side\запоминаем кол-во шагов\маркеруем их
        putmarker!(r)
        move!(r,side)
        num_steps += 1
    end
    if (isborder(r,side) == true)
        putmarker!(r)
    end
    return num_steps
end

function movements!(r::Robot,side::DirectionsOfMovement) #идем в направлении side до стенки
    while isborder(r,side) == false
        move!(r,side)
    end
end

function movesAndPutMarkers!(r::Robot,side::DirectionsOfMovement, countOfMarkers::Int) #идем в определенном направлении и проставляем определенное кол. маркеров
    while isborder(r, side) == false
        if (countOfMarkers > 0)
            putmarker!(r)
            countOfMarkers = countOfMarkers - 1
        end
        move!(r,side)
    end
    if (countOfMarkers > 0)
        putmarker!(r)
    end
end

function moves!(r::Robot,side::DirectionsOfMovement) #идем в направлении side до стенки и запоминаем шаги
    num_steps=0
    while isborder(r,side)==false
        move!(r,side)
        num_steps+=1
    end
    return num_steps
end

function find_border!(r::Robot, direction_to_border::DirectionsOfMovement, direction_of_movement::DirectionsOfMovement) #Дойти до стороны, двигаясь змейкой вверх-вниз и вернуть последнее перед остановкой направление
    while isborder(r,direction_to_border)==false
        if isborder(r,direction_of_movement)==false
            move!(r,direction_of_movement)
        else
            move!(r,direction_to_border)
            direction_of_movement=inverse(direction_of_movement)
        end
    end
    #УТВ: непосредственно справа от Робота - внутренняя пергородка
end

function snake!(r::Robot,side::DirectionsOfMovement) #движение змейкой с простановкой маркеров
    while isborder(r,side) == false #пока нет стенки идем в сторону side и ставим маркеры
        putmarker!(r)
        move!(r,side)
    end

    if (isborder(r,Up) == false)#Передвигаемся на одну строчку вверх
        putmarker!(r)
        move!(r,Up)
        side = inverse(side::DirectionsOfMovement)
        mark_row!(r,side)
    end
end

function mark_row!(r::Robot,side::DirectionsOfMovement) #заполняем ряд и поднимаемся на след. уровень
    while isborder(r,side) == false #пока нет стенки идем в сторону side и ставим маркеры
        putmarker!(r)
        move!(r,side)
    end
    if (isborder(r,Up) == false)#Передвигаемся на одну строчку вверх
        putmarker!(r)
        move!(r,Up)
        side = inverse(side::DirectionsOfMovement)
        mark_row!(r,side)
    end
end

function putmarkers_until_border!(r::Robot, side::DirectionsOfMovement) #движение до стенки с простановкой маркеров
    while isborder(r,side)==false
        move!(r,side)
        putmarker!(r)
    end
end


function moves!(r::Robot,side::DirectionsOfMovement,num_steps::Int) #передвигаемся определенное кол. шагов в обозначеную сторону
    for _ in 1:num_steps # символ "_" заменяет не используемую переменную
        move!(r,side)
    end
end


function through_rectangles_into_angle(r,angle::NTuple{2,DirectionsOfMovement}) #
    num_steps=[]
    while isborder(r,angle[1])==false || isborder(r,angle[2]) # Робот - не в юго-западном углу
        push!(num_steps, moves!(r, angle[2]))
        push!(num_steps, moves!(r, angle[1]))
    end
    return num_steps
end

function mark_innerrectangle_perimetr!(r::Robot, side::DirectionsOfMovement) #внутренний периметр

    direction_of_movement, direction_to_border = get_directions(side)

    for i ∈ 1:4
        # надо ставить маркеры вдоль очередной стороны внутренней перегородки
        # (перемещаться надо в одном направлении, а следить за перегородеой в -
        # перпендикулярном ему)
        putmarkers!(r,  direction_of_movement[i], direction_to_border[i])
    end
end

function get_directions(side::DirectionsOfMovement) #
    if side == Up # - обход будет по часовой стрелке
        return (Up,Right,Down, Left), (Right,Down,Left,Up)
    else # - обход будет против часовой стрелки
        return (Down,Right,Up,Left), (Right,Up,Left,Down)
    end
end

function putmarkers!(r::Robot, direction_of_movement::DirectionsOfMovement, direction_to_border::DirectionsOfMovement)#обход вдоль стенки, с простановкой маркеров
    while isborder(r,direction_to_border)==true
        move!(r,direction_of_movement)
    end
end

function putmarkers!(r::Robot, side::DirectionsOfMovement)
    while isborder(r,side)==false
        move!(r,side)
        putmarker!(r)
    end
end

function find_marker(r,side,num_steps_max)
    for _ in 1:num_steps_max
        if ismarker(r)
            return nothing
        end
        move!(r,side)
    end
end

function getTeperatureIfMarkedElseGitZero(r) #возвращаем заначение температуры маркеров, кроме 0!
    if ismarker(r)
        return temperature(r)
    else return 0
    end
end

function returnRobotBack!(r,side) #возвращаем робота в исходное положение
    while (ismarker(r))
        move!(r, inverse(side[1]))
        move!(r, inverse(side[2]))
    end
end

function moveAndPutMarkersDiagonal!(r, side::NTuple{2,DirectionsOfMovement}) #проставлем маркеры по диагонали
    while isborder(r,side[1]) == false  &&   isborder(r,side[2]) == false
        move!(r,side[1])
        move!(r,side[2])
        putmarker!(r)
    end
end

function putMarkerIfNecessary(r, x, y, cellSize)
    if(mod(x, 2*cellSize)) < cellSize && (mod(y, 2*cellSize)) < cellSize ||
        (mod(x+ cellSize, 2*cellSize)) < cellSize && (mod(y, 2*cellSize)) >= cellSize
        putmarker!(r)
    end
end

function specialMove(r, pos, side)
    while (pos>0)
        move!(r, side)
        pos -=1
    end
    putmarker!(r)
    while !isborder(r, side)
        move!(r, side)
        pos +=1
    end
    return pos
end

function save(sit ,file_name::AbstractString)
    open(file_name,"w") do io
        write(io, "frame_size:\n") # 11 12
        write(io, join(sit.frame_size, " "),"\n")
        write(io, "coefficient:\n")
        write(io, join(sit.coefficient),"\n")
        write(io, "is_framed:\n") # "true"
        write(io, join(sit.is_framed), "\n")
        write(io, "robot_position:\n") # 1 1
        write(io, join(sit.robot_position, " "), "\n")
        write(io, "temperature_map:\n") # 1 2 3 1 2
        write(io, join(sit.temperature_map, " "), "\n")
        write(io, "markers_map:\n") # "(1, 2)(3, 2)(4, 5)"
        write(io, join(sit.markers_map), "\n")
        write(io,"borders_map:\n")
        for set_positions ∈ sit.borders_map # set_positions - множество запрещенных направлений
            write(io, join(Int.(set_positions)," "), "\n")   # 0 1 3
        end
    end
    println("Сохранение завершено")
end
