#import <FSSwitchDataSource.h>
#import <FSSwitchPanel.h>

#import <Foundation/Foundation.h>
#include <dispatch/dispatch.h>

@interface SBWiFiManager
+ (id)sharedInstance;
- (BOOL)wiFiEnabled;
- (void)setWiFiEnabled:(BOOL)enabled;
@end

@interface WifiSwitch : NSObject <FSSwitchDataSource>
@end

%hook SBWiFiManager

- (void)_powerStateDidChange
{
	%orig();
	[[FSSwitchPanel sharedPanel] stateDidChangeForSwitchIdentifier:[NSBundle bundleForClass:[WifiSwitch class]].bundleIdentifier];
}

%end

@implementation WifiSwitch

- (FSSwitchState)stateForSwitchIdentifier:(NSString *)switchIdentifier
{
	return [[%c(SBWiFiManager) sharedInstance] wiFiEnabled];
}

- (void)applyState:(FSSwitchState)newState forSwitchIdentifier:(NSString *)switchIdentifier
{
	if (newState == FSSwitchStateIndeterminate)
		return;
	[[%c(SBWiFiManager) sharedInstance] setWiFiEnabled:newState];
}

@end
