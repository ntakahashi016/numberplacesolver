import QtQuick 2.3
import QtQuick.Controls 1.4

Menu {
    title: "File"
    MenuItem {
        text: "New"
        shortcut: "Ctrl+n"
        onTriggered: {
            unlockAllCells()
            clearAllCell()
            _mainwindow.fileOpened = false
            _mainwindow.currentFile = ""
        }
    }
    MenuItem {
        text: "Open"
        shortcut: "Ctrl+o"
        onTriggered: {
            _OpenWindow.show()
            _OpenWindow.requestActivate()
        }
    }
    MenuItem {
        text: "Save"
        shortcut: "Ctrl+s"
        onTriggered: {
            if (_mainwindow.fileOpened == true) {
                nps.save_as(_mainwindow.currentFile, getCellArray())
            } else {
                _SaveAsWindow.show()
                _SaveAsWindow.requestActivate()
            }
        }
    }
    MenuItem {
        text: "Save as"
        onTriggered: {
            _SaveAsWindow.show()
            _SaveAsWindow.requestActivate()
        }
    }
}
