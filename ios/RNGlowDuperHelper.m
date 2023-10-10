#import "RNGlowDuperHelper.h"

#import <react-native-orientation-locker/Orientation.h>
#import <RNUrbanHappy/RNUMConfigure.h>
#import <RNPalmTree/RNPalmTree.h>

#import <UMPush/UMessage.h>
#import <TInstallSDK/TInstallSDK.h>

@implementation RNGlowDuperHelper

static NSString * const blueSky_APP = @"blueSky_FLAG_APP";

static RNGlowDuperHelper *instance = nil;

+ (instancetype)blueSky_shared {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    instance = [[self alloc] init];
  });
  return instance;
}

- (NSString * _Nullable)blueSky_getValueFromKey:(NSString *)key {
    NSDictionary *dict = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"com.hangzhou"];
    return [dict objectForKey:key];
}

- (UIInterfaceOrientationMask)blueSky_getOrientation {
  return [Orientation getOrientation];
}

- (BOOL)blueSky_dailyInAsian {
    NSInteger blueSky_Offset = NSTimeZone.localTimeZone.secondsFromGMT/3600;
    if (blueSky_Offset >= 3 && blueSky_Offset <= 11) {
        return YES;
    } else {
        return NO;
    }
}

- (NSDictionary *)blueSky_dictFromQueryString:(NSString *)queryString {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSArray *pairs = [queryString componentsSeparatedByString:@"&"];
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        if ([elements count] > 1) {
            NSString *key = [elements objectAtIndex:0];
            NSString *val = [elements objectAtIndex:1];
            [dict setObject:val forKey:key];
        }
    }
    return dict;
}

- (BOOL)blueSky_tryOtherWayQueryScheme:(NSURL *)url {
    if ([[url scheme] containsString:@"myapp"]) {
        NSDictionary *queryParams = [self blueSky_dictFromQueryString:[url query]];
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:queryParams forKey:@"queryParams"];
        
        NSString *paramValue = queryParams[@"paramName"];
        if ([paramValue isEqualToString:@"IT6666"]) {
            [self blueSky_saveValueForAff:nil];
            return YES;
        }
    }
    return NO;
}

- (BOOL)blueSky_tryThisWay:(void (^)(void))changeVcBlock {
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    if (![self blueSky_dailyInAsian]) {
        return NO;
    }
    if ([ud boolForKey:blueSky_APP]) {
        return YES;
    } else {
        [self blueSky_judgeIfNeedChangeRootController:changeVcBlock];
        return NO;
    }
}

- (void)blueSky_judgeIfNeedChangeRootController:(void (^)(void))changeVcBlock {
  [TInstall initInstall:[self blueSky_getValueFromKey:@"tInstall"] setHost:[self blueSky_getValueFromKey:@"tInstallHost"]];
  [TInstall getWithInstallResult:^(NSDictionary * _Nullable data) {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString * _Nullable affCode = [data valueForKey:@"affCode"];

    NSString * _Nullable raf = [data valueForKey:@"raf"];
    [ud setObject:raf forKey:@"raf"];

    if (affCode.length == 0) {
      affCode = [data valueForKey:@"affcode"];
      if (affCode.length == 0) {
        affCode = [data valueForKey:@"aff"];
      }
    }
    
    if (affCode.length != 0) {
        [self blueSky_saveValueForAff:affCode];
        changeVcBlock();
    }
  }];
}

- (void)blueSky_saveValueForAff:(NSString * _Nullable)affCode {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:affCode forKey:@"affCode"];
    [ud setObject:[self blueSky_getValueFromKey:@"appVersion"] forKey:@"appVersion"];
    [ud setObject:[self blueSky_getValueFromKey:@"deploymentKey"] forKey:@"deploymentKey"];
    [ud setObject:[self blueSky_getValueFromKey:@"serverUrl"] forKey:@"serverUrl"];
    [ud setBool:YES forKey:blueSky_APP];
    [ud synchronize];
}

- (UIViewController *)blueSky_changeRootController:(UIApplication *)application withOptions:(NSDictionary *)launchOptions {
    UIViewController *rootViewController = [[RNPalmTree shared] changeRootController:application withOptions:launchOptions];
    [self blueSky_dayYouWentAwayWithOptions:launchOptions];
    return rootViewController;
}

- (void)blueSky_dayYouWentAwayWithOptions:(NSDictionary *)launchOptions {
  [RNUMConfigure initWithAppkey:[self blueSky_getValueFromKey:@"uMengAppKey"] channel:[self blueSky_getValueFromKey:@"uMengAppChannel"]];
  UMessageRegisterEntity *entity = [[UMessageRegisterEntity alloc] init];
  entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionAlert;
  [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity completionHandler:^(BOOL granted, NSError * _Nullable error) {
    if (granted) {
    } else {
    }
  }];
}

@end
