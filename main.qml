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
                id: taskRect
                width: parent.width
                height: 60
                color: model.completed ? "#aaffaa" : "white"

                property bool isCompleted: model.completed

                Row {
                    width: parent.width - 40
                    anchors.verticalCenter: taskRect.verticalCenter

                    Text {
                        id: textTask
                        width: (80 * parent.width / 100)
                        text: qsTr(model.task)
                        font.bold: true
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        wrapMode: Text.WordWrap
                        padding: 10
                    }

                    Text {
                        id: textDeadline
                        text: qsTr(model.deadline)
                        font.bold: true
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    onClicked: {
                        model.completed = !taskRect.isCompleted;
                    }
                }

                Image {
                    id: deleteImg
                    source: "qrc:/images/delete.png"
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

    Rectangle {
        id: rectInputFields
        width: parent.width
        height: 160
        anchors.bottom: parent.bottom

        TextField {
            id: taskInput
            width: parent.width - 20
            height: 40
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.bottomMargin: 10
            anchors.leftMargin: 10
            placeholderText: qsTr("Enter a task")

            onAccepted: {
                if (taskInput.text !== "" && deadlineInput.text !== "") {
                    taskModel.append({ "task": taskInput.text, "deadline": deadlineInput.text, "completed": false });
                    taskInput.text = "";
                    deadlineInput.text = "";
                    taskInput.focus = true;
                }
            }
        }

        TextField {
            id: deadlineInput
            width: parent.width - 20
            height: 40
            anchors.top: taskInput.bottom
            anchors.left: parent.left
            anchors.topMargin: 10
            anchors.leftMargin: 10
            validator: RegularExpressionValidator { regularExpression: /^(0[1-9]|[12][0-9]|3[01])[- /.](0[1-9]|1[012])[- /.](19|20)\d\d$/ }
            placeholderText: qsTr("Enter a deadline (dd/mm/yyyy)")

            onAccepted: {
                if (taskInput.text !== "" && deadlineInput.text !== "") {
                    taskModel.append({ "task": taskInput.text, "deadline": deadlineInput.text, "completed": false });
                    taskInput.text = "";
                    deadlineInput.text = "";
                    taskInput.focus = true;
                }
            }
        }

        Rectangle {
            id: btnValid
            width: parent.width - 20
            height: 40
            color: "darkgreen"
            anchors.top: deadlineInput.bottom
            anchors.left: parent.left
            anchors.topMargin: 10
            anchors.leftMargin: 10

            Text {
                id: btnText
                text: qsTr("Add task")
                anchors.centerIn: parent
                font.bold: true
            }

            MouseArea {
                id: mouseAreaBtn
                anchors.fill: parent

                onClicked: {
                    if (taskInput.text !== "" && deadlineInput.text !== "") {
                        taskModel.append({ "task": taskInput.text, "deadline": deadlineInput.text, "completed": false });
                        taskInput.text = "";
                        deadlineInput.text = "";
                        taskInput.focus = true;
                    }
                }
            }
        }
    }

}
