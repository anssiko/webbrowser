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
        console.log("Battery.onLevelChanged - webView.level: " + webView.level)
    }

    onChargingChanged: {
        webView.charging = charging
        console.log("Battery.onChargingChanged - webView.charging: " + webView.charging)
    }
}

