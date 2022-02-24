using Combinatorics
using Random
using PyPlot

function ExhaustivePartition(S)
    N = length(S);


    cost = []
    numtries = 0;
    totPossible = 2^N

    separating = ones(N)
    for j in 1:convert(Int64, ceil(N/2))
        separating[j] *= -1
        for i in 1:factorial(N)

            push!(cost, abs(sum(nthperm(separating,i).* S)))
            numtries += 1;
        end

    end
    #println(cost)
    return min(cost...)

end

function MakeRandomPartitionProblem(N::Int64, M::Int64)
    so = 1;
    while mod(so,2) == 1
        global set = rand(1:2^M, N)
        so = sum(set)
    end

    return set

end

function pPerf(N, M, trials)
numattempts = 0;
success = 0;

    for i in 1:trials
        cost = ExhaustivePartition(MakeRandomPartitionProblem(N,M))
        if cost == 0.0
            success += 1;
        end
        numattempts += 1;
    end

    return success/numattempts

end



function graphPerf(trials)
    n = [3, 5, 7, 9]
    m = [collect(1:5),collect(1:9),collect(1:13),collect(1:17)]
    global mndata = []
    global percentages = []

    for i in 1:length(n)
        for j in 1:length(m[i])
            push!(percentages,pPerf(n[i],m[i][j],trials))
            push!(mndata, m[i][j]/n[i])
        end
    end


    scatter(mndata, percentages)
    xlabel("M/N")
    ylabel("Percentages, 1 = 100%")
    title("M/N percentages for 0 < M/N < 2")
    xlim([0,2])




end

function graphTheory()
    n = [3, 5, 7, 9]
    m = [collect(1:5),collect(1:9),collect(1:13),collect(1:17)]

    global x = .5 * log2(6)

    pperf = 1 .- exp.(sqrt(3/(2*pi*6)) .* 2 .^(-6 .*(mndata .- 1)))
    theorypperf = 1 .- exp.(sqrt(3/(2*pi)) .* 2 .^ (-x))

    scatter(mndata, pperf)
    ylim([-1, 0])
    title("x vs Perf")
    xlabel("x")
    ylabel("Calculated Perf")


end
