include("roblib.jl") 
#=
    invers(side::HorizonSide) инверсия
    movements!(r::Robot,side::HorizonSide,num_steps::Int) {возвращение на num_steps шагов}
    get_num_steps_movements!(r::Robot, side::HorizonSide) запоминаем кол-во шагов в направлении side
    movements!(r::Robot,side::HorizonSide) идем в направлении side до стенки
    moves!(r::Robot,side::HorizonSide) идем в направлении side до стенки и запоминаем шаги
    find_border!(r::Robot,direction_to_border::HorizonSide, direction_of_movement::HorizonSide) Дойти до стороны, двигаясь змейкой вверх-вниз и вернуть последнее перед остановкой направление
=#

module ChessMark
    using HorizonSideRobots
    import Main.moves!, Main.invers ,Main.get_num_steps_movements!,Main.putmarker,Main.movements!

    export mark_chess

    FLAG_MARK = nothing

    function mark_chess(r)
        global FLAG_MARK
        # Глобальные переменные, ввиду их особой важности, следует именовать заглаными буквами. 
        # Объявление переменной как global требуется, только если ее значение ИЗМЕНЯЕТСЯ в теле функции, 
        # использоваться же она может и без такого объявления

        num_hor =  get_num_steps_movements!(r,West)
        num_vert = get_num_steps_movements!(r,Sud)
        #Робот в ЮГО-ЗАПАДНОМ углу

        FLAG_MARK = isodd(num_hor+num_vert) ? true : false

        side = Ost
        mark_chess(r,side)
        while isborder(r,Nord)==false
            move!(r,Nord); FLAG_MARK = !FLAG_MARK
            side = invers(side)
            mark_chess(r,side)
        end
        #Робот - у северной границы поля И маркеры расставлены в шахматном порядке

        for side in (West,Sud) moves!(r,side) end
        #Робот в юго-западном углу

        movements!(r,Ost,num_hor)
        movements!(r,Nord,num_vert)
    end

    function mark_chess(r::Robot,side::HorizonSide)
        global FLAG_MARK
        while isborder(r,side)==false
            if FLAG_MARK == true
                putmarker(r)
            end
            move!(r,side); FLAG_MARK = !FLAG_MARK
        end
    end
end
