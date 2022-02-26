## Problem 1

function mySin(x, n)
    result = 0;
    for i in 0:n
        result += ((-1)^n/factorial(big(2*n + 1)))*x^(2*n + 1) 
    end
    
    return result
end

function rmseSin(n)
    points = 2 * pi * rand(Float64,(10^6, 1))
    
    result = 0;
    
    for i in points

        result += mySin(i, n) - sin(i)
    
    end

    return sqrt(result^2 / 10^6)
        
end

function interpSin(numPoints)
    dx = 2*pi / numPoints
    x = collect(0:dx:2*pi)

    sinPoints = sin.(x)
    randomPoints = 2 * pi * rand(Float64, 10^6, 1)

    result = 0

    for i in randomPoints
        result += linearInterp(i, x, sinPoints) - sin(i)
    end

    return sqrt(result^2 / 10^6)

end

function linearInterp(xpoint ,x, y)
    for n in 1:(size(x) .- 1)[1]
        if xpoint >= x[n] && xpoint <= x[n + 1]
            ypoint = ((y[n+1] - y[n])/(x[n + 1] - x[n]))*(xpoint - x[n]) + y[n]
            return ypoint
        end
    end

    println("There was an error in linearInterp")
end

## Problem 2

function f2(x)
    return exp(-cos(x))
end

function g(x)
    if (x <= 1 && x >= -1)
        return f2(x)
    else
        return 0
    end
end