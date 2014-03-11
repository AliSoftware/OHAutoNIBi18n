LRNotificationObserver
======================
LRNotificationObserver is a smarter, simpler and better way to use NSNotificationCenter with [RAII](http://en.wikipedia.org/wiki/Resource_Acquisition_Is_Initialization).

### The problem about NSNotificationCenter

The typical use of NSNotificationCenter is a two-step process:

1. Register for a specific notification.

   ```
   [[NSNotificationCenter defaultCenter] addObserver:anObserver
                                             selector:@selector(handleNotification:)
                                                 name:aNotificationName
                                               object:anObjectThatFiresTheNotification];
   ```

2. Unregister from it.

   ```
   [[NSNotificationCenter defaultCenter] removeObserver:anObserver
                                                    name:aNotificationName
                                                  object:anObjectThatFiresTheNotification];
   ```

   You can also unsubscribe from every notification some observer may have registered for.

   ```
   [[NSNotificationCenter defaultCenter] removeObserver:self];
   ```

When using this code in a UIViewController subclass, we usually put the subscribe code in *init*, *viewDidLoad* or *view(Will/Did)Appear* and the unsubscribe code in *dealloc*, *viewDidUnload* or *view(Will/Did)Disappear*. Make sure to only unsubscribe from all notifications at once in dealloc unless you also want to unsubscribe from every notification the parent class may have subscribed. This is a typical problem in UIViewControllers when you unsubscribe from all notifications in viewDidDisappear by mistake and you stop receiving rotation events. Rule of thumb: unsubscribe from what you have explictly subscribed...

There are two main problems with that API:

1. In the most common use of NSNotificationCenter, we will unsubscribe from all the notifications when the observer dies, that means, we have to override dealloc just to put that unsubscribe code. With ARC, it'd be nice if we didn't have to do this.

2. We can only supply a selector, not a block.

Yes, not that big of a deal, this is not as a bad API as KVO is, but annoying still.

The second problem was solved by Apple when they introduced blocks to the language with iOS 4 and Mac OS X 10.6. The new way to listen to notifications is not [as harmful as some say](http://sealedabstract.com/code/nsnotificationcenter-with-blocks-considered-harmful/).

```
id observer = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidReceiveMemoryWarningNotification
                                                                object:nil
                                                                 queue:[NSOperationQueue mainQueue]
                                                            usingBlock:^(NSNotification *note) {
                                                                // Handle notification
                                                            }];
```

The real problem about this new API is that it is misunderstood most of the times. It returns an anonymous object (the observer) which must be saved just to unsubscribe when needed.

```
[[NSNotificationCenter defaultCenter] removeObserver:observer];
```

That makes us not only saving that observer in our class, but also overriding dealloc and removing it from the notification center.

So, when Apple introduced this new API... why not using RAII and let that new observer unsubscribe from the notification when it dies? Why making us store that object to unsubscribe later which, in a lot of cases, is forgotten?

This is the issue LRNotificationObserver tries to solve.

### Installation

1. **Using CocoaPods**

   Add LRNotificationObserver to your Podfile:

   ```
   platform :ios, "6.0"
   pod 'LRNotificationObserver'
   ```

   Run the following command:

   ```
   pod install
   ```

2. **Manually**

   Clone the project or add it as a submodule. Drag the whole LRNotificationObserver folder to your project.

### Usage

To listen to notifications, you have to create a LRNotificationObserver instance. To do so, just use the following method.

```
+ (instancetype)observerForName:(NSString *)name
                          block:(LRNotificationObserverBlock)block;
```

When the notification with that name is fired, the block will be executed.

The LRNotificationObserverBlock contains the NSNotification instance.

```
typedef void(^LRNotificationObserverBlock)(NSNotification *note);
```

Imagine you want to listen to background notifications, instead of using NSNotificationCenter and having to implement dealloc just to unsubscribe, you can simply hold a LRNotificationObserver property in the object where you want to handle the notification (your view controller for instance) and let it be released when the object dies. No more overriding dealloc just to unsubscribe from notifications. It is as simple as follows.

```
@property (nonatomic, strong) LRNotificationObserver *backgroundObserver;

self.backgroundObserver = [LRNotificationObserver observerForName:UIApplicationDidEnterBackgroundNotification
                                                            block:^(NSNotification *note) {
                                                                // Do appropriate background task
                                                            }];
```

The most interesting method in LRNotificationObserver is *stopObserving* in case you want to unsubscribe in other places different from dealloc (*viewWillDisappear* from instance).

Most times you just want to unsubscribe in dealloc. Having to create the observer property just to maintain the latter alive can be a little annoying. It's cleaner than implementing dealloc to do so for sure, but it's even cleaner not to do it... There's a way to do that, just use the following method.

```
+ (void)observeName:(NSString *)name
              owner:(id)owner
              block:(LRNotificationObserverBlock)block;
```

You must provide an owner, which is in charge of retaining the observer which is created under the hood. Don't worry, that owner won't be retained whatsover. The observer will be attached to the owner at runtime and release it when the latter is deallocated.

Imagine you want to listen to memory warning notifications. Just use the following code.

```
[LRNotificationObserver observeName:UIApplicationDidReceiveMemoryWarningNotification
                              owner:self
                              block:^(NSNotification *note) {
                                  // Purge unnecessary cache
                              }];
```

That's it, no deallocs, no new properties, just that code. Of cource, there are [other more obscure ways](http://www.merowing.info/2012/03/automatic-removal-of-nsnotificationcenter-or-kvo-observers/) to achieve the same thing.

There are various ways of getting the notification callbacks. You can use blocks or target-action pattern and specify the queue (NSOperationQueue and dispatch queue) in which you want to receive the callbacks. You can also specify the object from which you want to receive the notifications.

Imagine you want to update the UI in a specific method when receving a notification. The following code does so.

```
[LRNotificationObserver observeName:@"someNotificationThatShouldUpdateTheUI"
                             object:anObject
                              owner:anOwner
                     dispatch_queue:dispatch_get_main_queue()
                             target:viewController
                           selector:@selector(methodToBeExecutedOnMainThread:)];
```

When using the target-action callback, you can choose to receive the notification object (specify : in the selector) or not. Just the same way as NSNotificationCenter *addObserver:selector:name:object:* works despite what Apple says...

```
notificationSelector
Selector that specifies the message the receiver sends notificationObserver to notify it of the notification posting. The method specified by notificationSelector must have one and only one argument (an instance of NSNotification).
```

### Tests

In order to run the test suit, you should have the latest version of xctool. This can be done as follows.

```
rake test:prepare_for_xctool
```

After that, running the tests is as simple as executing the rakefile.

```
rake
```

### Example

To run the simple example, remember to install cocoa pods dependencies first.

```
rake test:cocoa_pods
```

### Requirements

LRNotificationObserver requires both iOS 6.0 and ARC.

You can still use LRNotificationObserver in your non-arc project. Just set -fobjc-arc compiler flag in every source file.

### Contact

LRNotificationObserver was created by Luis Recuenco: [@luisrecuenco](https://twitter.com/luisrecuenco).

### Contributing

If you want to contribute to the project just follow this steps:

1. Fork the repository.
2. Clone your fork to your local machine.
3. Create your feature branch with the appropriate tests.
4. Commit your changes, run the tests, push to your fork and submit a pull request.

## License

LRNotificationObserver is available under the MIT license. See the [LICENSE file](https://github.com/luisrecuenco/LRNotificationObserver/blob/master/LICENSE) for more info.
