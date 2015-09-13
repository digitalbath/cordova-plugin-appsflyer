(function(global) {
  var AppsFlyer;
  AppsFlyer = function() {};

  AppsFlyer.prototype.initSdk = function(args) {
    var self = this;
    cordova.exec(
      function(conversionData) {
        self.onInstallConversionDataLoaded(conversionData);
      }, null, "AppsFlyerPlugin", "initSdk", args);
  };

  AppsFlyer.prototype.setCurrencyCode = function(currencyId) {
    cordova.exec(null, null, "AppsFlyerPlugin", "setCurrencyCode", [currencyId]);
  };

  AppsFlyer.prototype.setCustomerUserId = function(customerUserId) {
    cordova.exec(null, null, "AppsFlyerPlugin", "setCustomerUserId", [customerUserId]);
  };

  AppsFlyer.prototype.setUserEmails = function(emails, cryptMethod) {
    cordova.exec(null, null, "AppsFlyerPlugin", "setUserEmails", [emails, cryptMethod]);
  };

  AppsFlyer.prototype.setMeasureSessionDuration = function(measureSessionDuration) {
    cordova.exec(null, null, "AppsFlyerPlugin", "setMeasureSessionDuration", [!!measureSessionDuration]);
  };

  AppsFlyer.prototype.setDeviceTrackingDisabled = function(disabled) {
    cordova.exec(null, null, "AppsFlyerPlugin", "setDeviceTrackingDisabled", [disabled]);
  };

  AppsFlyer.prototype.getAppsFlyerUID = function(callbackFn) {
    cordova.exec(function(result) {
        callbackFn(result);
      }, null,
      "AppsFlyerPlugin",
      "getAppsFlyerUID", []);
  };

  AppsFlyer.prototype.trackEvent = function(eventName, eventValues) {
    cordova.exec(null, null, "AppsFlyerPlugin", "trackEvent", [eventName, eventValues]);
  };

  AppsFlyer.prototype.onInstallConversionDataLoaded = function(conversionData) {
    var data = conversionData;
    if (typeof data === "string") {
      data = JSON.parse(conversionData);
    }
    global.AppsFlyer._conversionData = data;

    if (global.AppsFlyer._cbFuncConversionData) {
      global.AppsFlyer._cbFuncConversionData(global.AppsFlyer._conversionData);
    }
  };

  AppsFlyer.prototype.setCallbackConversionData = function(callbackFn) {
    global.AppsFlyer._cbFuncConversionData = callbackFn;

    if (global.AppsFlyer._conversionData) {
      global.AppsFlyer._cbFuncConversionData(global.AppsFlyer._conversionData);
    }
  };

  global.cordova.addConstructor(function() {
    if (!global.Cordova) {
      global.Cordova = global.cordova;
    };

    if (!global.plugins) {
      global.plugins = {};
    }

    global.AppsFlyer = new AppsFlyer();
  });
}(window));