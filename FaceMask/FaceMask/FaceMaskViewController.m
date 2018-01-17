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
    
    UIImage *originalImage = [UIImage imageNamed:@"test2"];
    CGFloat originalRatio = originalImage.size.height/originalImage.size.width;
    
    imageView = [[UIImageView alloc] initWithImage:originalImage];
    [imageView setFrame:CGRectMake(0, 0, self.view.frame.size.width, originalRatio * self.view.frame.size.width)];
    [imageView setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    
    [self.view addSubview:imageView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
