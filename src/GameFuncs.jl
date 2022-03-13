function GameInitialize!(Canvas::GtkCanvas, BoardTable::Board)
    BoardInitialize!(BoardTable)
    WindowInitialize!(Canvas)
end

function StartGame()
    Flag = false
    PixelNumber = 700
    Canvas = @GtkCanvas
    Window = GtkWindow("", PixelNumber, PixelNumber)
    push!(Window, Canvas)

    BoardTable = Board()
    GameInitialize!(Canvas, BoardTable)


    Canvas.mouse.button1press = @guarded (widget, event) -> begin
        if Flag
            GameInitialize!(Canvas, BoardTable)
            Flag = false
        else
            N = 15
            CTX = getgc(widget)
            H = height(CTX)
            Space = H / N

            X, Y = Int(div(event.x, Space)), Int(div(event.y, Space))
            X += 1
            Y += 1

            if BoardTable.Table[X, Y] == 0
                BoardTable.Table[X, Y] = BoardTable.CurrentPlayer
                WindowUpdate!(Canvas, BoardTable)
                Flag = BoardCheckWin(BoardTable)
                if !Flag
                    @show BoardTable.CurrentTurn, BoardTable.CurrentPlayer
                    BoardTable.CurrentTurn += 1
                    BoardTable.CurrentPlayer = -BoardTable.CurrentPlayer
                else
                    println("Player win!")
                end
            end
        end
    end

    if !isinteractive()
        cond = Condition()
        signal_connect(Window, :destroy) do widget
            notify(cond)
        end
        wait(cond)
    end
end