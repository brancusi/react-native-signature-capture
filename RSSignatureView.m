#import "RSSignatureView.h"
#import "RCTConvert.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "PPSSignatureView.h"
#import "RSSignatureViewManager.h"

#define DEGREES_TO_RADIANS(x) (M_PI * (x) / 180.0)

@implementation RSSignatureView {
  CAShapeLayer *_border;
  BOOL _loaded;
  EAGLContext *_context;
  UILabel *titleLabel;
}

RCT_EXPORT_MODULE();

@synthesize sign;
@synthesize manager;

- (instancetype)init
{
  self = [super init];
  return self;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  if (!_loaded) {
    _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];

    CGSize screen = self.bounds.size;

    self.sign = [[PPSSignatureView alloc]
                 initWithFrame: CGRectMake(0, 0, screen.width, screen.height)
                 context: _context];

    [self addSubview:sign];
  }

  _loaded = true;
}

-(void) saveSignature
{
  UIImage *signImage = [self.sign signatureImage];
  UIImage *signImageRotated = [self imageRotatedByDegrees:signImage deg:-90];

  NSError *error;

  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths firstObject];
  NSString *tempPath = [documentsDirectory stringByAppendingFormat:@"/signature.png"];

  //remove if file already exists
  if ([[NSFileManager defaultManager] fileExistsAtPath:tempPath]) {
    [[NSFileManager defaultManager] removeItemAtPath:tempPath error:&error];
    if (error) {
      NSLog(@"Error: %@", error.debugDescription);
    }
  }

  // Convert UIImage object into NSData (a wrapper for a stream of bytes) formatted according to PNG spec
  NSData *imageData = UIImagePNGRepresentation(signImageRotated);
  BOOL isSuccess = [imageData writeToFile:tempPath atomically:YES];
  if (isSuccess) {
    NSString *base64Encoded = [imageData base64EncodedStringWithOptions:0];
    [self.manager dispatchSavedImage: tempPath withEncoded:base64Encoded];
  }
}

-(void) clearSignature
{
  [self.sign erase];
}

- (UIImage *)imageRotatedByDegrees:(UIImage*)oldImage deg:(CGFloat)degrees{
  //Calculate the size of the rotated view's containing box for our drawing space
  UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,oldImage.size.width, oldImage.size.height)];
  CGAffineTransform t = CGAffineTransformMakeRotation(degrees * M_PI / 180);
  rotatedViewBox.transform = t;
  CGSize rotatedSize = rotatedViewBox.frame.size;

  //Create the bitmap context
  UIGraphicsBeginImageContext(rotatedSize);
  CGContextRef bitmap = UIGraphicsGetCurrentContext();

  //Move the origin to the middle of the image so we will rotate and scale around the center.
  CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);

  //Rotate the image context
  CGContextRotateCTM(bitmap, (degrees * M_PI / 180));

  //Now, draw the rotated/scaled image into the context
  CGContextScaleCTM(bitmap, 1.0, -1.0);
  CGContextDrawImage(bitmap, CGRectMake(-oldImage.size.width / 2, -oldImage.size.height / 2, oldImage.size.width, oldImage.size.height), [oldImage CGImage]);

  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return newImage;
}

@end
