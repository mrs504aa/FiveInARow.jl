module FiveInARow

include("UsingAndDefs.jl")
include("BoardFuncs.jl")
include("WindowFuncs.jl")
include("GameFuncs.jl")

function julia_main()::Cint
    StartGame()
    return 0 
  end

export StartGame

end 
