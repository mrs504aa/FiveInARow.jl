import QtQuick 2.6
import QtQuick.Window 2.2
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.0
import org.julialang 1.0

ApplicationWindow {
	visible: true
	width: parameters.WindowWidth
	height: parameters.WindowHeight
	title: qsTr("Julia Canvas")
	ColumnLayout {
		anchors.fill: parent

		}
}