import QtQuick 1.1
import QtMobility.systeminfo 1.2

DeviceInfo {
    property alias level: info.batteryLevel
    property bool charging: (info.currentPowerState != 1) ? true : false

    id: info
    monitorBatteryLevelChanges: true
    monitorPowerStateChanges: true

    onLevelChanged: {
        webView.level = level
    }

    onChargingChanged: {
        webView.charging = charging
    }
}

