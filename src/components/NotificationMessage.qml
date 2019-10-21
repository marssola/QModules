import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12
import QtQuick.Templates 2.12 as T

T.ToolTip {
    id: control

    x: parent ? (parent.width - implicitWidth) / 2 : 0
    y: (window.height / 2) - (implicitHeight / 2)

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)

    margins: 6
    padding: 6

    closePolicy: T.Popup.NoAutoClose

    contentItem: Text {
        text: control.text
        font: control.font
        color: control.palette.toolTipText
        wrapMode: Label.Wrap
    }

    background: Rectangle {
        border.color: control.palette.toolTipText
        color: control.palette.toolTipBase
        radius: 6.4
        opacity: 0.80
    }

    z: 100

    function show(msg, ms) {
        ms = ms ? ms : 3000
        if (visible) {
            text += "\n" + msg;
//            timeout += ms;
        } else {
            text = msg;
        }
        timeout = ms;
        visible = true;
    }
}
