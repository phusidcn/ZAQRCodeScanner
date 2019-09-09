//
//  QRCodeProcess.h
//  ZAQRCodeScanner
//
//  Created by CPU11899 on 8/21/19.
//  Copyright © 2019 CPU11899. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "../Adapter/QRScanner+Vision.h"
#import "../Adapter/QRScanner+CoreImage.h"
#import "../Adapter/QRScanner+ZXing.h"
#import "DecodeProtocol.h"
#import "MethodArray.h"

NS_ASSUME_NONNULL_BEGIN

@interface QRDecodeManager : NSObject
@property MethodArray* methods;
@property BOOL scanComplete;
@property dispatch_queue_t threadSafeQueue;
@property NSOperationQueue* operationQueue;
@property NSOperationQueue* sessionQueue;
+ (instancetype) managerInstance;
- (void) decodeImage:(CIImage*) image WithCompletionHandler:(void(^)(NSString*, NSException* exception)) completion;
- (void) cancelProcessingRemainImage;
- (void) addImageToDecodeSession:(CIImage*) image WithCompletionHandler:(void(^)(NSString*, NSException* exception)) completion;
@end

NS_ASSUME_NONNULL_END
