function GameInitialize!(Window::GtkWindowLeaf, Canvas::GtkCanvas, Label::GtkLabelLeaf, BoardTable::Board)
    BoardInitialize!(BoardTable)
    WindowInitialize!(Canvas)
    LabelUpdate!(Label, BoardTable)
    showall(Window)
end

function StartGame(; Ratio::Real = 1.5)
    Flag = false
    PixelXNumber = trunc(Int64, 600 * Ratio)
    PixelYNumber = trunc(Int64, 700 * Ratio)

    Canvas = @GtkCanvas
    Label = GtkLabel("")
    Window = GtkWindow("", PixelXNumber, PixelYNumber)
    Hbox = GtkBox(:v)
    set_gtk_property!(Window, :resizable, false)
    push!(Window, Hbox)
    push!(Hbox, Canvas)
    push!(Hbox, Label)

    set_gtk_property!(Canvas, "width-request", PixelXNumber)
    set_gtk_property!(Canvas, "height-request", PixelXNumber)
    sc = GAccessor.style_context(Label)
    pr = CssProviderLeaf(data = "#Status {background: #7FB8CA;}")
    push!(sc, StyleProvider(pr), PixelYNumber)
    set_gtk_property!(Label, :name, "Status")
    set_gtk_property!(Hbox, :fill, Canvas, true)
    set_gtk_property!(Hbox, :expand, Label, true)

    BoardTable = Board()
    GameInitialize!(Window, Canvas, Label, BoardTable)

    Canvas.mouse.button1press = @guarded (widget, event) -> begin
        if Flag
            GameInitialize!(Window, Canvas, Label, BoardTable)
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
                    BoardTable.CurrentTurn += 1
                    BoardTable.CurrentPlayer = -BoardTable.CurrentPlayer
                end
                LabelUpdate!(Label, BoardTable)
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