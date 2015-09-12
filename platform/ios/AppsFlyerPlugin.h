#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>
#import "AppsFlyerTracker.h"


@interface AppsFlyerPlugin : CDVPlugin <UIApplicationDelegate, AppsFlyerTrackerDelegate> {
    NSString *callbackId;
}

@property (nonatomic, copy) NSString *callbackId;

- (void)setCurrencyCode:(CDVInvokedUrlCommand*)command;
- (void)setCustomerUserId:(CDVInvokedUrlCommand*)command;
- (void)getAppsFlyerUID:(CDVInvokedUrlCommand*)command;
- (void)trackEvent:(CDVInvokedUrlCommand*)command;
- (void)onConversionDataReceived:(NSDictionary*) installData;
- (void)onConversionDataRequestFailure:(NSError *) error;
@end