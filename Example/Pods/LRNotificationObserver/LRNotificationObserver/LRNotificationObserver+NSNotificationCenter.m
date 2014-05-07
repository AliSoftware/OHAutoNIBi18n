// LRNotificationObserver+NSNotificationCenter.m
//
// Copyright (c) 2014 Luis Recuenco
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "LRNotificationObserver+NSNotificationCenter.h"

@implementation LRNotificationObserver (NSNotificationCenter)

+ (instancetype)observerForName:(NSString *)name
                          block:(LRNotificationObserverBlock)block
{
    return [self observerForName:name object:nil block:block];
}

+ (instancetype)observerForName:(NSString *)name
                         object:(id)object
                          block:(LRNotificationObserverBlock)block
{
    return [self observerWithConfiguration:^(LRNotificationObserver *observer) {
        [observer configureForName:name object:object block:block];
    }];
}

+ (instancetype)observerForName:(NSString *)name
                 operationQueue:(NSOperationQueue *)operationQueue
                          block:(LRNotificationObserverBlock)block
{
    return [self observerForName:name object:nil operationQueue:operationQueue block:block];
}

+ (instancetype)observerForName:(NSString *)name
                         object:(id)object
                 operationQueue:(NSOperationQueue *)operationQueue
                          block:(LRNotificationObserverBlock)block
{
    return [self observerWithConfiguration:^(LRNotificationObserver *observer) {
        [observer configureForName:name object:object operationQueue:operationQueue block:block];
    }];
}

+ (instancetype)observerForName:(NSString *)name
                  dispatchQueue:(dispatch_queue_t)dispatchQueue
                          block:(LRNotificationObserverBlock)block
{
    return [self observerForName:name object:nil dispatchQueue:dispatchQueue block:block];
}

+ (instancetype)observerForName:(NSString *)name
                         object:(id)object
                  dispatchQueue:(dispatch_queue_t)dispatchQueue
                          block:(LRNotificationObserverBlock)block
{
    return [self observerWithConfiguration:^(LRNotificationObserver *observer) {
        [observer configureForName:name object:object dispatchQueue:dispatchQueue block:block];
    }];
}

+ (instancetype)observerForName:(NSString *)name
                         target:(id)target
                         action:(SEL)action
{
    return [self observerForName:name object:nil target:target action:action];
}

+ (instancetype)observerForName:(NSString *)name
                         object:(id)object
                         target:(id)target
                         action:(SEL)action
{
    return [self observerWithConfiguration:^(LRNotificationObserver *observer) {
        [observer configureForName:name object:object target:target action:action];
    }];
}

+ (instancetype)observerForName:(NSString *)name
                 operationQueue:(NSOperationQueue *)operationQueue
                         target:(id)target
                         action:(SEL)action
{
    return [self observerForName:name
                          object:nil
                  operationQueue:operationQueue
                          target:target
                          action:action];
}

+ (instancetype)observerForName:(NSString *)name
                         object:(id)object
                 operationQueue:(NSOperationQueue *)operationQueue
                         target:(id)target
                         action:(SEL)action
{
    return [self observerWithConfiguration:^(LRNotificationObserver *observer) {
        [observer configureForName:name
                            object:object
                    operationQueue:operationQueue
                            target:target
                            action:action];
    }];
}

+ (instancetype)observerForName:(NSString *)name
                  dispatchQueue:(dispatch_queue_t)dispatchQueue
                         target:(id)target
                         action:(SEL)action
{
    return [self observerForName:name object:nil dispatchQueue:dispatchQueue target:target action:action];
}

+ (instancetype)observerForName:(NSString *)name
                         object:(id)object
                  dispatchQueue:(dispatch_queue_t)dispatchQueue
                         target:(id)target
                         action:(SEL)action
{
    
    return [self observerWithConfiguration:^(LRNotificationObserver *observer) {
        [observer configureForName:name object:object dispatchQueue:dispatchQueue target:target action:action];
    }];
}

#pragma mark - Private

+ (LRNotificationObserver *)observerWithConfiguration:(void(^)(LRNotificationObserver *observer))configurationBlock
{
    LRNotificationObserver *observer = [self notificationCenterObserver];
    configurationBlock(observer);
    return observer;
}

+ (LRNotificationObserver *)notificationCenterObserver
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    return [[LRNotificationObserver alloc] initWithNotificationCenter:notificationCenter];
}

@end
