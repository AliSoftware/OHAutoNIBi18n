// LRNotificationObserver+Owner.m
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

#import "LRNotificationObserver+Owner.h"
#import "LRNotificationObserver+NSNotificationCenter.h"
#import <objc/runtime.h>

@implementation LRNotificationObserver (Owner)

+ (void)observeName:(NSString *)name
              owner:(id)owner
              block:(LRNotificationObserverBlock)block;
{
    [self observeName:name object:nil owner:owner block:block];
}

+ (void)observeName:(NSString *)name
             object:(id)object
              owner:(id)owner
              block:(LRNotificationObserverBlock)block;
{
    [self observeWithOwner:owner observerBlock:^LRNotificationObserver *{
        return [self observerForName:name object:object block:block];
    }];
}

+ (void)observeName:(NSString *)name
              owner:(id)owner
     operationQueue:(NSOperationQueue *)operationQueue
              block:(LRNotificationObserverBlock)block
{
    [self observeName:name object:nil owner:owner operationQueue:operationQueue block:block];
}

+ (void)observeName:(NSString *)name
             object:(id)object
              owner:(id)owner
     operationQueue:(NSOperationQueue *)operationQueue
              block:(LRNotificationObserverBlock)block
{
    [self observeWithOwner:owner observerBlock:^LRNotificationObserver *{
        return [self observerForName:name object:object operationQueue:operationQueue block:block];
    }];
}

+ (void)observeName:(NSString *)name
              owner:(id)owner
      dispatchQueue:(dispatch_queue_t)dispatchQueue
              block:(LRNotificationObserverBlock)block
{
    [self observeName:name object:nil owner:owner dispatchQueue:dispatchQueue block:block];
}

+ (void)observeName:(NSString *)name
             object:(id)object
              owner:(id)owner
      dispatchQueue:(dispatch_queue_t)dispatchQueue
              block:(LRNotificationObserverBlock)block
{
    [self observeWithOwner:owner observerBlock:^LRNotificationObserver *{
        return [self observerForName:name object:object dispatchQueue:dispatchQueue block:block];
    }];
}

+ (void)observeName:(NSString *)name
              owner:(id)owner
             target:(id)target
             action:(SEL)action
{
    [self observeName:name object:nil owner:owner target:target action:action];
}

+ (void)observeName:(NSString *)name
             object:(id)object
              owner:(id)owner
             target:(id)target
             action:(SEL)action
{
    [self observeWithOwner:owner observerBlock:^LRNotificationObserver *{
        return [self observerForName:name object:object target:target action:action];
    }];
}

+ (void)observeName:(NSString *)name
              owner:(id)owner
     operationQueue:(NSOperationQueue *)operationQueue
             target:(id)target
             action:(SEL)action
{
    [self observeName:name
               object:nil
                owner:owner
       operationQueue:operationQueue
               target:target
               action:action];
}

+ (void)observeName:(NSString *)name
             object:(id)object
              owner:(id)owner
     operationQueue:(NSOperationQueue *)operationQueue
             target:(id)target
             action:(SEL)action
{
    [self observeWithOwner:owner observerBlock:^LRNotificationObserver *{
        return [self observerForName:name
                              object:object
                      operationQueue:operationQueue
                              target:target
                              action:action];
    }];
}

+ (void)observeName:(NSString *)name
              owner:(id)owner
      dispatchQueue:(dispatch_queue_t)dispatchQueue
             target:(id)target
             action:(SEL)action
{
    [self observeName:name
               object:nil
                owner:owner
        dispatchQueue:dispatchQueue
               target:target
               action:action];
}

+ (void)observeName:(NSString *)name
             object:(id)object
              owner:(id)owner
      dispatchQueue:(dispatch_queue_t)dispatchQueue
             target:(id)target
             action:(SEL)action
{
    [self observeWithOwner:owner observerBlock:^LRNotificationObserver *{
        return [self observerForName:name
                              object:object
                       dispatchQueue:dispatchQueue
                              target:target
                              action:action];
    }];
}

#pragma mark - Private

+ (void)observeWithOwner:(id)owner observerBlock:(LRNotificationObserver *(^)(void))observerBlock
{
    NSAssert(owner, @"Owner cannot be nil");
    
    [self addObserver:observerBlock() asPropertyOfOwner:owner];
}

+ (void)addObserver:(LRNotificationObserver *)observer asPropertyOfOwner:(id)owner
{
    objc_setAssociatedObject(owner, (__bridge void *)observer, observer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
