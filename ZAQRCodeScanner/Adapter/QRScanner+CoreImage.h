//
//  QRScanner+CoreImage.h
//  ZAQRCodeScanner
//
//  Created by CPU11899 on 8/22/19.
//  Copyright © 2019 CPU11899. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Bussiness/QRDecodeManager.h"
#import "../Bussiness/DecodeProtocol.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QRScanner_CoreImage : NSObject <QRCodeDecodeMethod>
@property CIDetector* detectModule;
- (instancetype) init;
- (void) decodeFromImage:(CIImage*)image WithCompletionHandler:(void(^)(NSString*, NSException*)) completion;
@end

NS_ASSUME_NONNULL_END
