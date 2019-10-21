import QtQuick 2.0
import "./Database.js" as DB
import QtQuick.LocalStorage 2.12

ListModel {
    id: listModel

    property var rows: []
    property string table
    property string orderField: "id"
    property string order: "ASC"
    property var fields: []
    property string sql

    onRowsChanged: {
        listModel.clear()
        rows.forEach(function (r) {
            listModel.append(r)
        })
    }

    function getData (where = undefined) {
        rows = DB.get(listModel.table, where, listModel.orderField + " " + listModel.order)
    }

    function insertData (data) {
        DB.add(listModel.table, data)
        listModel.getData()
    }

    function updateData (where, data) {
        DB.update(listModel.table, where, data)
        listModel.getData()
    }

    function updateManyData (data) {
        for (let i = 0; i < data.length; ++i)
            DB.update(listModel.table, data[i].where, data[i].data)
        listModel.getData()
    }

    function removeData (where) {
        DB.remove(listModel.table, where)
        listModel.getData()
    }

    function createTable () {
        if (!sql)
            return
        DB.init(function () {
            try {
                DB.db.transaction(function (tx) {
                    tx.executeSql("CREATE TABLE IF NOT EXISTS " + listModel.table + " (" + listModel.sql + ")")
                })
            } catch (err) {
                console.log("Error trying to create table: " + listModel.table + ", " + err)
            }
        })
    }

    function filter (str, field) {
        return rows.filter(function (r) {
            return r[field].toString().match(new RegExp(str, "ig"))
        })
    }

    function getItem (str, field) {
        return rows.filter(function (f) {
            return f[field] === str
        })[0]
    }

    onSqlChanged: createTable()
}
