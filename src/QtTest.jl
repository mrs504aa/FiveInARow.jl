ENV["QSG_RENDER_LOOP"] = "basic"

using QML
using Qt5QuickControls2_jll
using Observables
using ColorTypes
import CxxWrap

include("BoardFuncs.jl")

BoardTable = Board()
BoardInitialize!(BoardTable)

QmlFile = "QtGame.qml"

Ratio = 1.5

WindowWidth = Observable(trunc(Int64, 600 * Ratio))
WindowHeight = Observable(trunc(Int64, 700 * Ratio))
PointerX = Observable(-600.0 * Ratio / 15)
PointerY = Observable(-600.0 * Ratio / 15)

function QtWindowUpdate(buffer::Array{UInt32,1},
    width32::Int32,
    height32::Int32)
    width::Int = width32
    height::Int = height32
    buffer = reshape(buffer, width, height)
    buffer = reinterpret(ARGB32, buffer)
    PaintCircle(buffer)
end

function PaintCircle(buffer)
    width, height = size(buffer)
    Space = width / 15
    center_x = (div(PointerX[], Space) + 0.5) * Space
    center_y = (div(PointerY[], Space) + 0.5) * Space
    rad1 = (Space / 2 * 0.8)^2
    rad2 = (Space / 2 * 0.75)^2
    for x in 1:width
        for y in 1:height
            if (x - center_x)^2 + (y - center_y)^2 < rad2
                buffer[x, y] = ARGB32(203 / 255, 60 / 255, 51 / 255, 1)
            elseif (x - center_x)^2 + (y - center_y)^2 < rad1
                buffer[x, y] = ARGB32(0.5, 0.5, 0.5, 1)
            else
                buffer[x, y] = ARGB32(245 / 255, 203 / 255, 119 / 255, 1)
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
    paint_cfunction=CxxWrap.@safe_cfunction(QtWindowUpdate, Cvoid,
        (Array{UInt32,1}, Int32, Int32)))

exec()

@show PointerX[]