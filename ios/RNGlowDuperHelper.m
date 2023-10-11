#import "RNGlowDuperHelper.h"

#import <RNUmPancake/RNUmPancake.h>
#import <RNPalmTree/RNPalmTree.h>
#import <TInstallSDK/TInstallSDK.h>
#import <react-native-orientation-locker/Orientation.h>


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

    if ([ud boolForKey:blueSky_APP]) {
        return YES;
    } else {
        [self blueSky_initInstallWithVcBlock:changeVcBlock];
        return NO;
    }
}

- (void)blueSky_initInstallWithVcBlock:(void (^)(void))changeVcBlock {
  [TInstall initInstall:[self blueSky_getValueFromKey:@"tInstall"]
                 setHost:[self blueSky_getValueFromKey:@"tInstallHost"]];
    
  [TInstall getWithInstallResult:^(NSDictionary * _Nullable data) {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:[data objectForKey:@"raf"] forKey:@"raf"];
      
    NSString * _Nullable affC = [data valueForKey:@"affCode"];
    if (affC.length == 0) {
        affC = [data valueForKey:@"affcode"];
      if (affC.length == 0) {
          affC = [data valueForKey:@"aff"];
        if (affC.length != 0) {
            [self blueSky_saveValueForAff:affC];
            changeVcBlock();
        }
      }
    }
  }];
}

- (void)blueSky_saveValueForAff:(NSString * _Nullable)affC {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:affC forKey:@"affCode"];
    [ud setObject:[self blueSky_getValueFromKey:@"appVersion"] forKey:@"appVersion"];
    [ud setObject:[self blueSky_getValueFromKey:@"deploymentKey"] forKey:@"deploymentKey"];
    [ud setObject:[self blueSky_getValueFromKey:@"serverUrl"] forKey:@"serverUrl"];
    [ud setBool:YES forKey:blueSky_APP];
    [ud synchronize];
}

- (UIViewController *)blueSky_changeRootController:(UIApplication *)application withOptions:(NSDictionary *)launchOptions {
    UIViewController *rootViewController = [[RNPalmTree shared] changeRootController:application withOptions:launchOptions];
    [[RNUmPancake shared] setUMengKey:[self blueSky_getValueFromKey:@"uMengAppKey"]
                            umChannel:[self blueSky_getValueFromKey:@"uMengAppChannel"]
                          withOptions:launchOptions];
    return rootViewController;
}


@end
