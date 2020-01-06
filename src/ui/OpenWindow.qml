import QtQuick 2.3
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1

ApplicationWindow {
	id: _window
	visible: false
	width: 300
	height: _path.height + 2
	property alias path: _path.text
	signal execOpen()
	RowLayout {
		TextField {
			id: _path
			anchors.left: parent.left
			width: _window.width - _button.width
			placeholderText: "File path ..."
			focus: true
		}
		Button {
			id: _button
			anchors.left: _path.right
			text: "Open"
			onClicked: {
				_window.execOpen()
				_window.close()
			}
		}
	}
	onExecOpen: {
		result = nps.open(path)
		if (result != []) {
			_mainwindow.fileOpened = true
			_mainwindow.currentFile = path
            unlockAllCells()
			setCellArray(result)
            lockInputtedCells()
            editMode = false
		} else {
			console.log("ファイルを開けませんでした", path)
		}
	}
}

