## Packages and Using
using Random
using Distributions

## Functions

function reduceC(varNext::Int, status::Bool)
        # Might need to throw in a ton of globals

        global numtries+=1;


        clauseSet = []; # Set of clauses set to true
        varSet = []; # Nested sets of following type: [valueDeleted, clauseNumber, elementNumber]




        global varStatus[varNext] = status;
        global varStatus[-varNext] = !status;

        # Going through the clauses and updating the statuses with new varNext status
        for i in 1:length(clauseList)
                try
                        #checkForRedundancy()
                        #if i > length(clauseList)
                        #        break
                        #end
                        if clauseStatus[clauseList[i]] == true # If clause status is true, we're done with this one
                                nothing
                        else
                                for j=1:length(clauseList[i]) # Checking each element of clause

                                        if j>length(clauseList[i]) # Catching error that arises when a variable is deleted
                                                break
                                        end
                                        if varStatus[clauseList[i][j]] == true # If true, mark down for unwind and set clause to true
                                                global clauseStatus[clauseList[i]] = true;
                                                push!(clauseSet, i)
                                        elseif varStatus[clauseList[i][j]] == false # If false, take it out of clauses to reduce it down
                                                if length(clauseList[i]) > 1 # If this clause is about to be reduced to zero, we have failed this try
                                                        push!(varSet,[clauseList[i][j],i,j])
                                                        delete!(clauseStatus, clauseList[i])
                                                        deleteat!(clauseList[i],j)
                                                        global clauseStatus[clauseList[i]] = NaN
                                                        println("Post deleting status")
                                                        println(clauseStatus)
                                                        println("Post deleting clauseList[i]")
                                                        println(clauseList[i])
                                                else
                                                        return false, varSet, clauseSet
                                                end
                                        end
                                end
                        end
                catch
                        println("ERROR")
                        continue
                end
        end
        return true, varSet, clauseSet
end

function checkForRedundancy()
        for k in 1:length(clauseList)
                if k > length(clauseList)
                        break
                end
                for j in 1:length(clauseList)
                        if j > length(clauseList)
                                break
                        end
                        if k == j
                                nothing
                        else
                                if clauseList[k] == clauseList[j]
                                        deleteat!(clauseList,j)
                                end
                        end
                end
        end

end

function checkForSinglets()

        for n = 1:length(clauseList)
                if clauseStatus[clauseList[n]] === NaN
                        if length(clauseList[n]) == 1
                                if n <= varPrev
                                        nothing
                                else
                                        global varPrev = n;
                                        return clauseList[n][1]
                                end
                        end
                end
        end
        return false

end

function useHardCodedData()
        global i = 1; # Used to find next variable
        global varNumber = 7; # Don't forget to change this
        global varPrev = 0; # Used in singlet optimization

        global numtries = 0;

        clauseList = [[7],[1,2,3],[4,5,6],[-7]];
        varStatus = Dict()
        for i=1:varNumber
                varStatus[i] = NaN
                varStatus[-i] = NaN
        end   # Put more stuff here later

        #varClause = Dict(1=>clauseList[1],
        #                 2=>clauseList[1],
        #                 3=>clauseList[1],
        #                 4=>clauseList[2],
        #                 5=>clauseList[2],
        #                 6=>clauseList[2],
        #                 7=>[clauseList[3],clauseList[4]]
        #                 )
        #for i = 1:varNumber
        #        for j = 1:length(clauseList)
        #                for n = 1:length(clauseList[j])
        #                        if clauseList[j][n] == i
        #                                varClause[i] =
        #
        #end

        clauseStatus = Dict()
        for i=1:length(clauseList)
                clauseStatus[clauseList[i]] = NaN
        end


end

function useRandomData(clauseNumber::Int, variableNumber::Int, variablesPerClause::Int)
        global i = 1; # Used to find next variable
        global varNumber = variableNumber; # Don't forget to change this
        global varPrev = 0; # Used in singlet optimization

        global numtries = 0;

        global clauseList = [];

        for m in 1:clauseNumber

                push!(clauseList,randperm(variableNumber)[1:variablesPerClause] .* sample([-1,1], variablesPerClause))

        end

        global varStatus = Dict()
        for i=1:varNumber
                varStatus[i] = NaN
                varStatus[-i] = NaN
        end   # Put more stuff here later

        global clauseStatus = Dict()
        for i=1:length(clauseList)
                clauseStatus[clauseList[i]] = NaN
        end


end



function solveT()
        println(varStatus)
        println(clauseStatus)
        global i = 1
        while varStatus[i] !== NaN
                global i += 1;
                if i>length(varStatus)/2
                        println(keys(varStatus), values(varStatus))
                        return true, numtries
                end

        end



        varNext = i;
        #if typeof(checkForSinglets()) == Int64
        #        varNext = checkForSinglets();
        #end
        #if typeof(varNext) == Bool # Failsafe in case somehow varNext becomes false
        #        varNext = i
        #end


        for m in [true, false]
                if varStatus[i] === NaN
                        worked, varSet, clauseSet = reduceC(varNext, m)
                else
                        println(keys(varStatus), values(varStatus))
                        println(clauseStatus)
                        return true, numtries
                end
                if worked
                        complete, tries = solveT()
                        if complete

                                return complete, tries
                        end
                else


                        for i in clauseSet
                                clauseStatus[clauseList[i]] = NaN
                        end

                        for i in 1:length(varSet)
                                println("VarSet:")
                                println(varSet)
                                println("ClauseList")
                                println(clauseList)

                                varStatus[varSet[i][1]] = NaN
                                varStatus[-varSet[i][1]] = NaN
                                delete!(clauseStatus, clauseList[varSet[i][2]])
                                push!(clauseList[varSet[i][2]],varSet[i][1]) # This line is sus, check later
                                println(varSet[i][2])
                                global clauseStatus[clauseList[varSet[i][2]]] = NaN
                                println("Missing clause?")
                                println(clauseList[varSet[i][2]])
                        end
                end
        end

        return false, numtries



end
