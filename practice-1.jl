#CПИСОК ЗАДАЧ ДЛЯ САМОСТОЯТЕЛЬНОГО РЕШЕНИЯ 1

#= Задачи
4) ДАНО: Робот - в произвольной клетке ограниченного прямоугольного поля
РЕЗУЛЬТАТ: Робот - в исходном положении, и все клетки поля промакированы
=#

#Задача 4
function full_field_in_marks!(r::Robot) #Перевод - "Все поле в маркерах"
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

#= 5) ДАНО: Робот - Робот - в произвольной клетке ограниченного прямоугольного поля
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
    num_hor = moves!(r, Ost)
    num_vert = moves!(r, Sud)
    #Правый нижний угол

    lenght_string = get_num_steps_movements!(r, West)
    #Длина нижнего ряда + идем в левый нижний угол

    stairs_marker!(r::Robot,lenght_string::Int)
    #Лестница из маркеров

    movements!(r,Sud)
    movements!(r, Ost)
    #Робот в юго-восточном углу

    #Возвращение в первоначальную позицию
    movements!(r,West,num_hor)
    movements!(r,Nord,num_vert)

end

function stairs_marker!(r,lenght_string)  #Лестница из маркеров
    i = 0
        while (i <= lenght_string) #идем на длину нижней строки
            if (isborder(r,Ost) == false)# если нет преграды, то
                putmarker!(r) #ставим маркер
                move!(r,Ost)#делаем шаг
            end
            i+=1
        end
        movements!(r,West)#возвращаемся в начало строки
        if (isborder(r,Nord)== false)#делаем шаг на верх
            move!(r,Nord)
        end
        lenght_string -=1#уменьшаем максимальную длину строки
        stairs_marker!(r,lenght_string)#идем по 2-ому кругу
end
#= 6) ДАНО: Робот - в произвольной клетке ограниченного прямоугольного поля, на котором могут находиться также внутренние прямоугольные 
перегородки (все перегородки изолированы друг от друга, прямоугольники могут вырождаться в отрезки)
РЕЗУЛЬТАТ: Робот - в исходном положении и в углах поля стоят маркеры =#