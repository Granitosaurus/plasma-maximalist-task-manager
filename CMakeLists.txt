# SPDX-FileCopyrightText: 2026 Bernardas Ališauskas
# SPDX-License-Identifier: GPL-2.0-or-later

cmake_minimum_required(VERSION 3.22)

project(plasma-maximalist-task-manager VERSION 1.0.0)

# The Plasma release the sources in src/ were forked from. The widget uses
# private Plasma QML modules, so it is only expected to work on this series.
set(PLASMA_BASE_VERSION "6.8.1")
set(QT_MIN_VERSION "6.8.0")
set(KF6_MIN_VERSION "6.10.0")

find_package(ECM ${KF6_MIN_VERSION} REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH})

include(KDEInstallDirs)
include(KDECMakeSettings)
include(KDECompilerSettings NO_POLICY_SCOPE)
include(ECMQtDeclareLoggingCategory)
include(FeatureSummary)

find_package(Qt6 ${QT_MIN_VERSION} CONFIG REQUIRED COMPONENTS
    Core
    DBus
    Gui
    Qml
    Quick
    Widgets
)

find_package(KF6 ${KF6_MIN_VERSION} REQUIRED COMPONENTS
    Config
    GlobalAccel
    I18n
    KIO
    Notifications
    Service
    WindowSystem
    XmlGui
)

find_package(Plasma ${PLASMA_BASE_VERSION} REQUIRED)
find_package(PlasmaActivities ${PLASMA_BASE_VERSION} REQUIRED)
find_package(PlasmaActivitiesStats ${PLASMA_BASE_VERSION} REQUIRED)
find_package(LibNotificationManager ${PLASMA_BASE_VERSION} CONFIG REQUIRED)
find_package(KSysGuard CONFIG REQUIRED)

add_subdirectory(src)

ki18n_install(po)

feature_summary(WHAT ALL INCLUDE_QUIET_PACKAGES FATAL_ON_MISSING_REQUIRED_PACKAGES)
