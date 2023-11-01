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
        // console.log("Tables created ...");

        if (tx.lastError !== undefined && tx.lastError.valid) {
            console.error("Database error: " + tx.lastError.message);
        }
    })
}

function addTask(task, deadline, completed) {
    var db = getDB();

    db.transaction(function(tx){
        tx.executeSql('INSERT INTO tasks(task, deadline, completed) VALUES(?, ?, ?)', [task, deadline, completed]);
        console.log("Task added: " + task);

        if (tx.lastError !== undefined && tx.lastError.valid) {
            console.error("Database error: " + tx.lastError.message);
        }
    })
}

function removeTask(id) {
    var db = getDB();

    db.transaction(function(tx){
        tx.executeSql('DELETE FROM tasks WHERE id = ?', [id]);
        console.log("Task " + id + " removed");

        if (tx.lastError !== undefined && tx.lastError.valid) {
            console.error("Database error: " + tx.lastError.message);
        }
    });
}

function getTasks() {
    var db = getDB();
    var tasks = [];
    db.transaction(function(tx){
        var resultSet = tx.executeSql('SELECT * FROM tasks ORDER BY deadline ASC');

        for (var i = 0; i < resultSet.rows.length; i++) {
            var row = resultSet.rows.item(i);
            tasks.push({ id: row.id, task: row.task, deadline: row.deadline, completed: row.completed });
        }

        if (tx.lastError !== undefined && tx.lastError.valid) {
            console.error("Database error: " + tx.lastError.message);
        }
    })

    // console.log("Tasks retrieved:", tasks);
    return tasks;
}

function getTasksCount() {
    var db = getDB();
    var count = 0;

    db.transaction(function(tx){
        var resultSet = tx.executeSql('SELECT COUNT(*) as count FROM tasks');

        if (resultSet.rows.length > 0) {
            count = resultSet.rows.item(0).count;
        }

        if (tx.lastError !== undefined && tx.lastError.valid) {
            console.error("Database error: " + tx.lastError.message);
        }

        return count;
    });
}

function changeTaskProgress(id) {
    var db = getDB();

    db.transaction(function(tx){
        var resultSet = tx.executeSql('SELECT completed FROM tasks WHERE id = ?', [id]);
        var isCompleted;

        if (resultSet.rows.length === 1) {
            isCompleted = resultSet.rows.item(0).completed === 0 ? 1 : 0;
        }

        tx.executeSql('UPDATE tasks SET completed = ? WHERE id = ?', [isCompleted, id]);

        if (tx.lastError !== undefined && tx.lastError.valid) {
            console.error("Database error: " + tx.lastError.message);
        }
    });

}
