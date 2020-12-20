# Универсальные ф-ии из всех задач
# 1 - ф-ия {инверсия направления}
invers(side::HorizonSide) = HorizonSide(mod(Int(side) + 2,4)) #инверсия

# 2 - ф-ия {возвращение на num_steps шагов}
function movements!(r::Robot,side::HorizonSide,num_steps::Int) #{возвращение на num_steps шагов}
    for _ in 1:num_steps
        move!(r,side)
    end
end

# 3 - ф-ия {запоминаем кол-во шагов в направлении side}
function get_num_steps_movements!(r::Robot, side::HorizonSide) #{запоминаем кол-во шагов в направлении side}
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
# 4 - ф-ия {идем в направлении side до стенки}
function movements!(r::Robot,side::HorizonSide) #{идем в направлении side до стенки}
    while isborder(r,side) == false
        move!(r,side)
    end
end

# 5 - ф-ия {идем в направлении side до стенки и запоминаем шаги}
function moves!(r::Robot,side::HorizonSide) #{идем в направлении side до стенки и запоминаем шаги}
    num_steps=0
    while isborder(r,side)==false
        move!(r,side)
        num_steps+=1
    end
    return num_steps
end

# 6 - ф-ия {Дойти до стороны, двигаясь змейкой вверх-вниз и вернуть последнее перед остановкой направление}
function find_border!(r::Robot, direction_to_border::HorizonSide, direction_of_movement::HorizonSide) #{Дойти до стороны, двигаясь змейкой вверх-вниз и вернуть последнее перед остановкой направление}
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

function movements!(r,sides,num_steps::Vector{Int})
    for (i,n) in enumerate(num_steps)
        movements!(r, sides[mod(i-1, length(sides))+1], n)
    end
end


# 7 - ф-ия {Возвращает направление, следующее, если отсчитывать против часовой стредки, по отношению к заданному}
left(side::HorizonSide) =  HorizonSide(mod(Int(side)+1, 4))


# 8 - ф-ия {Bозвращает направление, предыдущее, если отсчитывать против часовой стредки, по отношению к заданному}
right(side::HorizonSide) = HorizonSide(mod(Int(side)-1, 4))