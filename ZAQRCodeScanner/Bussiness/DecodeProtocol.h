//
//  DecodeProtocol.h
//  ZAQRCodeScanner
//
//  Created by CPU11899 on 8/26/19.
//  Copyright © 2019 CPU11899. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#ifndef DecodeProtocol_h
#define DecodeProtocol_h
@protocol QRCodeDecodeMethod <NSObject>

- (void) decodeFromImage:(CIImage*)image WithCompletionHandler:(void(^)(NSString*, NSException*))completion;
- (NSString*) decodeMethodName;
@end

#endif /* DecodeProtocol_h */
