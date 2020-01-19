import QtQuick 2.3
import QtQuick.Controls 1.4

Menu {
    title: "Option"
    MenuItem {
        text: "Settings"
        onTriggered: {
            _SettingWindow.show()
            _SettingWindow.requestActivate()
        }
    }
}
