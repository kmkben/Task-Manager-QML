//.import Qt.LocalStorage 2.15 as Sql
Qt.include("QtQuick/localstorage.js");

function getDB() {
    var db = LocalStorage.openDatabaseSync("TaskManagerDB", "1.0", "Databse to store task in Task Manager", 1000000)

    return db;
}

function initDB() {
    // initialize the database object
    // print('initDatabase()')
    var db = getDB();
    db.transaction( function(tx) {
        tx.executeSql('CREATE TABLE IF NOT EXISTS user(id INTEGER PRIMARY KEY AUTOINCREMENT, pseudo TEXT, password TEXT);');
        tx.executeSql('CREATE TABLE IF NOT EXISTS tasks(id INTEGER PRIMARY KEY AUTOINCREMENT, task TEXT, deadline DATE, completed INTEGER);');
        console.log("Tables created ...");
    })
}

function addTask(task, deadline, completed) {
    var db = getDB();

    db.transaction(function(tx){
        tx.executeSql('INSERT INTO tasks(task, deadline, completed) VALUES(?, ?, ?)', [task, deadline, completed]);
        console.log("Task added: " + task);
    })
}

function getTasks() {
    var db = getDB();
    var tasks = [];
    db.transaction(function(tx){
        var resultSet = tx.executeSql('SELECT * FROM tasks');

        for (var i = 0; i < resultSet.rows.length; i++) {
            var row = resultSet.rows.item(i);
            tasks.push({ id: row.id, task: row.task, deadline: row.deadline, completed: row.completed });
        }
    });

    return tasks;
}
