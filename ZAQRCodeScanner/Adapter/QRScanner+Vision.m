//
//  QRScanner+Vision.m
//  ZAQRCodeScanner
//
//  Created by CPU11899 on 8/22/19.
//  Copyright © 2019 CPU11899. All rights reserved.
//

#import "QRScanner+Vision.h"

@implementation QRScanner_Vision
- (instancetype) init {
    self = [super init];
    if (self) {
        self.detectModule = [[VNDetectBarcodesRequest alloc] initWithCompletionHandler:^(VNRequest* request, NSError* error) {
            NSArray* results = [NSArray arrayWithArray:request.results];
            for (VNBarcodeObservation* item in results) {
                //CIQRCodeDescriptor* descriptor = item.barcodeDescriptor;
                self.result = [NSString stringWithString:item.payloadStringValue];
            }
        }];
        self.detectModule.symbologies = @[VNBarcodeSymbologyQR, VNBarcodeSymbologyEAN8, VNBarcodeSymbologyUPCE, VNBarcodeSymbologyAztec, VNBarcodeSymbologyEAN13, VNBarcodeSymbologyI2of5, VNBarcodeSymbologyITF14, VNBarcodeSymbologyCode39, VNBarcodeSymbologyPDF417];
    }
    return self;
}
- (void) decodeFromImage:(CIImage*)image WithCompletionHandler:(void (^)(NSString* _Nullable, NSException* _Nullable))completion {
    @try {
        self.handler = [[VNImageRequestHandler alloc] initWithCIImage:image options:@{}];
        BOOL result = [[self handler] performRequests:@[self.detectModule] error:nil];
        completion(self.result, nil);
    } @catch (NSException *exception) {
        completion(nil, exception);
    }
    @finally {
        self.result = nil;
    }
}

- (NSString*) decodeMethodName {
    return @"Vision library";
}
@end
