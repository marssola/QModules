import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Templates 2.12 as T

T.StackView {
    id: control

    property string prefix_file: ""
    property string suffix_file: ""

    popEnter: Transition {
        XAnimator { from: (control.mirrored ? -1 : 1) * -control.width; to: 0; duration: 400; easing.type: Easing.OutCubic }
    }

    popExit: Transition {
        XAnimator { from: 0; to: (control.mirrored ? -1 : 1) * control.width; duration: 400; easing.type: Easing.OutCubic }
    }

    pushEnter: Transition {
        XAnimator { from: (control.mirrored ? -1 : 1) * control.width; to: 0; duration: 400; easing.type: Easing.OutCubic }
    }

    pushExit: Transition {
        XAnimator { from: 0; to: (control.mirrored ? -1 : 1) * -control.width; duration: 400; easing.type: Easing.OutCubic }
    }

    replaceEnter: Transition {
        XAnimator { from: (control.mirrored ? -1 : 1) * control.width; to: 0; duration: 400; easing.type: Easing.OutCubic }
    }

    replaceExit: Transition {
        XAnimator { from: 0; to: (control.mirrored ? -1 : 1) * -control.width; duration: 400; easing.type: Easing.OutCubic }
    }

    Drawer {
        width: 0
        height: ApplicationWindow.height

        modal: false

        onPositionChanged: {
            if (position > 0.3 && visible) {
                if (control.depth > 1)
                    control.pop()
                close()
            }
        }
    }

    function setPage(page, parameters) {
        if (find(function(item, index) { return item.objectName === page })) {
            control.replace(control.prefix_file + page + control.suffix_file, parameters ? parameters : {})
        } else {
            control.push(control.prefix_file + page + control.suffix_file, parameters ? parameters : {})
        }
    }
}
