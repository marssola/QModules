import QtQuick 2.12
import QtQuick.Controls 2.5

Page {
    id: page

    property var content: Item {}
    property alias pane: pane

    signal moveStarted()
    signal moveEnded()

    property alias contentY: flickable.contentY
    property alias contentX: flickable.contentX
    property alias originY: flickable.originY
    property alias originX: flickable.originX

    Flickable {
        id: flickable

        anchors.fill: parent
        contentHeight: pane.implicitHeight
        flickableDirection: Flickable.AutoFlickIfNeeded

        Pane {
            id: pane
            width: parent.width
            padding: 0

            contentItem: page.content
            background: Rectangle { color: "transparent" }
        }

        ScrollIndicator.vertical: ScrollIndicator {}

        onMovementStarted: moveStarted()
        onMovementEnded: moveEnded()
    }
}
