import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.12

import UiKit 1.0

ToolBar {
    id: control

    property alias shaderSourceItem: shader.sourceItem

    background: Rectangle {
        color: UiKit.header_background

        FastBlur {
            id: fastBlur

            anchors.fill: parent
            radius: 40
            opacity: 0.4

            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: Rectangle {
                    x: fastBlur.x
                    y: fastBlur.y

                    width: fastBlur.width
                    height: fastBlur.height
                }
            }

            source: ShaderEffectSource {
                id: shader
                anchors.fill: parent
                sourceRect: Qt.rect(control.x, control.y, control.background.width, control.background.height)
            }
        }

        Rectangle {
            width: parent.width
            height: 1
            anchors.bottom: parent.bottom

            color: UiKit.border_color
            opacity: 0.25
        }
    }
}

