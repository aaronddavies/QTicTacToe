import QtQuick 2.6
import QtQuick.Window 2.2

Window {
    visible: true
    property int square_size: 150
    property int box_count: 3

    property string background_color: "black"
    property string foreground_color: "white"
    property string win_color: "red"

    property string player1: "X"
    property string player2: "O"
    property string turn: player1

    property int window_size: box_count * square_size
    property int mark_size: 0.72 * square_size
    property int border_width: 0.05 * square_size

    height: window_size
    width: window_size
    maximumHeight: height
    maximumWidth: width

    function nextTurn() {
        for (var i = 0; i < box_count; ++i) {
            if (isThreeInARow(i) || isThreeInAColumn(i)) {
                endGame();
                return;
            }
        }
        if (isThreeInForwardDiagonal() || isThreeInBackwardDiagonal()) {
            endGame();
            return;
        }
        if (isCatsGame()) {
            endGame();
            return;
        }
        turn = turn === player1 ? player2 : player1
    }

    function endGame() {
        reset_area.enabled = true;
        turn = player1;
    }

    function isThree(marks) {
        if (marks.every(doesMatch)) { marks.forEach(showWinner); return true; }
        return false;
    }

    function isThreeInAColumn(index) {
        var marks = [];
        for (var i = 0; i < box_count; ++i) {
            marks.push(row_index.itemAt(index).column_index.itemAt(i).squareMark);
        }
        return isThree(marks);
    }

    function isThreeInARow(index) {
        var marks = [];
        for (var i = 0; i < box_count; ++i) {
            marks.push(row_index.itemAt(i).column_index.itemAt(index).squareMark);
        }
        return isThree(marks);
    }

    function isThreeInForwardDiagonal() {
        var marks = [];
        for (var i = 0; i < box_count; ++i) {
            marks.push(row_index.itemAt(i).column_index.itemAt(i).squareMark);
        }
        return isThree(marks);
    }

    function isThreeInBackwardDiagonal() {
        var marks = [];
        for (var i = 0; i < box_count; ++i) {
            marks.push(row_index.itemAt(i).column_index.itemAt(box_count - i - 1).squareMark);
        }
        return isThree(marks);
    }

    function isCatsGame() {
        var marks = [];
        for (var i = 0; i < box_count; ++i) {
            for (var j = 0; j < box_count; ++j) {
                marks.push(row_index.itemAt(i).column_index.itemAt(j).squareMark);
            }
        }
        return marks.every(isMarked);
    }

    function doesMatch(currentValue) {
        return currentValue.text === turn;
    }

    function isMarked(currentValue) {
        return currentValue.text === player1 || currentValue.text === player2;
    }

    function showWinner(currentValue) {
        currentValue.color = win_color
    }

    Column {
        Repeater {
            id: row_index
            model: box_count;
            Row {
                property var column_index: column_indexer
                Repeater {
                    id: column_indexer;
                    model: box_count;
                    Square {}
                }
            }
        }
    }

    MouseArea {
        id: reset_area
        anchors.fill: parent
        enabled: false
        onClicked: {
            enabled = false
            for (var i = 0; i < box_count; ++i) {
                for (var j = 0; j < box_count; ++j) {
                    var mark = row_index.itemAt(i).column_index.itemAt(j).squareMark;
                    mark.color = foreground_color
                    mark.text = ""
                }
            }
        }
    }
}
