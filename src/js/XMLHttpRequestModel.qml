import QtQuick 2.12

Item {
    id: root

    property string url
    property string path
    property var params
    property var headers: Object({})
    property int method
    property int content
    property int status: 0
    property string statusText
    property var xhr: new XMLHttpRequest
    property var response
    property var body: Object({})
    readonly property bool busy: state === "loading"
    property var callback: function (data) {}

    enum Method { GET, POST, PUT, DELETE }
    readonly property var methods: [ "GET", "POST", "PUT", "DELETE" ]
    enum Content {
        APPLICATION_JSON,
        APPLICATION_FORM_URLENCODED,
        MULTIPART_FORM_DATA,
        TEXT_PLAIN
    }
    readonly property var contents: [
        "application/json",
        "application/x-www-form-urlencoded",
        "multipart/form-data",
        "text/plain"
    ]

    state: "null"
    states: [
        State { name: "null" },
        State { name: "ready" },
        State { name: "loading" },
        State { name: "error" }
    ]
    onStateChanged: {
        if (state === "error" || state === "ready")
            callback(response)
    }

    function send () {
        response = undefined
        xhr.withCredentials = true
        xhr.open(methods[method], `${url}${path}`)

        if (content !== null) {
            xhr.setRequestHeader('Content-Type', contents[content])
        } else {
            xhr.setRequestHeader('Content-Type', contents[XMLHttpRequestModel.Content.APPLICATION_FORM_URLENCODED])
        }

        for (let key in headers) {
            xhr.setRequestHeader(key, headers[key])
        }

        state = "loading"
        xhr.onload = function() {
            status = xhr.status
            statusText = xhr.statusText
            try {
                response = JSON.parse(xhr.responseText)
            } catch (err) {
                response = xhr.responseText
            }
            state = (status >= 200 && status <= 299) ? 'ready' : 'error'
            xhr = new XMLHttpRequest
            method = -1
            body = {}
        }

        xhr.onerror = function() {
            status = xhr.status
            error = null
            state = "error"
            xhr = new XMLHttpRequest
            method = -1
            body = {}
        }

        xhr.onprogress = function (event) {
            console.log(`Received ${event.loaded} of ${event.total}`)
        }

        xhr.send(JSON.stringify(body))
    }
}
