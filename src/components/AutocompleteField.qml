import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12
import QtQuick.Templates 2.12 as T
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Material.impl 2.12

T.TextField {
    id: control

    implicitWidth: implicitBackgroundWidth + leftInset + rightInset
                   || Math.max(contentWidth, placeholder.implicitWidth) + leftPadding + rightPadding
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding,
                             placeholder.implicitHeight + topPadding + bottomPadding)

    property string textRole
    property var model
    property alias currentIndex: listviewSuggestion.currentIndex
    signal selected()

    topPadding: 8
    bottomPadding: 16

    color: enabled ? Material.foreground : Material.hintTextColor
    selectByMouse: true
    selectionColor: Material.accentColor
    selectedTextColor: Material.primaryHighlightedTextColor
    placeholderTextColor: Material.hintTextColor
    verticalAlignment: TextInput.AlignVCenter

    cursorDelegate: CursorDelegate { }

    PlaceholderText {
        id: placeholder
        x: control.leftPadding
        y: control.topPadding
        width: control.width - (control.leftPadding + control.rightPadding)
        height: control.height - (control.topPadding + control.bottomPadding)
        text: control.placeholderText
        font: control.font
        color: control.placeholderTextColor
        verticalAlignment: control.verticalAlignment
        elide: Text.ElideRight
        renderType: control.renderType
        visible: !control.length && !control.preeditText && (!control.activeFocus || control.horizontalAlignment !== Qt.AlignHCenter)
    }

    background: Rectangle {
        y: control.height - height - control.bottomPadding + 8
        implicitWidth: 120
        height: control.activeFocus || control.hovered ? 2 : 1
        color: control.activeFocus ? control.Material.accentColor
                                   : (control.hovered ? control.Material.primaryTextColor : control.Material.hintTextColor)
    }

    Keys.onDownPressed: popup.forceActiveFocus()

    onTextChanged: openSuggestion()
    T.Popup {
        id: popup
        y: control.height - 5
        width: control.width
        height: Math.min(contentItem.implicitHeight, control.Window.height - topMargin - bottomMargin)
        transformOrigin: Item.Top
        topMargin: 12
        bottomMargin: 12
        closePolicy: Popup.CloseOnPressOutsideParent

        Material.theme: control.Material.theme
        Material.accent: control.Material.accent
        Material.primary: control.Material.primary

        enter: Transition {
            // grow_fade_in
            NumberAnimation { property: "scale"; from: 0.9; to: 1.0; easing.type: Easing.OutQuint; duration: 220 }
            NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; easing.type: Easing.OutCubic; duration: 150 }
        }

        exit: Transition {
            // shrink_fade_out
            NumberAnimation { property: "scale"; from: 1.0; to: 0.9; easing.type: Easing.OutQuint; duration: 220 }
            NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; easing.type: Easing.OutCubic; duration: 150 }
        }

        contentItem: ListView {
            id: listviewSuggestion
            clip: true
            implicitHeight: contentHeight
            focus: true

            model: control.model
            delegate: ItemDelegate {
                id: delegateSuggestion

                width: parent.width
                height: 30
                text: control.textRole ? (Array.isArray(control.model) ? modelData[control.textRole] : model[control.textRole]) : modelData
                font: control.font

                highlighted: listviewSuggestion.currentIndex === index
                onClicked: {
                    listviewSuggestion.currentIndex = index
                    if (control.model.get(index)) {
                        control.text = control.model.get(index).formatted
                        selected()
                    }

                    popup.close()
                }
            }

            currentIndex: -1
//            onModelChanged: if (model.count) currentIndex = -1
            highlightMoveDuration: 0
            keyNavigationEnabled: true
            keyNavigationWraps: true
            Keys.onUpPressed: listviewSuggestion.decrementCurrentIndex()
            Keys.onDownPressed: listviewSuggestion.incrementCurrentIndex()

            T.ScrollIndicator.vertical: ScrollIndicator { }
        }

        background: Rectangle {
            radius: 2
            color: parent.Material.dialogColor

            layer.enabled: control.enabled
            layer.effect: ElevationEffect {
                elevation: 8
            }
        }
    }

    function openSuggestion() {
        popup.open()
    }
}
