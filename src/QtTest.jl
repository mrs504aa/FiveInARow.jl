include("QtUsingAndDefs.jl")
include("BoardFuncs.jl")


Ratio = 1.5

QmlFile = "QtGame.qml"

BoardTable = Board()
BoardInitialize!(BoardTable)

WindowWidth = Observable(trunc(Int64, 600 * Ratio))
WindowHeight = Observable(trunc(Int64, 670 * Ratio))
PointerX = Observable(-600.0 * Ratio / 15)
PointerY = Observable(-600.0 * Ratio / 15)
CPlayer = Observable(0)
CTurn = Observable(0)

function QtWindowUpdate(buffer::Array{UInt32,1}, width32::Int32, height32::Int32)

    width::Int = width32
    height::Int = height32
    buffer = reshape(buffer, width, height)
    buffer = reinterpret(ARGB32, buffer)
    Space = width / 15
    X = trunc(Int64, div(PointerX[], Space)) + 1
    Y = trunc(Int64, div(PointerY[], Space)) + 1

    if BoardTable.RestartFlag

        PaintBoard(buffer, BoardTable)
        CTurn[] = BoardTable.CurrentTurn
        CPlayer[] = BoardTable.CurrentPlayer

        BoardTable.RestartFlag = false

    elseif BoardTable.Table[X, Y] == 0

        BoardTable.Table[X, Y] = BoardTable.CurrentPlayer
        PaintBoard(buffer, BoardTable)

        Flag = BoardCheckWin(BoardTable)

        if !Flag
            BoardTable.CurrentTurn += 1
            BoardTable.CurrentPlayer = -BoardTable.CurrentPlayer

            CTurn[] = BoardTable.CurrentTurn
            CPlayer[] = BoardTable.CurrentPlayer + 3 * (BoardTable.CurrentPlayer == -1)
        else
            BoardInitialize!(BoardTable)
        end
    else
        PaintBoard(buffer, BoardTable)
    end
    return
end

function PaintBoard(buffer, BoardTable::Board)
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

            if BoardTable.Table[XIndex, YIndex] != 0
                Ind = BoardTable.Table[XIndex, YIndex]
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

loadqml(QmlFile,
    Parameters=JuliaPropertyMap(
        "WindowWidth" => WindowWidth,
        "WindowHeight" => WindowHeight),
    Position=JuliaPropertyMap(
        "PointerX" => PointerX,
        "PointerY" => PointerY),
    BoardTable=JuliaPropertyMap(
        "CurrentTurn" => CTurn,
        "CurrentPlayer" => CPlayer),
    paint_cfunction=CxxWrap.@safe_cfunction(QtWindowUpdate, Cvoid,
        (Array{UInt32,1}, Int32, Int32)))

exec()