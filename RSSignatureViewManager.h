#import "RSSignatureView.h"
#import "RCTViewManager.h"

@interface RSSignatureViewManager : RCTViewManager
@property (nonatomic, strong) RSSignatureView *signView;

-(void) dispatchSavedImage:(NSString *) aTempPath withEncoded: (NSString *) aEncoded;

@end
