import QtQuick 1.1
import QtMobility.systeminfo 1.2

DeviceInfo {
    property double level: info.batteryLevel/100
    property bool charging: (info.currentPowerState != 1) ? true : false

    id: info
    monitorBatteryLevelChanges: true
    monitorPowerStateChanges: true

    onLevelChanged: {
        webViewInstance.level = level
    }

    onChargingChanged: {
        webViewInstance.charging = charging
    }
}

