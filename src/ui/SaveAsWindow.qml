import QtQuick 2.3
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1

ApplicationWindow {
	id: _window
	visible: false
	width: 300
	height: _path.height + 1
	property alias path: _path.text
	signal execSave()
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
			text: "Save"
			onClicked: {
				_window.execSave()
				_window.close()
			}
		}
	}
	onExecSave: {
		if (nps.save_as(path, getCellArray())) {
			_mainwindow.fileOpened = true
			_mainwindow.currentFile = path
		} else {
			console.log("ファイルを保存できませんでした", path)
		}
	}
}

