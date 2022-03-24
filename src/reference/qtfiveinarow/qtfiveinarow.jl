ENV["QSG_RENDER_LOOP"] = "basic"

using QML
using Qt5QuickControls2_jll
using Observables
using ColorTypes
import CxxWrap

const qmlfile = "qtfiveinarow.qml"

Ratio = 1.5

WindowWidth = Observable(trunc(Int64, 600 * Ratio))
WindowHeight = Observable(trunc(Int64, 700 * Ratio))

loadqml(qmlfile, parameters=JuliaPropertyMap("WindowWidth" => WindowWidth, "WindowHeight" => WindowHeight))

exec()