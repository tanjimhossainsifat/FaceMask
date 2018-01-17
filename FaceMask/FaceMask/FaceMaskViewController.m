//
//  FaceMaskViewController.m
//  FaceMask
//
//  Created by Tanjim Hossain on 1/17/18.
//  Copyright © 2018 Tanjim Hossain. All rights reserved.
//

#import "FaceMaskViewController.h"

@interface FaceMaskViewController ()
{
    UIImageView *imageView;
}

@end

@implementation FaceMaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *originalImage = [UIImage imageNamed:@"test3"];
    CGFloat originalRatio = originalImage.size.height/originalImage.size.width;
    
    imageView = [[UIImageView alloc] initWithImage:originalImage];
    [imageView setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width,  originalRatio * [[UIScreen mainScreen] bounds].size.width)];
    
    [self.view addSubview:imageView];
    
    [self detectFaceFeatures];
}

- (void) detectFaceFeatures {
    
    CIImage *originalImage = [CIImage imageWithCGImage:imageView.image.CGImage];
    
    CIDetector *faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:[NSDictionary dictionaryWithObject:CIDetectorAccuracyLow forKey:CIDetectorAccuracy]];
    
    NSArray *features = [faceDetector featuresInImage:originalImage];
    
    for(CIFaceFeature *face in features) {
        
        if(face.hasLeftEyePosition && face.hasRightEyePosition && face.hasMouthPosition) {
            
            
            CGRect modifiedRect = face.bounds;
            CGRect originalRect = originalImage.extent;
            modifiedRect.size.width = modifiedRect.size.width * (imageView.frame.size.width/originalRect.size.width);
            modifiedRect.size.height = modifiedRect.size.height * (imageView.frame.size.height/originalRect.size.height) ;
            modifiedRect.origin.x = modifiedRect.origin.x * (imageView.frame.size.width/originalRect.size.width);
            modifiedRect.origin.y = modifiedRect.origin.y * (imageView.frame.size.height/originalRect.size.height);
            modifiedRect.origin.y = imageView.frame.size.height - (modifiedRect.origin.y+modifiedRect.size.height);
            
            
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.path = CGPathCreateWithRect(modifiedRect, nil);
            imageView.layer.mask = maskLayer;
        }
    }
}
@end
