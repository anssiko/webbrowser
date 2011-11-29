import QtQuick 1.1
import QtMobility.systeminfo 1.2

DeviceInfo {
    property alias level: info.batteryLevel
    property bool charging: (info.currentPowerState != 1) ? true : false

    id: info
    monitorBatteryLevelChanges: true
    monitorBatteryStatusChanges: true
    monitorPowerStateChanges: true

    signal batteryStatusChanged(string msg)

    Component.onCompleted: batteryStatusChanged("DeviceInfo initialized")
    onBatteryLevelChanged: batteryStatusChanged("level: " + info.batteryLevel)
    onPowerStateChanged: batteryStatusChanged("power state: " + info.currentPowerState)
}

