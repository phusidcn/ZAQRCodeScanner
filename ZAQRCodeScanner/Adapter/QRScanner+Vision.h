//
//  QRScanner+Vision.h
//  ZAQRCodeScanner
//
//  Created by CPU11899 on 8/22/19.
//  Copyright © 2019 CPU11899. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Vision/Vision.h>
#import <UIKit/UIKit.h>
#import "../Bussiness/DecodeProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface QRScanner_Vision : NSObject <QRCodeDecodeMethod>
@property VNDetectBarcodesRequest* detectModule;
@property VNImageRequestHandler* handler;
@property NSString* _Nullable result;
- (instancetype) init;
- (void) decodeFromImage:(CIImage*)image WithCompletionHandler:(void (^)(NSString*, NSException*)) completion;
@end

NS_ASSUME_NONNULL_END
