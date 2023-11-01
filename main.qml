import QtQuick
import QtQuick.Controls 2.15
import QtQuick.LocalStorage 2.0

import "qrc:/database.js" as DB

Window {
    width: 440
    height: 680
    visible: true
    title: qsTr("Task Manager")

    Item {
        Component.onCompleted: {
//            const db = LocalStorage.openDatabaseSync("TaskManagerDB", "1.0", "Databse to store task in Task Manager", 1000000)

//            db.transaction(function(tx){
//                    tx.executeSql('CREATE TABLE IF NOT EXISTS user(id INTEGER PRIMARY KEY AUTOINCREMENT, pseudo TEXT, password TEXT);');
//                    tx.executeSql('CREATE TABLE IF NOT EXISTS tasks(id INTEGER PRIMARY KEY AUTOINCREMENT, task TEXT, deadline DATE, completed INTEGER);');
//                    console.log("Tables created ...");
//            });

            DB.initDB();
        }
    }

    ListView {
        width: parent.width
        height: parent.height

        model: ListModel {
            id: taskModel
        }

        Component.onCompleted: {
            tasks = DB.getTasks();

            for (var i = 0; i < tasks.length; i++) {
                model.append({"id": tasks[i].id, "task": tasks[i].task, "deadline": tasks[i].deadline, "completed": tascks[i].completed === 0 ? false : true});
            }
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
<<<<<<< HEAD
                    taskModel.append({ "task": taskInput.text, "deadline": deadlineInput.text, "completed": false });
=======
                    // Add database
                    var task = taskInput.text;
                    var deadline = deadlineInput.text;
                    var completed = 0;
                    DB.addTask(task, deadline, completed);

                    //taskModel.append({ "task": taskInput.text, "deadline": deadlineInput.text, "completed": false });

                    var tasks = DB.getTasks();

                    for (var i = 0; i < tasks.length; i++) {
                        taskModel.append({"id": tasks[i].id, "task": tasks[i].task, "deadline": tasks[i].deadline, "completed": tascks[i].completed === 0 ? false : true});
                    }

>>>>>>> 87a8c93a0296c38a21cf0083781c4546ec425c72
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
<<<<<<< HEAD
                    taskModel.append({ "task": taskInput.text, "deadline": deadlineInput.text, "completed": false });
=======
                    // Add task to database
                    var task = taskInput.text;
                    var deadline = deadlineInput.text;
                    var completed = 0;
                    DB.addTask(task, deadline, completed);

                    //taskModel.append({ "task": taskInput.text, "deadline": deadlineInput.text, "completed": false });

                    var tasks = DB.getTasks();

                    for (var i = 0; i < tasks.length; i++) {
                        taskModel.append({"id": tasks[i].id, "task": tasks[i].task, "deadline": tasks[i].deadline, "completed": tasks[i].completed === 0 ? false : true});
                    }

>>>>>>> 87a8c93a0296c38a21cf0083781c4546ec425c72
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
<<<<<<< HEAD
                    if (taskInput.text !== "" && deadlineInput.text !== "") {
                        taskModel.append({ "task": taskInput.text, "deadline": deadlineInput.text, "completed": false });
=======

                    if (taskInput.text !== "" && deadlineInput.text !== "") {
                        // Add task to database
                        var task = taskInput.text;
                        var deadline = deadlineInput.text;
                        var completed = 0;
                        DB.addTask(task, deadline, completed);

                        //taskModel.append({ "task": taskInput.text, "deadline": deadlineInput.text, "completed": false });
>>>>>>> 87a8c93a0296c38a21cf0083781c4546ec425c72
                        taskInput.text = "";
                        deadlineInput.text = "";
                        taskInput.focus = true;
                    }
                }
            }
        }
    }

}
