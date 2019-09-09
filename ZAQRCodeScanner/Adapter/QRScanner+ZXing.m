//
//  QRScanner+ZXing.m
//  ZAQRCodeScanner
//
//  Created by CPU11899 on 8/26/19.
//  Copyright © 2019 CPU11899. All rights reserved.
//

#import "QRScanner+ZXing.h"

@implementation QRScanner_ZXing
- (instancetype) init {
    self = [super init];
    if (self) {
        self.context = [[CIContext alloc] init];
    }
    return self;
}

- (void) decodeFromImage:(CIImage*)image WithCompletionHandler:(void (^)(NSString * _Nullable, NSException* _Nullable))completion {
    @try {
        CGImageRef cgImage = [self.context createCGImage:image fromRect:image.extent];
        self.luminateSource = [[ZXCGImageLuminanceSource alloc] initWithCGImage:cgImage];
        self.binaryBitmap = [ZXBinaryBitmap binaryBitmapWithBinarizer:[ZXHybridBinarizer binarizerWithSource:self.luminateSource]];
        NSError *error = nil;
        self.hint = [ZXDecodeHints hints];
        self.reader = [ZXMultiFormatReader reader];
        ZXResult *result = [[self reader] decode:self.binaryBitmap
                                           hints:self.hint
                                           error:&error];
        CGImageRelease(cgImage);
        if (result) {
            NSString *contents = result.text;
            completion (contents, nil);
        }
    } @catch (NSException *exception) {
        completion(nil, exception);
    }
}

- (NSString*) decodeMethodName {
    return @"ZXing External library";
}
@end
