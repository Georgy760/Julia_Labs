function factorial!(n::Int)
    h = 0 
    for i in 1:n
        h = h + fact!(i)
        println(fact!(i))
    end
    println(" ")
    print("Sum: ")
    print(h)
end

function fact!(n::Int) #n = n!
    #n = 2*n
    n = n + 1
    fact = n - 1 #кол. прогонов
    i = 1 # счетчик
    n = 1
    while i <= fact
        i = i + 1
        n = n * i
    end
    return(n)
end
