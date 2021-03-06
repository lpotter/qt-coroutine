TEMPLATE = lib
CONFIG += dll
DEFINES += COROUTINE_LIBRARY
unix: CONFIG += hide_symbols

TARGET = coroutine
include(adjusttarget.pri)

HEADERS += \
    coroutine.h \
    coroutine_global.h \
    coroutinebuilddeclaration_p.h \
    coroutinebuilddefinition_p.h \
    coroutinestoredfunctioncall_p.h

SOURCES += coroutine.cpp

INCLUDEPATH += .
DEPENDPATH += .

contains(QMAKE_CXX,g++) {
    win32 {
        # will fail for 64 bit win!
        SOURCES += \
            backend/switchstack_gcc_32_win.s \
            backend/initializestack_32.cpp
    } else: mac {
        CONFIG(x86_64) {
            SOURCES += \
                backend/switchstack_gcc_64_linux_mac.s \
                backend/initializestack_64_linux_mac.cpp
        } else {
            SOURCES += \
                backend/switchstack_gcc_32_linux_mac.s \
                backend/initializestack_32.cpp
        }
    } else: unix {
        contains(QMAKE_HOST.arch, x86_64) {
            SOURCES += \
                backend/switchstack_gcc_64_linux_mac.s \
                backend/initializestack_64_linux_mac.cpp
        } else:contains(QMAKE_HOST.arch, x86) {
            SOURCES += \
                backend/switchstack_gcc_32_linux_mac.s \
                backend/initializestack_32.cpp
        } else {
            error(Unsupported platform)
        }
    } else {
        error(Unsupported platform)
    }
}
win32:contains(QMAKE_CXX,cl) {
    # will fail for 64 bit win!
    SOURCES += \
        backend/switchstack_msvc_32.cpp \
        backend/initializestack_32.cpp
}

# install rules
target.path = $$PREFIX/lib

headers.files = $$HEADERS
headers.path = $$PREFIX/include/coroutine

INSTALLS += target headers

