function GtkGameInitialize!(Window::GtkWindowLeaf, Canvas::GtkCanvas, Label::GtkLabelLeaf, BoardTable::Board)
    BoardInitialize!(BoardTable)
    GtkWindowInitialize!(Canvas)
    GtkLabelUpdate!(Label, BoardTable)
    showall(Window)
end

function GtkStartGame(; Ratio::Real = 1.5)
    Flag = false
    PixelXNumber = trunc(Int64, 600 * Ratio)
    PixelYNumber = trunc(Int64, 670 * Ratio)

    Canvas = @GtkCanvas
    Label = GtkLabel("Start")
    Window = GtkWindow("", PixelXNumber, PixelYNumber)
    Hbox = GtkBox(:v)
    set_gtk_property!(Window, :resizable, false)
    push!(Window, Hbox)
    push!(Hbox, Canvas)
    push!(Hbox, Label)

    sc = GAccessor.style_context(Label)
    pr = CssProviderLeaf(data = "#Status {font-size: $(15*Ratio)px;
    font-family: sans-serif;
    font-weight: bold;
    color: white;
    background: #242424;}")
    push!(sc, StyleProvider(pr), PixelXNumber)

    set_gtk_property!(Label, :name, "Status")
    set_gtk_property!(Canvas, "width-request", PixelXNumber)
    set_gtk_property!(Canvas, "height-request", PixelXNumber)
    set_gtk_property!(Hbox, :fill, Canvas, true)
    set_gtk_property!(Hbox, :expand, Label, true)

    BoardTable = Board()
    GtkGameInitialize!(Window, Canvas, Label, BoardTable)

    Canvas.mouse.button1press = @guarded (widget, event) -> begin
        if Flag
            GtkGameInitialize!(Window, Canvas, Label, BoardTable)
            Flag = false
        else
            N = 15
            CTX = getgc(widget)
            H = Gtk.ShortNames.height(CTX)
            Space = H / N

            X, Y = Int(div(event.x, Space)), Int(div(event.y, Space))
            X += 1
            Y += 1

            if BoardTable.Table[X, Y] == 0
                BoardTable.Table[X, Y] = BoardTable.CurrentPlayer
                GtkWindowUpdate!(Canvas, BoardTable)
                Flag = BoardCheckWin(BoardTable)
                if !Flag
                    BoardTable.CurrentTurn += 1
                    BoardTable.CurrentPlayer = -BoardTable.CurrentPlayer
                end
                GtkLabelUpdate!(Label, BoardTable)
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