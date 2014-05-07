// LRNotificationObserver.m
//
// Copyright (c) 2013 Luis Recuenco
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

#import "LRNotificationObserver.h"
#import <objc/message.h>

#if OS_OBJECT_USE_OBJC
#define LRDispatchQueuePropertyModifier strong
#else
#define LRDispatchQueuePropertyModifier assign
#endif

#pragma mark - LRTargetAction

@interface LRTargetAction : NSObject

@property (nonatomic, weak) id target;
@property (nonatomic) SEL action;

+ (instancetype)targetActionWithTarget:(id)target action:(SEL)action;

@end

@implementation LRTargetAction

+ (instancetype)targetActionWithTarget:(id)target action:(SEL)action
{
    LRTargetAction *targetAction = [[self alloc] init];
    targetAction.target = target;
    targetAction.action = action;
    
    return targetAction;
}

@end

#pragma mark - LRNotificationObserver

static SEL sNoArgumentsSelector;
static SEL sOneArgumentsSelector;

@interface LRNotificationObserver ()

@property (nonatomic, strong) NSNotificationCenter *notificationCenter;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, weak) id object;

// Blocked based
@property (nonatomic, copy) LRNotificationObserverBlock block;

// Target - selector based
@property (nonatomic, strong) LRTargetAction *targetAction;

// Calback queues
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, LRDispatchQueuePropertyModifier) dispatch_queue_t dispatchQueue;

@end

@implementation LRNotificationObserver

+ (void)initialize
{
    if (self == [LRNotificationObserver class])
    {
        sNoArgumentsSelector = @selector(notificationFired);
        sOneArgumentsSelector = @selector(notificationFired:);
    }
}

- (instancetype)initWithNotificationCenter:(NSNotificationCenter *)notificationCenter
{
    NSParameterAssert(notificationCenter);
    
    self = [super init];
    if (self)
    {
        _notificationCenter = notificationCenter;
    }
    return self;
}

- (void)configureForName:(NSString *)name block:(LRNotificationObserverBlock)block
{
    [self configureForName:name object:nil block:block];
}

- (void)configureForName:(NSString *)name
                  object:(id)object
                   block:(LRNotificationObserverBlock)block
{
    [self configureForName:name
                    object:object
            operationQueue:nil
             dispatchQueue:nil
                     block:block];
}

- (void)configureForName:(NSString *)name
          operationQueue:(NSOperationQueue *)operationQueue
                   block:(LRNotificationObserverBlock)block
{
    [self configureForName:name
                    object:nil
            operationQueue:operationQueue
                     block:block];
}

- (void)configureForName:(NSString *)name
                  object:(id)object
          operationQueue:(NSOperationQueue *)operationQueue
                   block:(LRNotificationObserverBlock)block
{
    [self configureForName:name
                    object:object
            operationQueue:operationQueue
             dispatchQueue:nil
                     block:block];
}

- (void)configureForName:(NSString *)name
           dispatchQueue:(dispatch_queue_t)dispatchQueue
                   block:(LRNotificationObserverBlock)block
{
    [self configureForName:name
                    object:nil
             dispatchQueue:dispatchQueue
                     block:block];
}

- (void)configureForName:(NSString *)name
                  object:(id)object
           dispatchQueue:(dispatch_queue_t)dispatchQueue
                   block:(LRNotificationObserverBlock)block
{
    [self configureForName:name
                    object:object
            operationQueue:nil
             dispatchQueue:dispatchQueue
                     block:block];
}

- (void)configureForName:(NSString *)name
                  object:(id)object
          operationQueue:(NSOperationQueue *)operationQueue
           dispatchQueue:(dispatch_queue_t)dispatchQueue
                   block:(LRNotificationObserverBlock)block
{
    NSParameterAssert(block);
    
    [self stopObserving];
    
    self.name = name;
    self.object = object;
    self.operationQueue = operationQueue;
    self.dispatchQueue = dispatchQueue;
    self.block = block;
    
    [self.notificationCenter addObserver:self
                                selector:sOneArgumentsSelector
                                    name:name
                                  object:object];
}

- (void)configureForName:(NSString *)name target:(id)target action:(SEL)action
{
    [self configureForName:name
                    object:nil
                    target:target
                    action:action];
}

