pragma Singleton

import QtQuick 2.11
import QtQuick.Controls 2.4

ApplicationWindow {
    id: uikit

    default property bool dark: false
    property string accent: 'blue'

    readonly property color white: "#ffffff"
    readonly property color black: "#000000"
    readonly property color extra_light_gray: "#f9f9f9"
    readonly property color light_gray: "#e8e8ea"
    readonly property color light_mid_gray: "#d1d1d6"
    readonly property color mid_gray: "#c7c7cc"
    readonly property color gray: "#707074" // "#8e8e93"
    readonly property color dark_mid_gray: "#39383d"
    readonly property color darker_gray: "#080808"
    readonly property color dark_gray: "#202020"
    readonly property color lighter_gray: "#f8f8f8"

    readonly property color red: "#ff3b30"
    readonly property color orange: "#ff9500"
    readonly property color yellow: "#ffcc00"
    readonly property color green: "#4cd964"
    readonly property color teal_blue: "#5ac8fa"
    readonly property color blue: "#007aff"
    readonly property color purple: "#5856d6"
    readonly property color pink: "#ff2d55"

    readonly property color border_color: dark ? dark_mid_gray : mid_gray
    readonly property color component_border_color: dark ? gray : mid_gray
    readonly property color border_lighter_color: mid_gray //dark ? dark_gray : light_gray
    readonly property color header_background: dark ? black : white
    readonly property color popup_background: dark ? darker_gray : lighter_gray
    readonly property color component_focus: dark ? dark_mid_gray : light_mid_gray

    readonly property int implicitHeight: 32
    readonly property int radius: implicitHeight * 0.20
    readonly property int radius_popup: 15

    palette.window: dark ? black : white
    palette.windowText: dark ? extra_light_gray : dark_gray
    palette.base: dark ? dark_gray : extra_light_gray
    palette.text: dark ? extra_light_gray : dark_gray
    palette.alternateBase: dark ? dark_mid_gray : light_gray
    palette.brightText: dark ? white : black
    palette.shadow: black
    palette.button: accent ? uikit[accent] : dark ? orange : blue
    palette.dark: accent ? Qt.darker(uikit[accent], 1.5) : Qt.darker(dark ? orange : blue, 1.5)
    palette.mid: accent ? Qt.darker(uikit[accent], 1.25) : Qt.darker(dark ? orange : blue, 1.25)
    palette.light: accent ? Qt.lighter(uikit[accent], 1.5) : Qt.lighter(dark ? orange : blue, 1.5)
    palette.midlight: accent ? Qt.lighter(uikit[accent], 1.25) : Qt.lighter(dark ? orange : blue, 1.25)
    palette.buttonText: dark ? mid_gray : dark_mid_gray
    palette.highlight: accent ? uikit[accent] : dark ? orange : blue
    palette.highlightedText: white
    palette.link: purple
    palette.linkVisited: pink
    palette.toolTipBase: dark ? mid_gray : dark_gray
    palette.toolTipText: dark ? dark_gray : mid_gray
}
