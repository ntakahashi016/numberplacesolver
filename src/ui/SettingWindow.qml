import QtQuick 2.12
import QtQuick.Controls 2.1
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1

ApplicationWindow {
    id: _window
    visible: false
    width: 500
    height: 500
    ColumnLayout {
        ButtonGroup {
            id: childGroup
            exclusive: false
            checkState: parentBox.checkState
        }
        CheckBox {
            id: parentBox
            text: "Parent"
            checked: true
            checkState: childGroup.checkState
        }
        CheckBox {
            text: "LastDigit"
            ButtonGroup.group: childGroup
        }
        CheckBox {
            text: "FullHouse"
            ButtonGroup.group: childGroup
        }
        CheckBox {
            text: "NakedSingle"
            ButtonGroup.group: childGroup
        }
        CheckBox {
            text: "HiddenSingle"
            ButtonGroup.group: childGroup
        }
        CheckBox {
            text: "LockedCandidatesType1"
            ButtonGroup.group: childGroup
        }
        CheckBox {
            text: "LockedCandidatesType2Row"
            ButtonGroup.group: childGroup
        }
        CheckBox {
            text: "LockedCandidatesType2Cul"
            ButtonGroup.group: childGroup
        }
        CheckBox {
            text: "HiddenSubstes"
            ButtonGroup.group: childGroup
        }
        CheckBox {
            text: "NakedSubsets"
            ButtonGroup.group: childGroup
        }
    }
}
