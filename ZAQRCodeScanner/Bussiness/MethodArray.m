//
//  DecodeMethodArray.m
//  ZAQRCodeScanner
//
//  Created by CPU11899 on 8/26/19.
//  Copyright © 2019 CPU11899. All rights reserved.
//

#import "MethodArray.h"

@implementation MethodArray

+ (dispatch_queue_t) safeQueue {
    static dispatch_queue_t queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("com.safe.thread", DISPATCH_QUEUE_CONCURRENT);
    });
    return queue;
}

- (void) addObject:(id<QRCodeDecodeMethod>)anObject {
    dispatch_barrier_async([MethodArray safeQueue], ^{
        [[self array] addObject:anObject];
    });
}

- (void) insertObject:(id<QRCodeDecodeMethod>)anObject atIndex:(NSUInteger)index {
    dispatch_barrier_async([MethodArray safeQueue], ^{
        [[self array] insertObject:anObject atIndex:index];
    });
}

- (void) removeLastObject {
    dispatch_barrier_async([MethodArray safeQueue], ^{
        [[self array] removeLastObject];
    });
}

- (void) removeObjectAtIndex:(NSUInteger)index {
    dispatch_barrier_async([MethodArray safeQueue], ^{
        [[self array] removeObjectAtIndex:index];
    });
}

- (void) replaceObjectAtIndex:(NSUInteger)index withObject:(id<QRCodeDecodeMethod>)anObject {
    dispatch_barrier_async([MethodArray safeQueue], ^{
        [[self array] replaceObjectAtIndex:index withObject:anObject];
    });
}

- (instancetype) init {
    self = [super init];
    if (self) {
        self.array = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id<QRCodeDecodeMethod>) objectAtIndex:(NSUInteger )index {
    __block id<QRCodeDecodeMethod> object;
    dispatch_sync([MethodArray safeQueue], ^{
        object = [[self array] objectAtIndex:index];
    });
    return object;
}

- (NSUInteger) count {
    __block NSUInteger result;
    dispatch_sync([MethodArray safeQueue], ^{
        result = self.array.count;
    });
    return result;
}
@end
