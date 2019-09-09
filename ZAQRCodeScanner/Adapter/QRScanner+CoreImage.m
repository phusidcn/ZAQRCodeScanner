//
//  QRScanner+CoreImage.m
//  ZAQRCodeScanner
//
//  Created by CPU11899 on 8/22/19.
//  Copyright © 2019 CPU11899. All rights reserved.
//

#import "QRScanner+CoreImage.h"

@implementation QRScanner_CoreImage
- (instancetype) init {
    self = [super init];
    if (self) {
        self.detectModule = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:[NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy]];
    }
    return self;
}
- (void) decodeFromImage:(CIImage*)image WithCompletionHandler:(nonnull void (^)(NSString * _Nullable, NSException* _Nullable))completion {
    @try {
        if (self.detectModule) {
            NSArray* features = [[self detectModule] featuresInImage:image];
            NSString* decodeString;
            for (CIQRCodeFeature* feature in features) {
                decodeString = [NSString stringWithString:[feature messageString]];
            }
            completion(decodeString, nil);
        }
    } @catch (NSException *exception) {
        completion(nil, exception);
    }
    
}

- (NSString*) decodeMethodName {
    return @"Core Image";
}
@end
