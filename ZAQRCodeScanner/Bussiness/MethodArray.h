//
//  DecodeMethodArray.h
//  ZAQRCodeScanner
//
//  Created by CPU11899 on 8/26/19.
//  Copyright © 2019 CPU11899. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DecodeProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MethodArray : NSObject
@property NSMutableArray<id<QRCodeDecodeMethod>>* array;
+ (dispatch_queue_t) safeQueue;

- (void)addObject:(id<QRCodeDecodeMethod>)anObject;
- (void)insertObject:(id<QRCodeDecodeMethod>)anObject atIndex:(NSUInteger)index;
- (void)removeLastObject;
- (void)removeObjectAtIndex:(NSUInteger)index;
- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id<QRCodeDecodeMethod>)anObject;
- (instancetype)init NS_DESIGNATED_INITIALIZER;
- (id<QRCodeDecodeMethod>) objectAtIndex:(NSUInteger) index;
- (NSUInteger) count;
@end



NS_ASSUME_NONNULL_END
