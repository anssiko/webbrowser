import QtQuick 1.1
import QtMobility.systeminfo 1.2

DeviceInfo {
    property alias level: info.batteryLevel
    property bool charging: (info.currentPowerState != 1) ? true : false

    id: info
    monitorBatteryLevelChanges: true
    monitorBatteryStatusChanges: true
    monitorPowerStateChanges: true

    Component.onCompleted: console.log('DeviceInfo initialized')
    onBatteryLevelChanged: console.log('battery level: ' + info.batteryLevel)
    onPowerStateChanged: console.log('power state: ' + info.currentPowerState)
}

