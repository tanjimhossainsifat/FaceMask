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
    NSMutableArray *faceImageArray;
}

@end

@implementation FaceMaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    faceImageArray = [[NSMutableArray alloc] init];
    
    UIImage *originalImage = [UIImage imageNamed:@"test1"];
    CGFloat originalRatio = originalImage.size.height/originalImage.size.width;
    
    imageView = [[UIImageView alloc] initWithImage:originalImage];
    [imageView setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width,  originalRatio * [[UIScreen mainScreen] bounds].size.width)];
    
    [self.view addSubview:imageView];
    
    [self detectFaceFeatures];
    [self swapFaceImages];
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
            
            CGRect cropRect = face.bounds;
            cropRect.origin.y =  originalRect.size.height - (cropRect.origin.y+cropRect.size.height);
            CGImageRef imageRef = CGImageCreateWithImageInRect([imageView.image CGImage], cropRect);
            UIImage *faceImage = [UIImage imageWithCGImage:imageRef];
            CGImageRelease(imageRef);
            
            UIImageView *faceImageView = [[UIImageView alloc] initWithFrame:modifiedRect];
            faceImageView.image = faceImage;
            
            [faceImageArray addObject:faceImageView];
    
        }
    }
}

- (void) swapFaceImages {
    
    if([faceImageArray count] >= 2) {
        
        UIImageView *firstFaceImageView = [faceImageArray objectAtIndex:0];
        UIImageView *secondFaceImageView = [faceImageArray objectAtIndex:1];
        
        UIImage *tempImage = firstFaceImageView.image;
        firstFaceImageView.image = secondFaceImageView.image;
        secondFaceImageView.image = tempImage;
        
        [imageView addSubview:firstFaceImageView];
        [imageView addSubview:secondFaceImageView];
    }
    
}
@end
