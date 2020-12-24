include("robot.jl")
include("robolib.jl") #библиотека с вспомогательными функциями

#УТВ: Робот - в произвольной клетке ограниченного прямоугольного поля
#r=Robot(animate=true)
r=Robot(animate=true)
function task1!(r::Robot) #крест
    r=Robot(animate=true)
    for side in (DirectionsOfMovement(i) for i=0:3)
        putmarkers!(r,side)
        move_by_markers(r, inverse(side))
    end
    putmarker!(r)
end

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

function task6!(r) #по всему периметру внутренней перегородки поставлены маркеры
    r=Robot("situation_6.sit"; animate=true)
    num_steps, _, _ =moveToLeftDownCornerAndReturnArrayOfSteps(r)
    #обходим поле змейкой, пока справа не будет стенки
    isDirUp = true
    move!(r, Up)
    while !isborder(r, Right)
        if !isborder(r, Up) && !isborder(r, Down)
            (isDirUp == true) ? move!(r, Up) : move!(r, Down)
        else
            move!(r, Right)
            isborder(r, Up) ? move!(r, Down) : move!(r, Up)
            isDirUp = !isDirUp
        end
    end

    #Обходим фигуру по часовой стрелке
    for direction in (Up, Right, Down, Left)
        while isborder(r, DirectionsOfMovement(mod(Int(direction)-1, 4))) && !(ismarker(r))
            putmarker!(r)
            move!(r, direction)
        end
        if !(ismarker(r))
            putmarker!(r)
            move!(r, DirectionsOfMovement(mod(Int(direction)-1, 4)))
        end
    end
    moveToLeftDownCorner!(r)
    returnByStepsIn(r, num_steps)
end

function task7!(r) #шахматы
    r=Robot(animate=true)
    num_steps=[]
    isMarked = true
    num_steps, x, y= moveToLeftDownCornerAndReturnArrayOfSteps(r)
    isMarked = !(isodd(x+y))
    #змейкой проставляем маркеры до правого верхнего угла
    horisontalDirection = Right
    while !(isborder(r, Up) && isborder(r, Right))
        if (isMarked)
            putmarker!(r)
        end
        if isborder(r, Right) || isborder(r, Left) && !(isborder(r, Down) && isborder(r, Left))
            move!(r, Up)
            isMarked = !isMarked
            if (isMarked)
                putmarker!(r)
            end
            horisontalDirection = inverse(horisontalDirection)
        end
        move!(r,horisontalDirection)
        isMarked = !isMarked
    end
    if isMarked
        putmarker!(r)
    end
    moveToLeftDownCorner!(r)
    returnByStepsIn(r, num_steps)

end

#Восьмой нет

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

function task12!(r, cellSize)
    r=Robot(animate=true)
    x=0; y=0
    num_steps, _, _ = moveToLeftDownCornerAndReturnArrayOfSteps(r)
    horisontalDirection = Right
    while !(isborder(r, Up) && isborder(r, Right))
        putMarkerIfNecessary(r, x, y, cellSize)
        if isborder(r, Right) || isborder(r, Left) && !(isborder(r, Down) && isborder(r, Left))
            move!(r, Up)
            y+=1
            putMarkerIfNecessary(r, x, y, cellSize)
            horisontalDirection = inverse(horisontalDirection)
        end
        move!(r,horisontalDirection)
        (horisontalDirection == Right) ? x+=1 : x-=1
    end
    putMarkerIfNecessary(r, x, y, cellSize)
    moveToLeftDownCorner!(r)
    returnByStepsIn(r, num_steps)
end

function task13!(r)
    r=Robot(animate=true)
    for side in ((Up,Left),(Up,Right),(Down,Right),(Down,Left))
        moveAndPutMarkersDiagonal!(r,side)
        returnRobotBack!(r, side)
    end
    putmarker!(r)
end
