import QtQuick 1.1
import QtMobility.systeminfo 1.2

DeviceInfo {
    id: info
    monitorBatteryLevelChanges: true
    monitorPowerStateChanges: true

    property double level: info.batteryLevel/100
    property bool charging: (info.currentPowerState != 1) ? true : false

    onLevelChanged: webViewInstance.level = level
    onChargingChanged: webViewInstance.charging = charging
}

