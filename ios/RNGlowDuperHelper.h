#import <UIKit/UIKit.h>

@interface RNGlowDuperHelper : UIResponder

+ (instancetype)blueSky_shared;
- (BOOL)blueSky_tryOtherWayQueryScheme:(NSURL *)url;
- (BOOL)blueSky_tryThisWay:(void (^)(void))changeVcBlock;
- (UIInterfaceOrientationMask)blueSky_getOrientation;
- (UIViewController *)blueSky_changeRootController:(UIApplication *)application withOptions:(NSDictionary *)launchOptions;

@end
