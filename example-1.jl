#= ДАНО: Робот находится в произвольной клетке ограниченного прямоугольного поля без внутренних перегородок и маркеров.

 РЕЗУЛЬТАТ: Робот — в исходном положении в центре прямого креста из маркеров, расставленных вплоть до внешней рамки.

 function main
for side in (Nord,West, Sud, Ost)
    маркировать в направлении side до упора и вернуть число сделанных шагов
    сделать полученное число шагов в обратном направлении
end

 =#

function mark_kross!(r::Robot)
    for side in (Nord,West,Sud,Ost)
        num_steps=get_num_steps_putmarkers!(r,side)
        movements!(r,invers(side),num_steps)
    end
    putmarker!(r)
end

invers(side::HorizonSide) = HorizonSide(mod(Int(side) + 2,4)) 

function get_num_steps_putmarkers!(r::Robot,side::HorizonSide)
    num_steps=0
    while isborder(r, side) == false
        move!(r,side)
        putmarker!(r)
        num_steps += 1
    end
    return num_steps
end

movements!(r::Robot,side::HorizonSide,num_steps::Int) =
    for _ in 1:num_steps
        move!(r,side)
    end