import QtQuick
import QtQuick.Controls 2.15
import QtQuick.LocalStorage 2.0

import "qrc:/database.js" as DB

Window {
    width: 440
    height: 700
    visible: true
    title: qsTr("Task Manager")


    Item {
        Component.onCompleted: {

            DB.initDB();

            var tasks = DB.getTasks();

            for (var i = 0; i < tasks.length; i++) {
                taskModel.append({id: tasks[i].id, task: tasks[i].task, deadline: tasks[i].deadline, completed: tasks[i].completed === 0 ? false : true});
            }
        }
    }

    ListView {
        id: listView
        width: parent.width
        height: parent.height - 180
        clip: true

        model: ListModel {
            id: taskModel

            Component.onObjectNameChanged: {
                var tasks = DB.getTasks();

                for (var i = 0; i < tasks.length; i++) {
                    taskModel.append({id: tasks[i].id, task: tasks[i].task, deadline: tasks[i].deadline, completed: tasks[i].completed === 0 ? false : true});
                }
            }

        }

        ScrollBar.vertical: ScrollBar {
            id: verticalScrollBar
            active: pressed || listView.moving
            orientation: Qt.Vertical
            opacity: active ? 1:0
            Behavior on opacity {NumberAnimation {duration: 500}}

            contentItem: Rectangle {
                implicitWidth: 4
                radius:2
                implicitHeight: parent.height
                color: "#ff303030"
            }
        }

        delegate: Item {
            id: delegateTaskList
            width: parent.width
            height: 60
            anchors.bottomMargin: 30

            Rectangle {
                id: taskRect
                width: parent.width
                height: 60
                color: model.completed ? "#aaffaa" : "white"

                property bool isCompleted: model.completed

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
                    anchors.rightMargin: 40
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    onClicked: {
                        var id = model.id
                        model.completed = !taskRect.isCompleted;
                        DB.changeTaskProgress(id);
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
                            var id = taskModel.get(index).id;
                            taskModel.remove(index);
                            DB.removeTask(id);
                        }
                    }
                }
            }
        }

        footerPositioning: ListView.PullBackFooter
        footer: Rectangle {
            id: listFooter
            width: parent.width - 200
            height: 60
            anchors.horizontalCenter: parent.horizontalCenter
            color: "orange"

            Text {
                id: listFooterText
                text: qsTr("Clear All")
                anchors.centerIn: parent
                font.bold: true
                font.pointSize: 18
                color: "red"
            }

            MouseArea {
                id: mouseAreaClearAllTasks
                anchors.fill: parent

                onClicked: {
                    console.log("All tasks clecked");
                }
            }


        }

    }

    Rectangle {
        id: rectInputFields
        width: parent.width
        height: 190
        anchors.bottom: parent.bottom

        TextField {
            id: taskInput
            width: parent.width - 20
            height: 40
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: 10
            anchors.bottomMargin: 10
            anchors.leftMargin: 10
            placeholderText: qsTr("Enter a task")

            onAccepted: {
                if (taskInput.text !== "" && deadlineInput.text !== "") {

                    taskModel.append({ "task": taskInput.text, "deadline": deadlineInput.text, "completed": false });

                    // Add database
                    var task = taskInput.text;
                    var deadline = deadlineInput.text;
                    var completed = 0;
                    DB.addTask(task, deadline, completed);


                    taskInput.text = "";
                    deadlineInput.text = "";
                    taskInput.focus = true;

//                    var tasks = DB.getTasks();

//                    for (var i = 0; i < tasks.length; i++) {
//                        taskModel.append({id: tasks[i].id, task: tasks[i].task, deadline: tasks[i].deadline, completed: tasks[i].completed === 0 ? false : true});
//                    }


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

                    // Add task to database
                    var task = taskInput.text;
                    var deadline = deadlineInput.text;
                    var completed = 0;
                    DB.addTask(task, deadline, completed);

                    taskInput.text = "";
                    deadlineInput.text = "";
                    taskInput.focus = true;

                    taskModel.sort(function(item1, item2) {
                            return new Date(item1.deadline) - new Date(item2.deadline);
                        });

//                    var tasks = DB.getTasks();

//                    for (var i = 0; i < tasks.length; i++) {
//                        taskModel.append({id: tasks[i].id, task: tasks[i].task, deadline: tasks[i].deadline, completed: tasks[i].completed === 0 ? false : true});
//                    }

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

                        // Add task to database
                        var task = taskInput.text;
                        var deadline = deadlineInput.text;
                        var completed = 0;
                        DB.addTask(task, deadline, completed);

                        taskInput.text = "";
                        deadlineInput.text = "";
                        taskInput.focus = true;

//                        var tasks = DB.getTasks();

//                        for (var i = 0; i < tasks.length; i++) {
//                            taskModel.append({id: tasks[i].id, task: tasks[i].task, deadline: tasks[i].deadline, completed: tasks[i].completed === 0 ? false : true});
//                        }

                    }
                }
            }
        }
    }

}
