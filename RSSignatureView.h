#import "PPSSignatureView.h"
#import <UIKit/UIKit.h>
#import "RCTView.h"
#import "RCTBridge.h"
#import "RCTBridgeModule.h"

@class RSSignatureViewManager;

@interface RSSignatureView : RCTView <RCTBridgeModule>
@property (nonatomic, strong) PPSSignatureView *sign;
@property (nonatomic, strong) RSSignatureViewManager *manager;
-(void) clearSignature;
-(void) saveSignature;
@end
