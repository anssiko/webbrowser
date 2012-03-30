(function(n) {

// Battery Status API
n.battery = {
    charging: true,
    chargingTime: Infinity,
    dischargingTime: Infinity,
    level: 1,
    onchargingchange: null,
    onchargingtimechange: null,
    ondischargingtimechange: null,
    onlevelchange: null,
    // EventTarget interface
    // TODO: implement support for multiple event listeners, event capture, Event interface
    addEventListener: function (type, listener, capture) {
        if (listener === null) return;
        navigator.battery['on' + type] = function () { listener({ type: type }) };
    },
    removeEventListener: function (type, listener, capture) {
        navigator.battery['on' + type] = null;
    }
};
n.mozBattery = n.webKitBattery = n.battery;

// Vibration API
n.vibrate = function (arg) {
    __vibration__.vibrate(arg);
};
n.mozVibrate = n.webKitVibrate = n.vibrate;

})(window.navigator);
