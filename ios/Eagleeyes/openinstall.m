#import "openinstall.h"
#import <TInstallSDK/TInstallSDK.h>


@import Eagleeyes.DevicePrint;
@implementation Openinstall

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(getAffCode:(RCTResponseSenderBlock)callback)
{
  NSString * _Nullable FixedAffCode = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"AffCode"];
  if(FixedAffCode.length != 0) {
    callback(@[FixedAffCode]);
  } else {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString * _Nullable affCode = [ud valueForKey:@"affCode"];

    if (affCode.length != 0) {
      callback(@[affCode]);
    } else {
      callback(@[@"err"]);
    }
  }
}

RCT_EXPORT_METHOD(getRafCode:(RCTResponseSenderBlock)callback)
{
  NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
  NSString * _Nullable raf = [ud valueForKey:@"raf"];

  if (raf.length != 0) {
    callback(@[raf]);
  } else {
    callback(@[@"err"]);
  }
}

RCT_EXPORT_METHOD(getPackageName:(RCTResponseSenderBlock)callback)
{
    NSString *packageName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    callback(@[packageName]);
}


RCT_EXPORT_METHOD(getE2BlackBox:(RCTResponseSenderBlock)callback)
{
  dispatch_async(dispatch_get_main_queue(), ^{
    NSString *blackbox = [DevicePrint getBlackBox];
    callback(@[[NSNull null],blackbox]);
  });
}






@end
