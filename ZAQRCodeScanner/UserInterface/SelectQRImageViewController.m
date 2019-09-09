//
//  SelectQRImageViewController.m
//  ZAQRCodeScanner
//
//  Created by CPU11899 on 8/21/19.
//  Copyright © 2019 CPU11899. All rights reserved.
//

#import "SelectQRImageViewController.h"

@interface SelectQRImageViewController ()
@property UIButton* galleryButton;
@property UIButton* clearButton;
@property UIButton* scanButton;
@property UIImageView* previewImage;

@property BOOL qrRecognized;
@end

@implementation SelectQRImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.galleryButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.clearButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.scanButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.previewImage = [[UIImageView alloc] init];
    [self loadViews];
}

- (void) loadViews {
    
    self.previewImage.image = [UIImage imageNamed:@"no-image-icon-23492"];
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    
    [[self galleryButton] setTitle:@"Open gallery" forState:UIControlStateNormal];
    self.galleryButton.titleLabel.font = [UIFont systemFontOfSize:17];
    self.galleryButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.galleryButton.hidden = false;
    self.galleryButton.enabled = true;
    self.galleryButton.titleLabel.lineBreakMode = NSLineBreakByClipping;
    self.galleryButton.titleLabel.numberOfLines = 0;
    self.galleryButton.titleLabel.minimumScaleFactor = 0.8;
    self.galleryButton.titleLabel.adjustsFontSizeToFitWidth = true;
    [[self galleryButton] addTarget:self action:@selector(selectImageFromGallery) forControlEvents:UIControlEventTouchUpInside];
    
    [[self clearButton] setTitle:@"Clear selected image" forState:UIControlStateNormal];
    self.clearButton.titleLabel.font = [UIFont systemFontOfSize:17];
    self.clearButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.clearButton.hidden = false;
    self.clearButton.enabled = true;
    self.clearButton.titleLabel.lineBreakMode = NSLineBreakByClipping;
    self.clearButton.titleLabel.numberOfLines = 0;
    self.clearButton.titleLabel.minimumScaleFactor = 0.8;
    self.clearButton.titleLabel.adjustsFontSizeToFitWidth = true;
    [[self clearButton] addTarget:self action:@selector(clearSelectedImage) forControlEvents:UIControlEventTouchUpInside];
    
    [[self scanButton] setTitle:@"Scan QR code" forState:UIControlStateNormal];
    self.scanButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.scanButton.titleLabel.font = [UIFont systemFontOfSize:17];
    self.scanButton.hidden = false;
    self.scanButton.enabled = true;
    self.scanButton.titleLabel.lineBreakMode = NSLineBreakByClipping;
    self.scanButton.titleLabel.numberOfLines = 0;
    self.scanButton.titleLabel.minimumScaleFactor = 0.8;
    self.scanButton.titleLabel.adjustsFontSizeToFitWidth = true;
    [[self scanButton] addTarget:self action:@selector(scanQRImage) forControlEvents:UIControlEventTouchUpInside];
    
    [[self view] addSubview:self.galleryButton];
    [[self view] addSubview:self.clearButton];
    [[self view] addSubview:self.previewImage];
    [[self view] addSubview:self.scanButton];
}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGSize viewSize = self.view.bounds.size;
    CGFloat safeAreaInsectTop = self.view.safeAreaInsets.top;
    CGFloat safeAreaInsectLeft = self.view.safeAreaInsets.left;
    CGFloat padding = 30;
    self.previewImage.frame = CGRectMake(0 + padding + safeAreaInsectTop, 0 + padding + safeAreaInsectLeft, 7 * viewSize.width / 8, 5 * viewSize.height / 10);
    self.previewImage.center = CGPointMake(viewSize.width / 2, 8 * viewSize.height / 20 + safeAreaInsectTop);
    
    self.galleryButton.frame = CGRectMake(0, 8 * viewSize.height / 10 + padding, viewSize.width / 3, 1 * viewSize.height / 10);
    
    self.scanButton.frame = CGRectMake(viewSize.width / 3, 8 * viewSize.height / 10 + padding, viewSize.width / 3, 1 * viewSize.height / 10);
    
    self.clearButton.frame = CGRectMake(2 * viewSize.width / 3, 8 * viewSize.height / 10 + padding, viewSize.width / 3, 1 * viewSize.height / 10);
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:true completion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.previewImage.image = image;
        });
    }];
}

- (void) selectImageFromGallery {
    UIImagePickerController* pickImageController = [[UIImagePickerController alloc] init];
    pickImageController.delegate = self;
    pickImageController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:pickImageController animated:true completion:nil];
}

- (void) clearSelectedImage {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.previewImage.image = [UIImage imageNamed:@"no-image-icon-23492"];
    });
}

- (void) scanQRImage {
    self.qrRecognized = false;
    CIImage* ciImage = [[CIImage alloc] initWithImage:self.previewImage.image];
    [[QRDecodeManager managerInstance] decodeImage:ciImage WithCompletionHandler:^(NSString* result, NSException* exception) {
        if (!self.qrRecognized && !exception) {
            self.qrRecognized = true;
            [self showScanResult:result];
        } else {
            if (exception) {
                NSLog(@"%@", [exception reason]);
            }
        }
    }];
}

- (void) showScanResult:(NSString*) result {
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Scanning result" message:result preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* copyAction = [UIAlertAction actionWithTitle:@"Copy" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = result;
    }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    if (!result) {
        [alertController setTitle:@"Cannot detect QR Code Content"];
    } else {
        [alertController addAction:copyAction];
    }
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:true completion:nil];
}
@end
