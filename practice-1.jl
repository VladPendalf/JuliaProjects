#CПИСОК ЗАДАЧ ДЛЯ САМОСТОЯТЕЛЬНОГО РЕШЕНИЯ 2
# https://github.com/Vibof/ProgrammingManual/blob/master/lecture-1/%D0%A1%D0%BF%D0%B8%D1%81%D0%BE%D0%BA-%D0%B7%D0%B0%D0%B4%D0%B0%D1%87-1.md

#Задача 1 - example-1.jl
#Задача 2 - example-2.jl
#Задача 3 - practice-1.jl
#Задача 4 - practice-1.jl
#Задача 5 - practice-1.jl

include("roblib.jl")
    #=
        invers(side::HorizonSide)
        movements!(r::Robot,side::HorizonSide,num_steps::Int)
        get_num_steps_movements!(r::Robot, side::HorizonSide)
        movements!(r::Robot,side::HorizonSide)
        moves!(r::Robot,side::HorizonSide)
        find_border!(r::Robot,direction_to_border::HorizonSide, direction_of_movement::HorizonSide)
    =#

#= Задачи 3) ДАНО: Робот - в произвольной клетке ограниченного прямоугольного поля
РЕЗУЛЬТАТ: Робот - в исходном положении, и все клетки поля промакированы =#

#Задача 3
function full_field_in_marks!(r::Robot) 
    num_vert = get_num_steps_movements!(r, Sud)
    num_hor = get_num_steps_movements!(r, West)
    #УТВ: Робот в юго-западном углу

    side = Ost
    mark_row!(r,side) #Идем змейкой и ставим маркеры
    putmarker!(r) #последней маркер в северном углу
    #Робот - у северной границы (в левом или правом углу)

    movements!(r,Sud)
    movements!(r, West)
    #Робот в юго-западном углу

    #Возвращение в первоначальную позицию
    movements!(r,Ost,num_hor)
    movements!(r,Nord,num_vert)
end

#Изменение направления на противоположное
invers(side::HorizonSide) = HorizonSide(mod(Int(side) + 2,4)) 

function mark_row!(r::Robot,side::HorizonSide)
    while isborder(r,side) == false #пока нет стенки идем в сторону side и ставим маркеры
        putmarker!(r)
        move!(r,side)
    end
    if (isborder(r,Nord) == false)#Передвигаемся на одну строчку вверх
        putmarker!(r)
        move!(r,Nord)
        side = invers(side::HorizonSide)
        mark_row!(r,side)
    end
end


function get_num_steps_movements!(r::Robot, side::HorizonSide)
    num_steps = 0
    while isborder(r, side) == false #пока нет стенки идем в направлении side и запоминаем кол-во шагов
        move!(r,side)
        num_steps += 1
    end
    return num_steps
end

function movements!(r::Robot,side::HorizonSide)
    while isborder(r,side) == false
        move!(r,side)
    end
end
function movements!(r::Robot,side::HorizonSide,num_steps::Int) #возвращаемся на num_steps шагов
    for _ in 1:num_steps
        move!(r,side)
    end
end

#= 4) ДАНО: Робот - Робот - в произвольной клетке ограниченного прямоугольного поля
РЕЗУЛЬТАТ: Робот - в исходном положении, и клетки поля промакированы так: нижний ряд - полностью, следующий - весь, за исключением одной последней 
клетки на Востоке, следующий - за исключением двух последних клеток на Востоке, и т.д. =#
#=
    ф-ия ...
    идем в правый нижний угол (запоминая шаги)
    начинаем маркировать все поле в противоположном направлении (запоминая длина нижнего поля)
    делаем 1 шаг на верх и идем на Восток уменьшив длину нижнего поля на 1
    повторяем до значения 0
    идем в правый нижний угол и возвращаемся в начальную позицию
=#

function stairs!(r)
    movements!(r,Sud)
    movements!(r,West)
    
    side = Ost
    num_hor = moves!(r,side)
    movements!(r,West)
    mark_up!(r,num_hor)
end

function mark_up!(r::Robot,size::Int)
    i = 0
    while (1 <= size)
        for _ in 1:size
            move!(r,Ost)
            putmarker!(r)
        end
        if (isborder(r,West) == false)
            movements!(r,West)
            putmarker!(r)
        end
        if (isborder(r,Nord) == false)
        move!(r,Nord)
        size = size - 1
        else
            break
        end
    end
end

#= 5) ДАНО: Робот - в произвольной клетке ограниченного прямоугольного поля, на котором могут находиться также внутренние прямоугольные 
перегородки (все перегородки изолированы друг от друга, прямоугольники могут вырождаться в отрезки)
РЕЗУЛЬТАТ: Робот - в исходном положении и в углах поля стоят маркеры =#
function mark_angles(r)
    num_steps=[]
    while isborder(r,Sud)==false || isborder(r,West) == false # Робот - не в юго-западном углу
        push!(num_steps, moves!(r, West))
        push!(num_steps, moves!(r, Sud))
    end
    # УТВ: Робот - в юго-западном углу и в num_steps - закодирован пройденный путь
    for side in (Nord,Ost,Sud,West)
        movements!(r,side)
        putmarker!(r)
    end
    # УТВ: Маркеры поставлены и Робот - в юго-западном углу

    for (i,n) in enumerate(num_steps)
        side = isodd(i) ? Nord : Ost # odd - нечетный
        movements!(r,side,n)
    end
    #УТВ: Робот - в исходном положении
end