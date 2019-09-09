//
//  QRCameraViewController.h
//  ZAQRCodeScanner
//
//  Created by CPU11899 on 8/22/19.
//  Copyright © 2019 CPU11899. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "../Bussiness/QRDecodeManager.h"
#import "../Bussiness/LiveCameraComponent.h"
#import "DemoViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface QRCameraViewController : UIViewController <CameraCaptureDelegate>

@end

NS_ASSUME_NONNULL_END
