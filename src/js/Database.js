var db = null

var init = (callback) => {
    try {
        db = LocalStorage.openDatabaseSync(Qt.application.name, "1.0", "Database", 1000000)
    } catch (err_db) {
        console.log("Error trying to create database: " + err_db)
        return
    }

    if (typeof callback == "function")
        callback()
}

// ----------------------------------------------------------------------------------------------------------------------------------------- CRUD

var add = (table, data) => {
    if (!table) {
        console.log("Error: table not defined")
        return
    }

    if (!data) {
        console.log("Error: data not defined")
        return
    }

    var insert_data = {
        keys: [],
        values: []
    }
    for (var k in data) {
        insert_data.keys.push(k)
        insert_data.values.push((typeof data[k] === 'number'? data[k] : "'" + data[k] + "'"))
    }

    db.transaction((tx) => {
        try {
            tx.executeSql("INSERT INTO " + table + " (" + insert_data.keys.join(', ') + ") VALUES(" + insert_data.values.join(', ') + ")")
        } catch (err) {
            console.log("Error trying to insert: " + err)
        }
    })
}

var getOne = (table, where) => {
    if (!where)
        where = "id > 0"
    var row = []
    try {
        db.transaction((tx) => {
            var get = tx.executeSql("SELECT * FROM " + table + " WHERE " + where + " LIMIT 1")
            if (get.rows.length)
                row = get.rows.item(0)
        })
    } catch (err) {
        console.log("Error trying to get one record: " + err)
    }
    return row;
}

var get = (table, where, order) => {
    if (!where)
        where = "id > 0"
    var content = []
    try {
        db.transaction((tx) => {
            var query = "SELECT * FROM " + table + " WHERE " + where
            if (order)
                query += " ORDER BY " + order
            var get = tx.executeSql(query)
            for (let i = 0; i < get.rows.length; ++i)
                content.push(get.rows[i])
        })
    } catch (err) {
        console.log("Error trying to get: " + err)
    }
    return content
}

var getJoin = (table, fields, joins, reference, where, order) => {
    var content = []
    try {
        db.transaction((tx) => {
            var query = "SELECT " + fields.join(', ') + " FROM " + table + " "
            for (var j in joins) {
                query += "LEFT JOIN " + joins[j] + " ON " + reference[j]
            }
            if (where)
                query += " WHERE " + where
            if (order)
                query += " ORDER BY " + order
            var get = tx.executeSql(query)
            for (let i = 0; i < get.rows.length; ++i)
                content.push(get.rows[i])
        })
    } catch (err) {
        console.log("Error trying to get with join: " + err)
    }
    return content
}

var update = (table, where, data) => {
    var data_update = [], query;
    for (var key in data)
        data_update.push(key + "=" + (typeof data[key] === 'number' ? data[key] : "'" + data[key] + "'") + "");
    query = "UPDATE " + table + " SET " + data_update.join(', ') + " WHERE " + where;

    db.transaction(function (tx) {
        try {
            tx.executeSql(query);
        } catch (err) {
            console.log("Error trying to update: " + err);
        }
    });
}

var remove = (table, where) => {
    db.transaction((tx) => {
        try {
            tx.executeSql("DELETE FROM " + table + " WHERE " + where);
        } catch (err) {
            console.log("Error trying to delete: " + err);
        }
    });
}

// ----------------------------------------------------------------------------------------------------------------------------------------- CRUD END
