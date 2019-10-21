import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Templates 2.12 as T

T.AbstractButton {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    property bool highlighted: false

    leftPadding: 8
    rightPadding: 8
    topPadding: 1
    bottomPadding: 2

    contentItem: Label {
        anchors.fill: parent
        text: control.text
        verticalAlignment: Label.AlignVCenter
        horizontalAlignment: Label.AlignHCenter
        font.pixelSize: 12
        wrapMode: Label.WordWrap

        opacity: checked || highlighted ? 1 : 0.5
    }

    background: Rectangle {
        color: checked || highlighted ? "#e9e9e9" : "#f1f1f1"
        radius: 5
    }
}
