import QtQuick 2.3
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1
import NumberPlaceSolver 1.0
import './'

ApplicationWindow {
	id: _mainwindow
	visible: true
	width: 600
	height: 500

	property int currentIndex: -1 /*選択中のセルのインデックス。負数は未選択状態*/
	property bool fileOpened: false /*現在ファイルを開いた状態かどうかを示す*/
	property string currentFile: "" /*現在開いているファイルのパス*/
	property int cellAreaWidth: 30
	property int cellAreaHeight: 30
	property int frameWidth: 2

	property var result: new Array /*Solverから受け取った解を保存する*/

	/* セルの数を取得する */
	function getCellCount() {
		return _CellAreas.count;
	}

	/* 選択中のセルの文字列を取得する */
	function setCurrentCellText(text) {
		if (currentIndex >= 0) {
			_CellAreas.itemAt(currentIndex).text = text;
		}
	}

	/* 選択中のセルの文字列を消去する */
	function clearCurrentCell() {
		if (currentIndex >= 0) {
			_CellAreas.itemAt(currentIndex).text = "";
		}
	}

	/* すべてのセルの文字列を消去する */
	function clearAllCell() {
		for (var i=0; i<getCellCount(); i++) {
			_CellAreas.itemAt(i).text = "";
		}
	}

	/* セルをクリックした際に他のセルの選択状態を解除する */
	function cellClicked(index) {
		for (var i=0; i<getCellCount(); i++) {
			if (i==index){
				//何もしない
			}else{
				_CellAreas.itemAt(i).checked = false;
			}
		}
	}

	/* すべてのセルを１次元の配列として取得する */
	/* 空のセルは空文字列"" */
	function getCellArray() {
		var cellarray = new Array
		for (var i=0; i<getCellCount(); i++) {
			cellarray.push(_CellAreas.itemAt(i).text);
		}
		return cellarray;
	}

	/* １次元の配列からすべてのセルを入力する */
	function setCellArray(cellarray) {
		for (var i=0; i<getCellCount(); i++) {
			if (cellarray[i]==null) {
				_CellAreas.itemAt(i).text = ""
			} else {
				_CellAreas.itemAt(i).text = cellarray[i];
			}
		}
	}

	RowLayout {
		id: _MainContents
		GridLayout {
			id: _CellAreasGrid
			columns: nps.board_x
			columnSpacing: frameWidth
			rowSpacing: frameWidth
			anchors.top: parent.top
			anchors.topMargin: 10
			anchors.left: parent.left
			anchors.leftMargin: 10
			Repeater {
				id: _CellAreas
				model: nps.num_of_cells
				MouseArea{
					id: _CellArea
					width: cellAreaWidth
					height: cellAreaHeight
					hoverEnabled: true
					property alias text: _label.text
					property bool checked: false
					onClicked: {
						if (checked == true) {
							currentIndex = -1;
						}else{
							currentIndex = index;
						}
						checked = !checked;
						cellClicked(index);
					}
					Rectangle {
						id: _bg
						anchors.fill: parent
						border.width: 0
						color: {
							var y = Math.floor(index/nps.board_x)
							var x = index%nps.board_x
							var n = nps.num_type
							var box_size = Math.floor(Math.sqrt(nps.num_type))
							var union_level = nps.union_level
							if (y < (n+(n-box_size*union_level)*Math.floor(x/(n-box_size*union_level))) &&
								x < (n+(n-box_size*union_level)*Math.floor(y/(n-box_size*union_level)))) {
								"#FFFFFF";
							}else{
								"#888888";
							}
						}
						Text{
							id: _label
							anchors.centerIn: parent
							text: ""
						}
					}
					states: [
						State {
							name: "Press"
							when: _CellArea.pressed
							PropertyChanges {
								target: _bg
								color: "#ddaaaa"
								border.color: "#dd0000"
							}
						}
						, State {
							name: "Checked"
							when: checked
							PropertyChanges {
								target: _bg
								border.width: 2
								border.color: "#FF0000"
							}
						}
						, State {
							name: "Hover"
							when: _CellArea.containsMouse
							PropertyChanges {
								target: _bg
								color: "#8888dd"
							}
						}
					]
				}
			}
		}
		ColumnLayout {
			anchors.top: parent.top
			anchors.topMargin: 10
			anchors.left: _CellAreasGrid.right
			anchors.leftMargin: 10
			GridLayout {
				columns: nps.panel_x
				Repeater {
					id: _NumPanel
					model: nps.num_type
					Button {
						text: index+1
						property int num: index+1
						style: ButtonStyle {
							background: Rectangle {
								implicitWidth: 50
							}
						}
						onClicked: setCurrentCellText(num)
					}
				}
			}
			Button {
				text: "clear"
				onClicked: clearCurrentCell()
			}
			RowLayout {
				Button {
					text: "AllClear"
					onClicked: clearAllCell()
				}
				Button {
					text: "Solve"
					onClicked: {
						/* NumberPlaceSolverにセルの配列を与えて解を求める */
						nps.set_cellarray(getCellArray());
						result = nps.solve();
						/* 求めた解をセルに戻して表示する */
						setCellArray(result);
					}
				}
			}
			GroupBox {
				title: "Number type"
				RowLayout {
					ExclusiveGroup { id: numberTypeGroup }
					RadioButton {
						text: "4x4"
						exclusiveGroup: numberTypeGroup
						onClicked: {
							nps.setBoardType(4)
						}
					}
					RadioButton {
						text: "9x9"
						checked: true
						exclusiveGroup: numberTypeGroup
						onClicked: {
							nps.setBoardType(9)
						}
					}
					RadioButton {
						text: "16x16"
						exclusiveGroup: numberTypeGroup
						onClicked: {
							nps.setBoardType(16)
						}
					}
				}
			}
			GroupBox {
				title: "Board type"
				RowLayout {
					ExclusiveGroup { id: boardTypeGroup }
					RadioButton {
						text: "Standard"
						checked: true
						exclusiveGroup: boardTypeGroup
						onClicked: {
							nps.select_board_factory("standard")
						}
					}
					RadioButton {
						text: "Diagonal"
						exclusiveGroup: boardTypeGroup
						onClicked: {
							nps.select_board_factory("diagonal")
						}
					}
					RadioButton {
						text: "Union"
						exclusiveGroup: boardTypeGroup
						onClicked: {
							nps.select_board_factory("union")
						}
					}
				}
			}
			GroupBox {
				title: "UnionBoard options"
				RowLayout {
					Text { text: "Level" }
					ComboBox {
						id: _unionLevelComboBox
						model: ListModel {
							id: _unionLevel
							ListElement { text: "1" }
							ListElement { text: "2" }
							ListElement { text: "3" }
						}
						onCurrentIndexChanged: nps.set_union_level(_unionLevel.get(currentIndex).text)
					}
					Text { text: "Num"}
					ComboBox {
						id: _unionBoardNumComboBox
						model: ListModel {
							id: _unionBoardNum
							ListElement { text: "1" }
							ListElement { text: "2" }
							ListElement { text: "3" }
						}
						onCurrentIndexChanged: nps.set_union_num(_unionBoardNum.get(currentIndex).text)
					}
				}
			}
			RowLayout {
				Text { text: "Solver" }
				ComboBox {
					id: _SolverComboBox
					model: ListModel {
						id: _Solver
						ListElement { text: "StandardAndBacktrack" }
						ListElement { text: "Standard" }
						ListElement { text: "Backtrack" }
					}
					onCurrentIndexChanged: nps.select_solver(_Solver.get(currentIndex).text)
				}
			}
		}
		GridLayout {
			id: _FrameGrid
			anchors.top: _CellAreasGrid.top
			anchors.topMargin: -frameWidth
			anchors.left: _CellAreasGrid.left
			anchors.leftMargin: -frameWidth
			property int ulevel : Number(_unionLevel.get(_unionLevelComboBox.currentIndex).text)
			property int ubnum  : Number(_unionBoardNum.get(_unionBoardNumComboBox.currentIndex).text)
			property int sqrtFrameNum: Math.sqrt(nps.num_type)
			columns: sqrtFrameNum + (sqrtFrameNum - ulevel) * (ubnum - 1)
			columnSpacing: -frameWidth
			rowSpacing: -frameWidth
			Repeater {
				id: _Frames
				model: nps.num_of_cells / nps.num_type
				Rectangle{
					id: _Frame
					color: "transparent"
					border.width: frameWidth
					border.color: "#000000"
					width: (cellAreaWidth + _CellAreasGrid.columnSpacing) * Math.sqrt(nps.num_type) + frameWidth
					height: (cellAreaHeight + _CellAreasGrid.rowSpacing) * Math.sqrt(nps.num_type) + frameWidth
				}
			}
		}
	}

	menuBar: MenuBar {
		Menu {
			title: "File"
			MenuItem {
				text: "New"
				shortcut: "Ctrl+n"
				onTriggered: {
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
	}

	OpenWindow {
		id: _OpenWindow
		onExecOpen: {
			result = nps.open(path)
			if (result != []) {
				_mainwindow.fileOpened = true
				_mainwindow.currentFile = path
				setCellArray(result)
			} else {
				console.log("ファイルを開けませんでした", path)
			}
		}
	}

	SaveAsWindow {
		id: _SaveAsWindow
		onExecSave: {
			if (nps.save_as(path, getCellArray())) {
				_mainwindow.fileOpened = true
				_mainwindow.currentFile = path
			} else {
				console.log("ファイルを保存できませんでした", path)
			}
		}
	}

	/* NumberPlaceSolverの実体をエレメント化 */
	NumberPlaceSolver {
		id: nps
	}
}
