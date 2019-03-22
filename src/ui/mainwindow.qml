import QtQuick 2.3
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1
import NumberPlaceSolver 1.0

ApplicationWindow {
	visible: true
	width: 500
	height: 600

	property int currentIndex: -1 /*選択中のセルのインデックス。負数は未選択状態*/
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
			_CellAreas.itemAt(i).text = cellarray[i];
		}
	}

	RowLayout {
		GridLayout {
			columns: nps.board_x
			Repeater {
				id: _CellAreas
				model: nps.num_of_cells
				MouseArea{
					id: _CellArea
					width: 30
					height: 30
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
						border.width: 1
						border.color: "#dddddd"
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
							name: "Hover"
							when: _CellArea.containsMouse
							PropertyChanges {
								target: _bg
								color: "#8888dd"
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
					]
				}
			}
		}
		ColumnLayout {
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
				title: "Type of Board"
				RowLayout {
					ExclusiveGroup { id: typeOfBoardGroup }
					RadioButton {
						text: "4x4"
						exclusiveGroup: typeOfBoardGroup
						onClicked: {
							nps.setBoardType(4)
						}
					}
					RadioButton {
						text: "9x9"
						checked: true
						exclusiveGroup: typeOfBoardGroup
						onClicked: {
							nps.setBoardType(9)
						}
					}
					RadioButton {
						text: "16x16"
						exclusiveGroup: typeOfBoardGroup
						onClicked: {
							nps.setBoardType(16)
						}
					}
				}
			}
			CheckBox {
				id: _diagonal
				text: "Diagonal"
				onClicked: {
					nps.set_diagonal_type(_diagonal.checked)
				}
			}
		}
	}

	/* NumberPlaceSolverの実体をエレメント化 */
	NumberPlaceSolver {
		id: nps
	}
}

