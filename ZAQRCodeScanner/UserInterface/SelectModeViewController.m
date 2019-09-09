//
//  ViewController.m
//  ZAQRCodeScanner
//
//  Created by CPU11899 on 8/21/19.
//  Copyright © 2019 CPU11899. All rights reserved.
//

#import "SelectModeViewController.h"

@interface SelectModeViewController ()
@property UIImageView* logoImage;
@property UILabel* titleLabel;
@property UILabel* instructionLabel1;
@property UILabel* instructionLabel2;
@property UIButton* cameraScanButton;
@property UIButton* imageScanButton;
@end

@implementation SelectModeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.logoImage = [[UIImageView alloc] init];
    self.titleLabel = [[UILabel alloc] init];
    self.instructionLabel1 = [[UILabel alloc] init];
    self.instructionLabel2 = [[UILabel alloc] init];
    self.cameraScanButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.imageScanButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self loadViews];
}

#pragma mark : - Layout view
- (void) loadViews {
    self.logoImage.image = [UIImage imageNamed:@"scan-qr-code-icon-67"];
    self.titleLabel.text = @"Smart QR Code Scanner";
    self.titleLabel.font = [UIFont systemFontOfSize:25];
    self.titleLabel.lineBreakMode = NSLineBreakByClipping;
    self.titleLabel.numberOfLines = 1;
    self.titleLabel.minimumScaleFactor = 0.8;
    self.titleLabel.adjustsFontSizeToFitWidth = true;
    self.instructionLabel2.numberOfLines = 0;
    self.instructionLabel1.numberOfLines = 0;
    self.instructionLabel1.text = @"1. Choose camera scan to scan QR Code with camera";
    self.instructionLabel2.text = @"2. Choose image scan to scan QR code from image";
    
    [[self cameraScanButton] setTitle:@"Camera scan" forState:UIControlStateNormal];
    self.cameraScanButton.titleLabel.font = [UIFont systemFontOfSize:20];
    self.cameraScanButton.enabled = true;
    self.cameraScanButton.hidden = false;
    [[self cameraScanButton] addTarget:self action:@selector(scanQRWithCamera) forControlEvents:UIControlEventTouchUpInside];
    
    [[self imageScanButton] setTitle:@"Image scan" forState:UIControlStateNormal];
    self.imageScanButton.titleLabel.font = [UIFont systemFontOfSize:20];
    self.imageScanButton.enabled = true;
    self.imageScanButton.hidden = false;
    [[self imageScanButton] addTarget:self action:@selector(scanQRFromImage) forControlEvents:UIControlEventTouchUpInside];
    
    [[self view] addSubview:self.logoImage];
    [[self view] addSubview:self.titleLabel];
    [[self view] addSubview:self.instructionLabel1];
    [[self view] addSubview:self.instructionLabel2];
    [[self view] addSubview:self.cameraScanButton];
    [[self view] addSubview:self.imageScanButton];
}

- (CGFloat) calculateHeightOfStringWith:(CGFloat) fontSize MaxSize:(CGSize) maxSize AndString:(NSString*) string {
    __weak UIFont* font = [UIFont systemFontOfSize:fontSize];
    NSDictionary* attribute = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    NSAttributedString* attributeString = [[NSAttributedString alloc] initWithString:string attributes:attribute];
    CGRect textRect = [attributeString boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    CGFloat textHeight = textRect.size.height;
    font = nil;
    return textHeight;
}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGSize viewSize = self.view.bounds.size;
    CGFloat paddingOfsubView = viewSize.width / 10;
    CGFloat rangeToAboveSubView = viewSize.height / 8;
    
    self.logoImage.frame = CGRectMake(0, 0, viewSize.width / 3, viewSize.width / 3);
    self.logoImage.center = CGPointMake(viewSize.width / 2, rangeToAboveSubView + self.logoImage.frame.size.height/2);
    rangeToAboveSubView += self.logoImage.frame.size.height + paddingOfsubView;
    
    CGSize maxLabelSize = CGSizeMake(2 * viewSize.width / 3, 4 * viewSize.height / 5);
    CGFloat titleLabelHeight = [self calculateHeightOfStringWith:25 MaxSize:maxLabelSize AndString:self.titleLabel.text];
    self.titleLabel.frame = CGRectMake(0, 0, maxLabelSize.width, titleLabelHeight);
    self.titleLabel.center = CGPointMake(viewSize.width / 2, rangeToAboveSubView + self.titleLabel.frame.size.height / 2);
    rangeToAboveSubView += self.titleLabel.frame.size.height + paddingOfsubView;
    
    titleLabelHeight = [self calculateHeightOfStringWith:17 MaxSize:maxLabelSize AndString:self.instructionLabel1.text];
    self.instructionLabel1.frame = CGRectMake(0, 0, maxLabelSize.width, titleLabelHeight);
    self.instructionLabel1.center = CGPointMake(viewSize.width / 2, rangeToAboveSubView + self.instructionLabel1.frame.size.height / 2);
    rangeToAboveSubView += self.instructionLabel1.frame.size.height + paddingOfsubView;
    
    titleLabelHeight = [self calculateHeightOfStringWith:17 MaxSize:maxLabelSize AndString:self.instructionLabel2.text];
    self.instructionLabel2.frame = CGRectMake(0, 0, maxLabelSize.width, titleLabelHeight);
    self.instructionLabel2.center = CGPointMake(viewSize.width / 2, rangeToAboveSubView + self.instructionLabel2.frame.size.height);
    rangeToAboveSubView += self.instructionLabel2.frame.size.height + paddingOfsubView;
    
    CGSize maxButtonSize = CGSizeMake(2 * viewSize.width / 3, 4 * viewSize.height / 5);
    self.cameraScanButton.frame = CGRectMake(0, 0, maxButtonSize.width, 50);
    self.cameraScanButton.center = CGPointMake(viewSize.width / 2, rangeToAboveSubView + self.cameraScanButton.frame.size.height / 2);
    rangeToAboveSubView += self.cameraScanButton.frame.size.height + paddingOfsubView;
    
    self.imageScanButton.frame = CGRectMake(0, 0, maxButtonSize.width, 50);
    self.imageScanButton.center = CGPointMake(viewSize.width / 2, rangeToAboveSubView + self.imageScanButton.frame.size.height / 2);
}

- (BOOL) shouldAutorotate {
    return false;
}
#pragma mark :- button handler
- (void) scanQRWithCamera {
    QRCameraViewController* cameraViewController = [[QRCameraViewController alloc] init];
    //[self presentViewController:cameraViewController animated:true completion:nil];
    [[self navigationController] pushViewController:cameraViewController animated:true];
    cameraViewController = nil;
}

- (void) scanQRFromImage {
    SelectQRImageViewController* qrFromImageView = [[SelectQRImageViewController alloc] init];
    //[self presentViewController:qrFromImageView animated:true completion:nil];
    [[self navigationController] pushViewController:qrFromImageView animated:true];
    qrFromImageView = nil;
}
@end
