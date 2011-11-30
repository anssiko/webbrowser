import QtQuick 1.1
import QtMobility.sensors 1.2

OrientationSensor {
    id: orientation
    active: true

    onReadingChanged: {
        switch (reading.orientation) {
            case 1:
                console.log("orientation: portrait")
            case 4:
                console.log("orientation: landscape")
        }
    }
}
