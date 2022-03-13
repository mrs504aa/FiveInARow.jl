function WindowInitialize!(Canvas::GtkCanvas)
    @guarded draw(Canvas) do widget
        N = 15
        CTX = getgc(Canvas)
        H = height(Canvas)
        W = width(Canvas)
        space = H / N
        r = space / 2

        rectangle(CTX, 0, 0, W, H)
        set_source_rgb(CTX, 246 / 255, 204 / 255, 119 / 255)
        fill(CTX)

        for x in 1:N
            move_to(CTX, x * W / N, 0)
            line_to(CTX, x * W / N, H)
        end
        for y in 1:(N)
            move_to(CTX, 0, y * W / N)
            line_to(CTX, W, y * W / N)
        end
        set_source_rgb(CTX, 0, 0, 0)
        stroke(CTX)
        reveal(widget)
    end
    show(Canvas)
end

function WindowUpdate!(Canvas::GtkCanvas, BoardTable::Board)
    @guarded draw(Canvas) do widget
        N = 15
        CTX = getgc(Canvas)
        H = height(Canvas)
        W = width(Canvas)
        Space = H / N
        R = Space / 2
        C = zeros(Float64, 2)
        C[1] = 0.0
        C[2] = 1.0

        for X in 1:N, Y in 1:N
            if BoardTable.Table[X, Y] != 0
                Ind = BoardTable.Table[X, Y]
                (Ind == -1) ? (Ind = 2) : ()

                set_source_rgb(CTX, 0.5, 0.5, 0.5)
                arc(CTX, (X - 1) * Space + R, (Y - 1) * Space + R, 0.8 * R, 0, 2pi)
                fill(CTX)

                set_source_rgb(CTX, C[Ind], C[Ind], C[Ind])
                arc(CTX, (X - 1) * Space + R, (Y - 1) * Space + R, 0.75 * R, 0, 2pi)
                fill(CTX)
            end
        end
        reveal(widget)
    end
end

function LabelUpdate!(Label::GtkLabelLeaf, BoardTable::Board)
    S1 = "Current Turn: $(BoardTable.CurrentTurn)\n"
    (BoardTable.CurrentPlayer==1) ? (CurrentPlayer = "Black") : (CurrentPlayer = "White")
    S2 = "Current Player: $(CurrentPlayer)\n"
    GAccessor.text(Label, join([S1, S2]))
end