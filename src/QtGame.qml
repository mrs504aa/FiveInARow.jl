import QtQuick 2.6
import QtQuick.Window 2.2
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.0
import org.julialang 1.0

ApplicationWindow {
    visible: true

    width: parameters.WindowWidth
    height: parameters.WindowHeight

    maximumHeight: height
    maximumWidth: width
    minimumHeight: height
    minimumWidth: width

    title: qsTr("FiveInARow")
    ColumnLayout {
        anchors.fill: parent

        JuliaCanvas {
                Layout.minimumWidth: width
                Layout.minimumHeight: width

                Rectangle {
                    color: "#F5CB77"
                    width: parameters.WindowWidth
                    height: parameters.WindowWidth
                }

                Repeater {
                    model: 16
                    Rectangle {
                        color: "#000000"
                        y: parameters.WindowWidth / 15 * index
                        width: parameters.WindowWidth
                        height: parameters.WindowWidth / 600
                    }
                }

                Repeater {
                    model: 16
                    Rectangle {
                        color: "#000000"
                        x: parameters.WindowWidth / 15 * index
                        width: parameters.WindowWidth / 600
                        height: parameters.WindowWidth 
                    }
                }
            }
        }

        Rectangle {
            y: parameters.WindowWidth
            width: parameters.WindowWidth
            height: parameters.WindowHeight - parameters.WindowWidth
            color: "#242424"
        }
}
