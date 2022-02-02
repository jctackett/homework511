## Global Variables
i = 1;

clauseList = [[1,2,3],[4,5,6],[7,8,9],[3,-4,1]];
varStatus = Dict(1=>NaN,
                 2=>NaN,
                 3=>NaN,
                 4=>NaN,
                 5=>NaN,
                 6=>NaN,
                 7=>NaN,
                 8=>NaN,
                 9=>NaN
                 ) # Put more stuff here later
for i in 1:length(varStatus)
        varStatus[-i] = NaN
end
varClause = Dict(1=>[clauseList[1], clauseList[4]],
                 2=>clauseList[1],
                 3=>[clauseList[1],clauseList[4]],
                 4=>clauseList[2],
                 5=>clauseList[2],
                 6=>clauseList[2],
                 7=>clauseList[3],
                 8=>clauseList[3],
                 9=>clauseList[3],
                 -4=>clauseList[4]
                 )
clauseStatus = Dict()
for i=1:4
        clauseStatus[clauseList[i]] = NaN
end

numtries = 0;

## Functions

function reduceC(varNext::Int, status)
        # Might need to throw in a ton of globals

        global numtries+=1;

        println("I tried to add to numtries")

        clauseSet = []; # Set of clauses set to true
        varSet = []; # Nested sets of following type: [valueDeleted, clauseNumber, elementNumber]




        global varStatus[varNext] = status;
        global varStatus[-varNext] = !status;

        # Going through the clauses and updating the statuses with new varNext status
        for i in 1:length(clauseList)
                if clauseStatus[clauseList[i]] == true # If clause status is true, we're done with this one
                        nothing
                else
                        for j=1:3 # Checking each element of clause
                                if varStatus[clauseList[i][j]] == true # If true, mark down for unwind and set clause to true
                                        global clauseStatus[clauseList[i]] = true;
                                        push!(clauseSet, i)
                                        println("Tried to make it true") # FIX_ME
                                elseif varStatus[clauseList[i][j]] == false # If false, take it out of clauses to reduce it down
                                        if length(clauseList[i]) > 1 # If this clause is about to be reduced to zero, we have failed this try
                                                push!(varSet,[clauseList[i][j],i,j])
                                                deleteat!(clauseList[i],j)
                                        else
                                                return false, varSet, clauseSet
                                        end
                                end
                        end
                end
        end
        return true, varSet, clauseSet
end



function solveT()

        global i = 1
        while varStatus[i] == true | false
                global i += 1;
                if i>length(varStatus)/2
                        println(varStatus)
                        return true, numtries
                end

                println(i)
        end

        println("I made it here") # FIX_ME

        varNext = i;

        for m in [true, false]
                worked, varSet, clauseSet = reduceC(varNext, m)
                if worked
                        complete, tries = solveT()
                        if complete

                                return complete, tries
                        end
                else
                        for i in clauseSet
                                clauseStatus[i] = NaN
                        end

                        for i in 1:length(varSet)
                                push!(clauseList[varSet[i][2]],varSet[i][1]) # This line is sus, check later
                        end
                end
        end

        return false, numtries



        #if reduce(varNext, true) == true # Unclear if reduce must be called again
        #        solve()
        #elseif reduce(varNext, false) == true
        #        solve()
        #else


end
