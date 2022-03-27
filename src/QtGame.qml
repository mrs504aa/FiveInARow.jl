import QtQuick 2.6
import QtQuick.Window 2.2
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.0
import org.julialang 1.0

ApplicationWindow {
    visible: true

    width: Parameters.WindowWidth
    height: Parameters.WindowHeight

    maximumHeight: height
    maximumWidth: width
    minimumHeight: height
    minimumWidth: width

    title: qsTr("FiveInARow")
  
    JuliaCanvas {
        Layout.minimumWidth: width
        Layout.minimumHeight: width

        Rectangle {
            color: "#F5CB77"
            width: Parameters.WindowWidth
            height: Parameters.WindowWidth
        }

        Repeater {
            model: 16
            Rectangle {
                color: "#000000"
                y: Parameters.WindowWidth / 15 * index
                width: Parameters.WindowWidth
                height: Parameters.WindowWidth / 600
            }
        }

        Repeater {
            model: 16
            Rectangle {
                color: "#000000"
                x: Parameters.WindowWidth / 15 * index
                width: Parameters.WindowWidth / 600
                height: Parameters.WindowWidth 
            }
        }

        MouseArea{
            anchors.fill: parent
            onClicked: {
                Position.PointerX = mouseX
                Position.PointerY = mouseY
                
            }
        }
    }

    Rectangle {
        y: Parameters.WindowWidth
        width: Parameters.WindowWidth
        height: Parameters.WindowHeight - Parameters.WindowWidth
        color: "#242424"
    }
   
}
