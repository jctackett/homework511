using LinearAlgebra

function main1()
    A = [.78 .563; .913 .659]
    b = [.217; .254]

    x = [1, -1]
    xalpha = [.999; -1.001]
    xbeta = [.341; -.087]

    # A

    ralpha = b - A * xalpha
    rbeta = b - A * xbeta
    println("R alpha is ", ralpha)
    println("R beta is ", rbeta)

    # B

    U, S, V = svd(A)

    conditionNum = norm(A) * norm(A^-1)


    println("The condition number is ", conditionNum)
    V * (xalpha - x)
    V * (xbeta - x)

    println("Singular values are ", S)

    # C

    println("error: ",x - (A \ b))

    println("Ax-b: ",A*x - b)


    # D

    delX = A \ -rbeta

    newX = xbeta - delX

    println(A * newX - b)
    println(A * xbeta - b)


end

function main2()
    E = 3;
    t = 1;
    gam = -E + t;

    T = [E-t t 0 0 0; t E-t t 0 0; 0 t E-t t 0; 0 0 t E-t t; 0 0 0 t E-t]
    C = [E-t t 0 0 t; t E-t t 0 0; 0 t E-t t 0; 0 0 t E-t t; t 0 0 t E-t]
    Ck = [E-t-gam t 0 0 0; t E-t t 0 0; 0 t E-t t 0; 0 0 t E-t t; 0 0 0 t E-t-t^2/gam]

    invT = T^-1

    invCk = Ck^-1

    u = [gam; 0; 0; 0; t]
    v = [1; 0; 0; 0; t/gam]

    z = invCk * u;
    w = invCk' * v;
    lam = dot(v,z);

    println(invT - C^-1)

    return (invCk - (z .* w')/(1 + lam))

end
