#= CПИСОК ЗАДАЧ ДЛЯ САМОСТОЯТЕЛЬНОГО РЕШЕНИЯ 4
 https://github.com/Vibof/ProgrammingManual/blob/master/4/%D0%97%D0%B0%D0%B4%D0%B0%D1%87%D0%B8%2014-25.md

 Задачи 14-18 аналогичны задачам 1-5, но дополнительно на поле могут находиться внутрение перегородки прямоугольной формы, 
 среди которых могут быть и вырожденые прямоугольники (отрезки), эти внутренние перегородки изолированы друг от друга и от внешней рамки.
 Задача 19
 Задача 20
 Задача 21
 Задача 22
 Задача 23
 Задача 24
 Задача 25
 =#
 
 include("roblib.jl")
 
 #Задача 14
 #= ДАНО: Робот находится в произвольной клетке ограниченного прямоугольного поля с внутренними перегородоками.

 РЕЗУЛЬТАТ: Робот — в исходном положении в центре прямого креста из маркеров, расставленных вплоть до внешней рамки.
 =#

 function mark_kross(r::Robot)
    for side in (Nord, West, Sud, Ost)
        num_steps = putmarkers_1!(r,side)
        movements!(r,invers(side), num_steps) # тут шибочно было: move!(...)
    end
    putmarker!(r)
end

function putmarkers_1!(r::Robot,side::HorizonSide)
    num_steps=0 
    while move_if_possible!(r, side) == true
        putmarker!(r)
        num_steps += 1
    end 
    return num_steps
end
movements!(r::Robot, side::HorizonSide, num_steps::Int) = for _ in 1:num_steps move!(r,side) end

    movements!(r::Robot, side::HorizonSide) = while isborder(r,side)==false move!(r,side) end 

movements!(r::Robot, side::HorizonSide, num_steps::Int) =
for _ in 1:num_steps
    move_if_possible!(r,side) # - в данном случае возможность обхода внутренней перегородки гарантирована
end

function move_if_possible!(r::Robot, direct_side::HorizonSide)::Bool
    orthogonal_side = left(direct_side)
    reverse_side = invers(orthogonal_side)
    num_steps=0
    while isborder(r,direct_side) == true
        if isborder(r, orthogonal_side) == false
            move!(r, orthogonal_side)
            num_steps += 1
        else
            break
        end
    end
    #УТВ: Робот или уперся в угол внешней рамки поля, или готов сделать шаг (или несколько) в направлении 
    # side

    if isborder(r,direct_side) == false
        move!(r,direct_side)
        while isborder(r,reverse_side) == true
            move!(r,direct_side)
        end
        result = true
    else
        result = false
    end
    for _ in 1:num_steps
        move!(r,reverse_side)
    end
    return result
end

#Задача 15
#= ДАНО: Робот - в произвольной клетке поля 

РЕЗУЛЬТАТ: Робот - в исходном положении, и все клетки по периметру внешней рамки промакированы
=#

STEP = 0

function mark_frame_perimetr!(r::Robot)
    num_steps=[]
    while isborder(r,Sud)==false || isborder(r,West) == false # Робот - не в юго-западном углу
        push!(num_steps, moves!(r, West))
        push!(num_steps, moves!(r, Sud))
    end
    
    for side in (Nord,Ost,Sud,West)
        putmarkers!(r, side) 
    end 
    #УТВ: По всему периметру стоят маркеры
    
    for (i,n) in enumerate(num_steps)
        side = isodd(i) ? Ost : Nord # odd - нечетный
        movements!(r,side,n)
    end
    #УТВ: Робот - в исходном положении
end
    
    function moves!(r::Robot,side::HorizonSide)
        num_steps=0
        while isborder(r,side)==false
            move!(r,side)
            num_steps+=1
        end
        return num_steps
    end
    
    function moves!(r::Robot,side::HorizonSide,num_steps::Int)
        for _ in 1:num_steps # символ "_" заменяет фактически не используемую переменную
            move!(r,side)
        end
    end
    
    function putmarkers!(r::Robot, side::HorizonSide)
        putmarker!(r)
        while isborder(r,side)==false
            move!(r,side)
            putmarker!(r)
        end
    end

#Задача 16 
#= ДАНО: Робот - в произвольной клетке ограниченного прямоугольного поля

РЕЗУЛЬТАТ: Робот - в исходном положении, и все клетки поля промакированы
=#


#Задача 17 
#= ДАНО: Робот - Робот - в произвольной клетке ограниченного прямоугольного поля

РЕЗУЛЬТАТ: Робот - в исходном положении, и клетки поля промакированы так: нижний ряд - полностью, следующий - весь, 
за исключением одной последней клетки на Востоке,
следующий - за исключением двух последних клеток на Востоке, и т.д.
=#