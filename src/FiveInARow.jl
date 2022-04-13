module FiveInARow

include("BoardFuncs.jl")

include("GtkUsingAndDefs.jl")
include("GtkWindowFuncs.jl")
include("GtkGameFuncs.jl")

include("QtUsingAndDefs.jl")
include("QtGameFuncs.jl")

export GtkStartGame, QtStartGame

end
