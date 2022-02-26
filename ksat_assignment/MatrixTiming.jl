using PyPlot

## Functions

function TimeFunction(func, args...)

    return @elapsed func(args...)
end

function GenerateMatrices(n)

    A = 10 .* rand(n, n);
    b = 10 .* rand(n, 1);

    return A, b
end

function InverseMethod(A, b)
    return inv(A)*b
end

function BetterMethod(A, b)
    return A \ b
end

function InverseTimeTaken(n, runs)

    time = 0;

    for m in 1:runs
        A, b = GenerateMatrices(n);
        time += TimeFunction(InverseMethod, A, b)
    end

    return time / runs
end

function BetterTimeTaken(n, runs)

    time = 0;

    for m in 1:runs
        A, b = GenerateMatrices(n);
        time += TimeFunction(BetterMethod, A, b)
    end

    return time / runs
end

function CompareTimes()
    n = 100:100:5000;
    inTime = [];
    betTime = [];

    for k in n
        push!(inTime, InverseTimeTaken(k, 1))
        push!(betTime, BetterTimeTaken(k, 1))
    end

    return inTime, betTime, n

end

function GraphTimes()
    iT, bT, n = CompareTimes();


    loglog(n,iT)
    loglog(n,bT)


end
