CONFIG += c++11
INCLUDEPATH += $$PWD

HEADERS += \
    $$PWD/imagepicker.h

android {
    QT += androidextras
    SOURCES += \
        $$PWD/imagepicker_android.cpp
} else: ios {
    LIBS += -framework UIKit
    OBJECTIVE_SOURCES += \
        $$PWD/image_picker_ios.mm
} else {
    QT += widgets
    SOURCES += \
        $$PWD/imagepicker.cpp \
}

RESOURCES += \
    $$PWD/imagepicker.qrc
