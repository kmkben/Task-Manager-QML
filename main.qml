import QtQuick
import QtQuick.Controls 2.15

Window {
    width: 440
    height: 680
    visible: true
    title: qsTr("Hello World")

    ListView {
        width: parent.width
        height: parent.height

        model: ListModel {
            id: taskModel
        }

        delegate: Item {
            id: delegateTaskList
            width: parent.width
            height: 60

            Rectangle {
                width: parent.width
                height: 60
                color: model.completed ? "#aaffaa" : "white"

                Text {
                    id: text
                    anchors.centerIn: parent
                    text: qsTr(model.task)
                    font.bold: true
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    onClicked: {
                        taskModel.get(index).completed = !taskModel.get(index).completed;
                    }
                }

                Image {
                    id: deleteImg
                    source: "delete.png"
                    width:30
                    height: 30
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    visible: taskModel.get(index).completed

                    MouseArea {
                        id: mouseAreaDeleteImg
                        anchors.fill: parent
                        onClicked: {
                            taskModel.remove(index);
                        }
                    }
                }
            }
        }
    }

    TextField {
        id: taskInput
        width: parent.width - 70
        height: 40
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.bottomMargin: 10
        placeholderText: qsTr("Enter a task")
        onAccepted: {
            if (taskInput.text !== "") {
                taskModel.append({ "task": taskInput.text, "completed": false });
                taskInput.text = "";
            }
        }
    }

}
