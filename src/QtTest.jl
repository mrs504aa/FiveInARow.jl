ENV["QSG_RENDER_LOOP"] = "basic"

using QML
using Qt5QuickControls2_jll
using Observables
using ColorTypes
import CxxWrap

function PaintCircle(buffer::Array{UInt32,1},
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

    center_x = width / 2
    center_y = height / 2
    rad2 = (diameter[] / 2)^2
    for x in 1:width
        for y in 1:height
            if (x - center_x)^2 + (y - center_y)^2 < rad2
                buffer[x, y] = ARGB32(203 / 255, 60 / 255, 51 / 255, 1) #red
            else
                buffer[x, y] = ARGB32(24 / 255, 24 / 255, 24 / 255, 1) #black
            end
        end
    end
    return
end

const QmlFile = "QtGame.qml"

Ratio = 1.5

WindowWidth = Observable(trunc(Int64, 600 * Ratio))
WindowHeight = Observable(trunc(Int64, 700 * Ratio))
PointerX = Observable(0.0)
PointerY = Observable(0.0)

loadqml(QmlFile,
    Parameters=JuliaPropertyMap("WindowWidth" => WindowWidth,
        "WindowHeight" => WindowHeight,
        "PointerX" => PointerX,
        "PointerY" => PointerY),
    paint_cfunction=CxxWrap.@safe_cfunction(PaintCircle, Cvoid,
        (Array{UInt32,1}, Int32, Int32)))

exec()

@show PointerX[]