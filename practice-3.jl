#CПИСОК ЗАДАЧ ДЛЯ САМОСТОЯТЕЛЬНОГО РЕШЕНИЯ 3
# https://github.com/Vibof/ProgrammingManual/blob/master/3/%D0%97%D0%B0%D0%B4%D0%B0%D1%87%D0%B8%2010-13.md

#Задача 10 - выполнена
#Задача 11 - не понял условие?
#Задача 12 - task12.jl
#Задача 13 - выполнена

include("roblib.jl")

#=Задача 10 
ДАНО: Робот - в юго-западном углу поля, на котором расставлено некоторое количество маркеров
РЕЗУЛЬТАТ: Функция верула значение средней температуры всех замаркированных клеток
=#

function sigma_temper!(r::Robot)
    side = Ost
    count = 0
    total = 0
    res = 0
    total = search_temp(r,side,res,count)
    return total
end

function search_temp(r::Robot,side::HorizonSide, count::Int, res::Int)
    while (isborder(r,side)==false)#идем до упора
        move!(r,side)
        if (ismarker(r) == true)#если в клетке маркер, то считываем температуру
            res += temperature(r)
            count += 1
        end
    end #дошли до конца первой линии
    if (isborder(r,Nord)==false)#если сверху нет преграды
        move!(r,Nord)#делаем шаг
        if (ismarker(r) == true)#если в клетке маркер, то считываем температуру
            res += temperature(r)
            count += 1
        end
        side = invers(side)#меняем направление на противоположное
        search_temp(r,side,count,res)#повторяем алгоритм
    end
    return res/ count
end

#=Задача 11 
ДАНО: Робот - в произвольной клетке ограниченного прямоугольного поля, на котором могут находиться также внутренние прямоугольные перегородки 
(все перегородки изолированы друг от друга, прямоугольники могут вырождаться в отрезки)
РЕЗУЛЬТАТ: Робот - в исходном положении, и в 4-х приграничных клетках, две из которых имеют ту же широту, а две - ту же долготу, что и Робот, 
стоят маркеры.
=#


#=Задача 12 
На прямоугольном поле произвольных размеров расставить маркеры в виде "шахматных" клеток, начиная с юго-западного угла поля, когда каждая отдельная 
"шахматная" клетка имеет размер n x n клеток поля (n - это параметр функции). Начальное положение Робота - произвольное, конечное - совпадает с 
начальным. Клетки на севере и востоке могут получаться "обрезанными" - зависит от соотношения размеров поля и "шахматных" клеток. 
(Подсказка: здесь могут быть полезными две глобальных переменных, в которых будут содержаться текущие декартовы координаты Робота относительно 
начала координат в левом нижнем углу поля, например)
=#

# include("task12.jl")


#=Задача 13 
АНО: Робот - в произвольной клетке ограниченного прямоугольной рамкой поля без внутренних перегородок и маркеров.
РЕЗУЛЬТАТ: Робот - в исходном положении в центре косого креста (в форме X) из маркеров.
=#

function mark_kross_x(r::Robot)
    for side in ((Nord,Ost),(Sud,Ost),(Sud,West),(Nord,West))
        putmarkers!(r,side)
        move_by_markers!(r,invers(side))
    end
    putmarker!(r)
end

function putmarkers!(r::Robot,side::NTuple{2,HorizonSide})
    while isborder(r,side)==false  
        move!(r,side)
        putmarker!
    end 
end

HorizonSideRobots.isborder(r::Robot,side::NTuple{2,HorizonSide}) = (isborder(r,side[1]) || isborder(r,side[2]))

HorizonSideRobots.move!(r::Robot, side::NTuple{2,HorizonSide}) = for s in side move!(r,s) end
# Здесь мы переопределяем одноименную стандартную команду Робота, определенную в модуле HorizonSideRobots 
# (важно, что в новом определении аргумент side имеет другой тип, отличный от соответствующего типа
# в стандартной команде), и поэтому в этом определении нам пришлось использовать составное имя: 
# HorizonSideRobots.move!

move_by_markers!(r::Robot,side::NTuple{2,HorizonSide}) = while ismarker(r)==true move!(r,side) end

invers(side::NTuple{2,HorizonSide}) = (invers(side[1]),invers(side[2]))