#CПИСОК ЗАДАЧ ДЛЯ САМОСТОЯТЕЛЬНОГО РЕШЕНИЯ 2
# https://github.com/Vibof/ProgrammingManual/blob/master/lecture-2/%D0%A1%D0%BF%D0%B8%D1%81%D0%BE%D0%BA-%D0%B7%D0%B0%D0%B4%D0%B0%D1%87-2.md

#Задача 6 - выполнен
#Задача 7 - выполнен
#Задача 8 - выполнен
#Задача 9 - выполнен

#= Задача 6 
ДАНО: На ограниченном внешней прямоугольной рамкой поле имеется ровно одна внутренняя перегородка в форме прямоугольника. 
Робот - в произвольной клетке поля между внешней и внутренней перегородками. 
РЕЗУЛЬТАТ: Робот - в исходном положении и по всему периметру внутренней перегородки поставлены маркеры. =#

#=
ф-ия ...
    Дойти до упора вниз и вернуть число сделанных шагов
    Дойти до упора влево и вернуть число сделанных шагов
    Дойти до упора вниз и вернуть число сделанных шагов
    #УТВ: Робот - в Юго-западном углу внешней рамки

    Подойти к западной стороне внутренней перегородки (двигаясь змейкой вверх-вниз) и вернуть последнее перед остановой направление движения

    Обойти внутренний прямоугольник, начиная с полученного направления, и расставить по всему его периметру маркеры
    #УТВ: Робот -  у западной границы внутренней прямоугольной перегородки

    Дойти до упора вниз
    Дойти до упора влево
    #УТВ: Робот - в Юго-западном улу внешней рамки

    Сделать известное число шагов вверх
    Сделать известное число шагов вправо
    Сделать известное число шагов вверх
    #УТВ: Робот - в исходном положении
=#

using HorizonSideRobots
#=
Модуль HorizonSideRobots экспортирует перечисление HorizonSide, содержащее символы Nord, Sud, Ost, West,  и определения следующих функций:
    - moves!(::Robot, ::HorizonSide)
    - moves!(::Robot, ::HorizonSide, ::Int)
    - find_border!(::Robot, ::HorizonSide, ::HorizonSide)
    - inverse(::HorizonSide)
    - putmarkers!(::Robot, ::HorizonSide)
    - putmarkers!(r, direction_of_movement, direction_to_border)
=#

include("roblib.jl")
    #=
        invers(side::HorizonSide)
        movements!(r::Robot,side::HorizonSide,num_steps::Int)
        get_num_steps_movements!(r::Robot, side::HorizonSide)
        movements!(r::Robot,side::HorizonSide)
        moves!(r::Robot,side::HorizonSide)
        find_border!(r::Robot,direction_to_border::HorizonSide, direction_of_movement::HorizonSide)
    =#
    
#= Задача 7
ДАНО: Робот - в произвольной клетке ограниченного прямоугольного поля (без внутренних перегородок)

РЕЗУЛЬТАТ: Робот - в исходном положении, в клетке с роботом стоит маркер, и все остальные клетки поля промаркированы в шахматном порядке =#

#=
ф-ия ...
    ставим маркер
    делаем два шага вниз
    ставим маркер
    если внизу преграда через 1 ставим в side маркеры
    делаем шаг на вверх + в side
    ставим маркеры через 1
=#

#=
        invers(side::HorizonSide)
        movements!(r::Robot,side::HorizonSide,num_steps::Int)
        get_num_steps_movements!(r::Robot, side::HorizonSide)
        movements!(r::Robot,side::HorizonSide)
        moves!(r::Robot,side::HorizonSide)
        find_border!(r::Robot,direction_to_border::HorizonSide, direction_of_movement::HorizonSide)
    =#

function chess!(r::Robot)
     num_hor = moves!(r,West)
     num_vert = moves!(r,Sud)
    #Левый нижний угол

    side = Ost
    if ((num_hor % 2) == 0) #если слево расстояние четна
        if ((num_vert % 2) == 0) # если вертикаль четна
            putmarks2!(r,side)
        else # если вертикаль не четна
            putmarks1!(r,side)
        end
    else
        putmarks1!(r,side)
    end
    #алгоритм - выполнен

    movements!(r,West)
    movements!(r,Sud)

    movements!(r,Ost,num_hor)
    movements!(r,Nord,num_vert)
end

function putmarks1!(r::Robot,side::HorizonSide)
    movements!(r,invers(side))
    move!(r,side)
    while isborder(r,side) == false        
        putmarker!(r)
        for _ in 1:2
            if (isborder(r,side) == false)
                move!(r,side)
            else
                if (isborder(r,Nord) == fasle)
                    move!(r,Nord)
                    side = invers(side)
                    move!(r,side)
                end
            end
        end
    end
    putmarker!(r)
    if (isborder(r,Nord) == false)
        move!(r,Nord)
        putmarks2!(r,Ost)
    end
end


function putmarks2!(r::Robot,side::HorizonSide)
    movements!(r,invers(side))
    while isborder(r,side) == false
        putmarker!(r)
        for _ in 1:2
            if (isborder(r, side) == false)
                move!(r,side)
            else
                if (isborder(r,Nord) == false)
                    move!(r,Nord)
                    side = invers(side)
                end
            end
        end
    end
end

invers(side::HorizonSide) = HorizonSide(mod(Int(side) + 2,4))

#= Задача 8
ДАНО: Робот - рядом с горизонтальной перегородкой (под ней), бесконечно продолжающейся в обе стороны, в которой имеется проход шириной в одну клетку.
РЕЗУЛЬТАТ: Робот - в клетке под проходом =#

function robot_under_door!(r::Robot)
    side = Ost
    search_door!(r,side)
end

function search_door!(r::Robot,side::HorizonSide)
    i = 1
    while (isborder(r,Nord) == true)
    m = 0
            while (m != i)
                move!(r,side)
                m+=1
            end
            i+=1
            side = invers(side)
    end
end

#= Задача 9
ДАНО: Где-то на неограниченном со всех сторон поле и без внутренних перегородок имеется единственный маркер. Робот - в произвольной клетке поля.
РЕЗУЛЬТАТ: Робот - в клетке с тем маркером. =#

function find_marker(r)
    num_steps_max=1
    side=Nord
    while ismarker(r)==false
        for _ in 1:2
            find_marker(r,side,num_steps_max)
            side=next(side)
        end
        num_steps_max+=1
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

next(side::HorizonSide)=HorizonSide(mod(Int(side)+1,4))

