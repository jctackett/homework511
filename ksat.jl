## Global Variables
i = 1; # Used to find next variable
varNumber = 7; # Don't forget to change this
varPrev = 0; # Used in singlet optimization

clauseList = [[1,2,3],[4,5,6],[7],[-7]];
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

numtries = 0;

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
                if clauseStatus[clauseList[i]] == true # If clause status is true, we're done with this one
                        nothing
                else
                        for j=1:length(clauseList[i]) # Checking each element of clause
                                println(j)
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
                                        else
                                                return false, varSet, clauseSet
                                        end
                                end
                        end
                end
        end
        return true, varSet, clauseSet
end


function checkForSinglets()

        for n = 1:length(clauseList)
                if clauseStatus[clauseList[n]] === NaN
                        if length(clauseList[n]) == 1
                                return n
                        end
                end
        end
        return false

end



function solveT()
        println(varStatus)
        global i = 1
        while varStatus[i] !== NaN
                global i += 1;
                if i>length(varStatus)/2
                        println(keys(varStatus), values(varStatus))
                        return true, numtries
                end

                println(i)
        end



        varNext = i;
        if typeof(checkForSinglets()) == Int64
                if checkForSinglets() == varPrev
                        nothing
                else
                        varNext = checkForSinglets();
                        global varPrev = varNext;
                end
        end


        for m in [true, false]
                if varStatus[i] === NaN
                        worked, varSet, clauseSet = reduceC(varNext, m)
                else
                        println(keys(varStatus), values(varStatus))
                        return true, numtries
                end
                if worked
                        complete, tries = solveT()
                        if complete

                                return complete, tries
                        end
                else
                        varStatus[i] = NaN
                        varStatus[-i] = NaN

                        for i in clauseSet
                                clauseStatus[clauseList[i]] = NaN
                        end

                        for i in 1:length(varSet)
                                push!(clauseList[varSet[i][2]],varSet[i][1]) # This line is sus, check later
                                delete!(clauseStatus, varSet[i][2])
                                global clauseStatus[clauseList[varSet[i][2]]] = NaN
                        end
                end
        end

        return false, numtries



end
