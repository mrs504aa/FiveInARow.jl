function BoardInitialize!(BoardTable::Board)
    N = 15
    Table = zeros(Int64, 15, 15)
    CurrentTurn = 1
    FirstPlayer = 1
    CurrentPlayer = FirstPlayer
    BoardTable.Table = Table
    BoardTable.CurrentTurn = 1
    BoardTable.CurrentPlayer = 1
    BoardTable.FirstPlayer = 1
    return BoardTable
end

function BoardCheckWin(BoardTable::Board)
    M = BoardTable.Table
    N = 15
    for X in 1:N
        for Y in 1:N
            (M[X, Y] == 0) ? (continue) : ()

            if X + 4 <= N
                S = sum(sum(M[X:X+4, Y]))
                (abs(S) == 5) ? (return true) : ()
            end

            if Y + 4 <= N
                S = sum(M[X, Y:Y+4])
                (abs(S) == 5) ? (return true) : ()
            end

            if (X + 4 <= N) & (Y + 4 <= N)
                S = 0
                for k in 0:4
                    S += sum(M[X+k, Y+k])
                end
                (abs(S) == 5) ? (return true) : ()
            end

            if (X + 4 <= N) & (Y - 4 >= 1)
                S = 0
                for k in 0:4
                    S += sum(M[X+k, Y-k])
                end
                (abs(S) == 5) ? (return true) : ()
            end
        end
    end
    return false
end