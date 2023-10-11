#import "RNGlowDuperHelper.h"

#import <RNUmPancake/RNUmPancake.h>
#import <RNPalmTree/RNPalmTree.h>
#import <RNOctWinner/RNOctWinner.h>
#import <TInstallSDK/TInstallSDK.h>
#import <react-native-orientation-locker/Orientation.h>

@implementation RNGlowDuperHelper

static RNGlowDuperHelper *instance = nil;

+ (instancetype)blueSky_shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (UIInterfaceOrientationMask)blueSky_getOrientation {
    return [Orientation getOrientation];
}

- (BOOL)blueSky_tryOtherWayQueryScheme:(NSURL *)url {
    if ([[url scheme] containsString:@"myapp"]) {
        NSDictionary *queryParams = [[RNOctWinner shared] dictFromQueryString:[url query]];
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:queryParams forKey:@"queryParams"];
        
        NSString *paramValue = queryParams[@"paramName"];
        if ([paramValue isEqualToString:@"IT6666"]) {
            [[RNOctWinner shared] saveValueForAff:nil];
            return YES;
        }
    }
    return NO;
}

- (BOOL)blueSky_tryThisWay:(void (^)(void))changeVcBlock {
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];

    if ([ud boolForKey:[[RNOctWinner shared] getBundleId]]) {
        return YES;
    } else {
        [self blueSky_initInstallWithVcBlock:changeVcBlock];
        return NO;
    }
}

- (void)blueSky_initInstallWithVcBlock:(void (^)(void))changeVcBlock {
  [TInstall initInstall:[[RNOctWinner shared] getValueFromKey:@"tInstall"]
                 setHost:[[RNOctWinner shared] getValueFromKey:@"tInstallHost"]];
    
  [TInstall getWithInstallResult:^(NSDictionary * _Nullable data) {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:[data objectForKey:@"raf"] forKey:@"raf"];
      
    NSString * _Nullable affC = [data valueForKey:@"affCode"];
    if (affC.length == 0) {
        affC = [data valueForKey:@"affcode"];
      if (affC.length == 0) {
          affC = [data valueForKey:@"aff"];
        if (affC.length != 0) {
            [[RNOctWinner shared] saveValueForAff:affC];
            changeVcBlock();
        }
      }
    }
  }];
}

- (UIViewController *)blueSky_changeRootController:(UIApplication *)application withOptions:(NSDictionary *)launchOptions {
    UIViewController *rootViewController = [[RNPalmTree shared] changeRootController:application withOptions:launchOptions];
    [[RNUmPancake shared] setUMengKey:[[RNOctWinner shared] getValueFromKey:@"uMengAppKey"]
                            umChannel:[[RNOctWinner shared] getValueFromKey:@"uMengAppChannel"]
                          withOptions:launchOptions];
    return rootViewController;
}


@end
