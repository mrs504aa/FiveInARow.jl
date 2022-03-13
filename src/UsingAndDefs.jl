using Graphics
using Gtk, Gtk.ShortNames

mutable struct Board
    Table::Matrix{Int64}
    CurrentTurn::Int64
    CurrentPlayer::Int64
    FirstPlayer::Int64
    Board() = new()
end