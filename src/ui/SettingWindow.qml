import QtQuick 2.12
import QtQuick.Controls 2.1
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1
import QtQuick.Window 2.12

Window {
    id: _window
    visible: false
    width: 500
    height: 500
    modality: Qt.ApplicationModal
    ColumnLayout {
        Label {
            text: "Solving Strategies"
        }
        ButtonGroup {
            id: childGroup
            exclusive: false
            checkState: parentBox.checkState
        }
        CheckBox {
            id: parentBox
            text: "All"
            checked: true
            checkState: childGroup.checkState
        }
        CheckBox {
            id: lastDigit
            text: "LastDigit"
            leftPadding: indicator.width
            ButtonGroup.group: childGroup
        }
        CheckBox {
            id: fullHouse
            text: "FullHouse"
            leftPadding: indicator.width
            ButtonGroup.group: childGroup
        }
        CheckBox {
            id: nakedSingle
            text: "NakedSingle"
            leftPadding: indicator.width
            ButtonGroup.group: childGroup
        }
        CheckBox {
            id: hiddenSingle
            text: "HiddenSingle"
            leftPadding: indicator.width
            ButtonGroup.group: childGroup
        }
        CheckBox {
            id: lockedCandidatesType1
            text: "LockedCandidatesType1"
            leftPadding: indicator.width
            ButtonGroup.group: childGroup
        }
        CheckBox {
            id: lockedCandidatesType2Row
            text: "LockedCandidatesType2Row"
            leftPadding: indicator.width
            ButtonGroup.group: childGroup
        }
        CheckBox {
            id: lockedCandidatesType2Cul
            text: "LockedCandidatesType2Cul"
            leftPadding: indicator.width
            ButtonGroup.group: childGroup
        }
        CheckBox {
            id: hiddenSubsets
            text: "HiddenSubstes"
            leftPadding: indicator.width
            ButtonGroup.group: childGroup
        }
        CheckBox {
            id: nakedSubsets
            text: "NakedSubsets"
            leftPadding: indicator.width
            ButtonGroup.group: childGroup
        }
        CeckBox {
            id: backtrack
            text: "Backtrack"
            leftPadding: indicator.width
            ButtonGroup.group: childGroup
        }
    }
}
