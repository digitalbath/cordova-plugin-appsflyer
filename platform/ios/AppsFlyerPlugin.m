#import "AppsFlyerPlugin.h"
#import "AppsFlyerTracker.h"

@implementation AppsFlyerPlugin

@synthesize callbackId;

- (CDVPlugin *)initWithWebView:(UIWebView *)theWebView
{
    self = (AppsFlyerPlugin *)[super initWithWebView:theWebView];
    return self;
}

- (void)initSdk:(CDVInvokedUrlCommand*)command
{
    if ([command.arguments count] < 2) {
        return;
    }
    
    self.callbackId = command.callbackId;
    
    [self.commandDelegate runInBackground:^{
        
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_NO_RESULT];
        // leave communication channel open with keepcallback
        [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        
    }];
    
    NSString* devKey = [command.arguments objectAtIndex:0];
    NSString* appId = [command.arguments objectAtIndex:1];
    
    
    [AppsFlyerTracker sharedTracker].appleAppID = appId;
    [AppsFlyerTracker sharedTracker].appsFlyerDevKey = devKey;
    [[AppsFlyerTracker sharedTracker] trackAppLaunch];
    [self performSelector:@selector(initDelegate) withObject:nil afterDelay:7];
}

- (void) initDelegate{
    [AppsFlyerTracker sharedTracker].delegate = self;
}

- (void)setCurrencyCode:(CDVInvokedUrlCommand*)command
{
    if ([command.arguments count] == 0) {
        return;
    }
    
    NSString* currencyId = [command.arguments objectAtIndex:0];
    [AppsFlyerTracker sharedTracker].currencyCode = currencyId;
}

- (void)setCustomerUserId:(CDVInvokedUrlCommand *)command
{
    if ([command.arguments count] == 0) {
        return;
    }
    
    NSString* userId = [command.arguments objectAtIndex:0];
    [AppsFlyerTracker sharedTracker].customerUserID  = userId;
}

- (void)setUserEmails:(CDVInvokedUrlCommand *)command
{
    if ([command.arguments count] == 0) {
        return;
    }
    
    NSArray* emails = [command.arguments objectAtIndex:0];
    NSString* cryptMethodValue = @"";
    EmailCryptType cryptMethod;

    if ([command.arguments count] == 2) {
        cryptMethodValue = [command.arguments objectAtIndex:1];
    }

    if ([@"md5" isEqualToString:cryptMethodValue]) {
        cryptMethod = EmailCryptTypeMD5;
    } else if ([@"sha1" isEqualToString:cryptMethodValue]) {
        cryptMethod = EmailCryptTypeSHA1;
    } else {
        cryptMethod = EmailCryptTypeNone;
    }

    [[AppsFlyerTracker sharedTracker] setUserEmails:emails withCryptType:cryptMethod];
}

- (void)setDeviceTrackingDisabled:(CDVInvokedUrlCommand *)command
{
    if ([command.arguments count] == 0) {
        return;
    }
    
    BOOL disabled = [@(YES) isEqual:[command.arguments objectAtIndex:0]];
    [AppsFlyerTracker sharedTracker].deviceTrackingDisabled = disabled;
}

- (void)disableAppleAdSupportTracking:(CDVInvokedUrlCommand *)command
{
    if ([command.arguments count] == 0) {
        return;
    }
    
    BOOL disabled = [@(YES) isEqual:[command.arguments objectAtIndex:0]];
    [AppsFlyerTracker sharedTracker].disableAppleAdSupportTracking = disabled;
}

- (void)getAppsFlyerUID:(CDVInvokedUrlCommand *)command
{
    NSString* userId = [[AppsFlyerTracker sharedTracker] getAppsFlyerUID];
    CDVPluginResult *pluginResult = [ CDVPluginResult
                                    resultWithStatus    : CDVCommandStatus_OK
                                    messageAsString: userId
                                    ];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)trackEvent:(CDVInvokedUrlCommand *)command
{
    if ([command.arguments count] < 2) {
        return;
    }
    
    NSString* eventName = [command.arguments objectAtIndex:0];
    NSDictionary* eventValues = [command.arguments objectAtIndex:1];
    [[AppsFlyerTracker sharedTracker] trackEvent:eventName withValues:eventValues];
}

- (void)onConversionDataReceived:(NSDictionary*) installData {
    
    if (self.callbackId) {
        NSLog(@"[AppsFlyer Plugin] onConversionDataReceived: sending plugin result");
        
        
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:installData];
        [result setKeepCallback:[NSNumber numberWithBool:YES]];
        [self.commandDelegate sendPluginResult:result callbackId:self.callbackId];
    }
    else {
        NSLog(@"[AppsFlyer Plugin] onConversionDataReceived: Error self.callbackId empty");
    }
}

- (void)onConversionDataRequestFailure:(NSError *) error {
    
    NSString *errorMessage = [error localizedDescription];
    NSLog(@"[AppsFlyer Plugin] onConversionDataRequestFailure: %@", [error localizedDescription]);
    
    if (self.callbackId) {
        NSLog(@"[AppsFlyer Plugin] onConversionDataRequestFailure: sending error");
        
        CDVPluginResult *commandResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:errorMessage];
        [self.commandDelegate sendPluginResult:commandResult callbackId:self.callbackId];
    }
    else {
        NSLog(@"[AppsFlyer Plugin] onConversionDataRequestFailure: Error self.callbackId empty");
    }
}

@end
