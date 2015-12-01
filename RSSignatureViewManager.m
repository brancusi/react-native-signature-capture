#import "RSSignatureViewManager.h"
#import "RCTBridgeModule.h"
#import "RCTBridge.h"
#import "RCTUIManager.h"
#import "RCTEventDispatcher.h"
#import "RCTSparseArray.h"

@implementation RSSignatureViewManager

RCT_EXPORT_MODULE()

@synthesize bridge = _bridge;
@synthesize signView;

-(UIView *) view
{
  self.signView = [[RSSignatureView alloc] init];
  self.signView.manager = self;
  return signView;
}

- (dispatch_queue_t)methodQueue
{
  return _bridge.uiManager.methodQueue;
}

RCT_EXPORT_METHOD(clearSignature:(nonnull NSNumber *)reactTag)
{
  [_bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, RCTSparseArray *viewRegistry) {
      RSSignatureView *view = viewRegistry[reactTag];
      [view clearSignature];
  }];
}

RCT_EXPORT_METHOD(saveSignature:(nonnull NSNumber *)reactTag)
{
  [_bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, RCTSparseArray *viewRegistry) {
      RSSignatureView *view = viewRegistry[reactTag];
      [view saveSignature];
  }];
}

-(void) dispatchSavedImage:(NSString *) aTempPath withEncoded: (NSString *) aEncoded {
  [self.bridge.eventDispatcher
   sendDeviceEventWithName:@"imageSaved"
   body:@{
          @"pathName": aTempPath,
          @"encoded": aEncoded
          }];
}

@end