- (void)configureForName:(NSString *)name
                  object:(id)object
				  target:(id)target
				  action:(SEL)action
{
    [self configureForName:name
                    object:object
                    target:target
                    action:action
            operationQueue:nil
             dispatchQueue:nil];
}

- (void)configureForName:(NSString *)name
          operationQueue:(NSOperationQueue *)operationQueue
				  target:(id)target
				  action:(SEL)action
{
    [self configureForName:name
                    object:nil
            operationQueue:operationQueue
                    target:target
                    action:action];
}

- (void)configureForName:(NSString *)name
                  object:(id)object
          operationQueue:(NSOperationQueue *)operationQueue
				  target:(id)target
				  action:(SEL)action
{
    [self configureForName:name
                    object:object
                    target:target
                    action:action
            operationQueue:operationQueue
             dispatchQueue:nil];
}

- (void)configureForName:(NSString *)name
           dispatchQueue:(dispatch_queue_t)dispatchQueue
				  target:(id)target
				  action:(SEL)action
{
    [self configureForName:name
                    object:nil
                    target:target
                    action:action
            operationQueue:nil
             dispatchQueue:dispatchQueue];
}

- (void)configureForName:(NSString *)name
                  object:(id)object
           dispatchQueue:(dispatch_queue_t)dispatchQueue
				  target:(id)target
				  action:(SEL)action
{
    [self configureForName:name
                    object:object
                    target:target
                    action:action
            operationQueue:nil
             dispatchQueue:dispatchQueue];
}

- (void)configureForName:(NSString *)name
                  object:(id)object
                  target:(id)target
                  action:(SEL)action
          operationQueue:(NSOperationQueue *)operationQueue
           dispatchQueue:(dispatch_queue_t)dispatchQueue
{
    [self stopObserving];
    
    self.name = name;
    self.object = object;
    self.operationQueue = operationQueue;
    self.dispatchQueue = dispatchQueue;
    self.targetAction = [LRTargetAction targetActionWithTarget:target action:action];
    
    NSUInteger selectorArgumentCount = LRSelectorArgumentCount(target, action);
    
    SEL correctSelector = NULL;
    
    if (selectorArgumentCount == 0)
    {
        correctSelector = sNoArgumentsSelector;
    }
    else if (selectorArgumentCount == 1)
    {
        correctSelector = sOneArgumentsSelector;
    }
    else
    {
        NSAssert(NO, @"Wrong number of parameters");
    }
    
    [self.notificationCenter addObserver:self
                                selector:correctSelector
                                    name:name
                                  object:object];
}

#pragma mark - Callbacks

- (void)notificationFired
{
    dispatch_block_t notificationFiredBlock = ^{
        objc_msgSend(self.targetAction.target, self.targetAction.action);
    };
    
    [self executeNotificationFiredBlock:notificationFiredBlock];
}

- (void)notificationFired:(NSNotification *)notification
{
    dispatch_block_t notificationFiredBlock = ^{
        if (self.block)
        {
            self.block(notification);
        }
        
        objc_msgSend(self.targetAction.target, self.targetAction.action, notification);
    };
    
    [self executeNotificationFiredBlock:notificationFiredBlock];
}

- (void)executeNotificationFiredBlock:(dispatch_block_t)block
{
    if (self.operationQueue)
    {
        [self.operationQueue addOperationWithBlock:block];
    }
    else if (self.dispatchQueue)
    {
        dispatch_async(self.dispatchQueue, block);
    }
    else
    {
        block();
    }
}

- (void)stopObserving
{
    [_notificationCenter removeObserver:self name:_name object:_object];
    [self clear];
}

- (void)clear
{
    _block = nil;
    _targetAction = nil;
    _operationQueue = nil;
    
#if !OS_OBJECT_USE_OBJC
    if (_dispatchQueue)
    {
        dispatch_release(_dispatchQueue);
    }
#endif
    _dispatchQueue = nil;
}

- (void)dealloc
{
    [self stopObserving];
}

NS_INLINE NSUInteger LRSelectorArgumentCount(id target, SEL selector)
{
    Method method = class_getInstanceMethod([target class], selector);
    NSInteger arguments = method_getNumberOfArguments(method);
    
    NSCAssert(arguments >= 2, @"Oops, wrong arguments"); /* 2 = self + _cmd */
    
    return arguments - 2;
}

@end
