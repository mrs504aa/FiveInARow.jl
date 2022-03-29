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
        anchors.fill: parent
        id: board
        width: parent.width
        height: parent.width
        paintFunction: paint_cfunction
    }

    MouseArea{
        width: parent.width
        height: parent.width
        id: mouseArea
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

    Rectangle {
        y: Parameters.WindowWidth
        width: Parameters.WindowWidth
        height: Parameters.WindowHeight - Parameters.WindowWidth
        color: "#242424"
        Text {
            id: myText
            anchors.fill:parent
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            smooth: true
            color: "#FFFFFF"
            font.family: "sans-serif"
            font.weight: Font.Bold;
            font.pointSize: 15 * parent.width / 900
            text: qsTr("Current Turn: %1\nCurrent Player: %2").arg(BoardTable.CurrentTurn).arg(BoardTable.CurrentPlayer)
        }
    }

    Connections {
		target: mouseArea
		function onClicked(mouse) { 
                    Position.PointerX = mouse.x;
                    Position.PointerY = mouse.y;
                    board.update();
                    myText.update(); }
	}
}
