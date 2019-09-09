//
//  DemoViewController.m
//  ZAQRCodeScanner
//
//  Created by CPU11899 on 9/9/19.
//  Copyright © 2019 CPU11899. All rights reserved.
//

#import "DemoViewController.h"

@interface DemoViewController ()
@property UIImageView* imageView;
@end

@implementation DemoViewController

- (instancetype) initWithImage:(UIImage *)image {
    self = [super init];
    if (self) {
        self.image = image;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView = [[UIImageView alloc] init];
    // Do any additional setup after loading the view.
    [self loadViews];
}

- (void) loadViews {
    self.view.backgroundColor = [UIColor whiteColor];
    self.imageView.image = self.image;
    [[self view] addSubview:self.imageView];
}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.imageView.frame = CGRectMake(50, 100, self.image.size.width, self.image.size.height);
}

@end
