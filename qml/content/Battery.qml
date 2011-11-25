import QtQuick 1.1
import QtMobility.systeminfo 1.2

DeviceInfo {
    id: info
    monitorBatteryLevelChanges: true
    monitorBatteryStatusChanges: true
    monitorPowerStateChanges: true

    Component.onCompleted: console.log('DeviceInfo initialized')
    onBatteryLevelChanged: console.log('battery level: ' + info.batteryLevel)
    onBatteryStatusChanged: console.log('battery status: ' + info.batteryStatus)
    onPowerStateChanged: console.log('power state: ' + info.currentPowerState)
}

