include("src/FiveInARow.jl")

F = Main.FiveInARow
# F.GtkStartGame()
ENV["QSG_RENDER_LOOP"] = "basic"
F.QtStartGame()