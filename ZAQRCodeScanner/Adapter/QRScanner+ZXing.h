//
//  QRScanner+ZXing.h
//  ZAQRCodeScanner
//
//  Created by CPU11899 on 8/26/19.
//  Copyright © 2019 CPU11899. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Bussiness/DecodeProtocol.h"
#import "../ExternalLib/ZXingObjC/ZXingObjC.h"
NS_ASSUME_NONNULL_BEGIN

@interface QRScanner_ZXing : NSObject <QRCodeDecodeMethod>
@property ZXLuminanceSource* luminateSource;
@property ZXBinaryBitmap* binaryBitmap;
@property ZXDecodeHints* hint;
@property ZXMultiFormatReader* reader;
@property CIContext* context;
- (instancetype) init;
- (void) decodeFromImage:(CIImage*)image WithCompletionHandler:(void (^)(NSString *, NSException*))completion;
- (NSString*) decodeMethodName;
@end

NS_ASSUME_NONNULL_END
