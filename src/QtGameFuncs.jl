if basename(PROGRAM_FILE) == basename(@__FILE__)
    include("QtUsingAndDefs.jl")
    include("BoardFuncs.jl")
end

Base.@kwdef mutable struct QtObservables
    WindowWidth = Observable(0)
    WindowHeight = Observable(0)
    PointerX = Observable(0)
    PointerY = Observable(0)
    CPlayer = Observable(0)
    CTurn = Observable(0)
end

function QtWindowUpdate(buffer::Array{UInt32,1}, width32::Int32, height32::Int32)
    width::Int = width32
    height::Int = height32
    buffer = reshape(buffer, width, height)
    buffer = reinterpret(ARGB32, buffer)
    Space = width / 15
    X = trunc(Int64, div(ObCollection.PointerX[], Space)) + 1
    Y = trunc(Int64, div(ObCollection.PointerY[], Space)) + 1

    if QtBoardTable.RestartFlag

        PaintBoard(buffer, QtBoardTable)
        ObCollection.CTurn[] = QtBoardTable.CurrentTurn
        ObCollection.CPlayer[] = QtBoardTable.CurrentPlayer

        QtBoardTable.RestartFlag = false

    elseif QtBoardTable.Table[X, Y] == 0

        QtBoardTable.Table[X, Y] = QtBoardTable.CurrentPlayer
        PaintBoard(buffer, QtBoardTable)

        Flag = BoardCheckWin(QtBoardTable)

        if !Flag
            QtBoardTable.CurrentTurn += 1
            QtBoardTable.CurrentPlayer = -QtBoardTable.CurrentPlayer

            ObCollection.CTurn[] = QtBoardTable.CurrentTurn
            ObCollection.CPlayer[] = QtBoardTable.CurrentPlayer + 3 * (QtBoardTable.CurrentPlayer == -1)
        else
            BoardInitialize!(QtBoardTable)
        end
    else
        PaintBoard(buffer, QtBoardTable)
    end
    return
end

function PaintBoard(buffer, QtBoardTable::Board)
    width, height = size(buffer)
    Space = width / 15
    rad1 = (Space / 2 * 0.8)^2
    rad2 = (Space / 2 * 0.75)^2
    C = [0.0, 1.0]

    for x in 1:width-1
        for y in 1:width-1
            XIndex = trunc(Int64, div(x, Space)) + 1
            YIndex = trunc(Int64, div(y, Space)) + 1

            buffer[x, y] = ARGB32(245 / 255, 203 / 255, 119 / 255, 1)

            if QtBoardTable.Table[XIndex, YIndex] != 0
                Ind = QtBoardTable.Table[XIndex, YIndex]
                (Ind == -1) ? (Ind = 2) : ()

                center_x = (div(x, Space) + 0.5) * Space
                center_y = (div(y, Space) + 0.5) * Space

                if (x - center_x)^2 + (y - center_y)^2 < rad2
                    buffer[x, y] = ARGB32(C[Ind], C[Ind], C[Ind], 1)
                elseif (x - center_x)^2 + (y - center_y)^2 < rad1
                    buffer[x, y] = ARGB32(0.5, 0.5, 0.5, 1)
                end
            end
        end
    end
    return
end

function QtStartGame(; Ratio::Real=1.5)
    QmlFile = join([dirname(@__FILE__), "/QtGame.qml"])

    global ObCollection = QtObservables()
    global QtBoardTable = Board()

    BoardInitialize!(QtBoardTable)

    ObCollection.WindowWidth = Observable(trunc(Int64, 600 * Ratio))
    ObCollection.WindowHeight = Observable(trunc(Int64, 670 * Ratio))
    ObCollection.PointerX = Observable(-600.0 * Ratio / 15)
    ObCollection.PointerY = Observable(-600.0 * Ratio / 15)
    ObCollection.CPlayer = Observable(0)
    ObCollection.CTurn = Observable(0)

    loadqml(QmlFile,
        Parameters=JuliaPropertyMap(
            "WindowWidth" => ObCollection.WindowWidth,
            "WindowHeight" => ObCollection.WindowHeight),
        Position=JuliaPropertyMap(
            "PointerX" => ObCollection.PointerX,
            "PointerY" => ObCollection.PointerY),
        BoardTable=JuliaPropertyMap(
            "CurrentTurn" => ObCollection.CTurn,
            "CurrentPlayer" => ObCollection.CPlayer),
        paint_cfunction=CxxWrap.@safe_cfunction(QtWindowUpdate, Cvoid,
            (Array{UInt32,1}, Int32, Int32)))

    if isinteractive()
        @show 1 
        exec()
        readline()
    else
        exec()
    end
end

if basename(PROGRAM_FILE) == basename(@__FILE__)
    QtStartGame()
end