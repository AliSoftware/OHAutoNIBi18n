//
//  OHAutoNIBi18n.m
//
//  Created by Olivier on 03/11/10.
//  Copyright 2010 FoodReporter. All rights reserved.
//

#import "OHAutoNIBi18n.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>
#import <LRNotificationObserver+Owner.h>
#import <NSObject+AssociatedDictionary.h>

NSString* const OHAutoNIBi18nCustomBundle = @"OHAutoNIBi18nCustomBundle";

static inline NSString* localizedString(NSString* aString);

static inline void localizeUIBarButtonItem(UIBarButtonItem* bbi);
static inline void localizeUIBarItem(UIBarItem* bi);
static inline void localizeUIButton(UIButton* btn);
static inline void localizeUILabel(UILabel* lbl);
static inline void localizeUINavigationItem(UINavigationItem* ni);
static inline void localizeUISearchBar(UISearchBar* sb);
static inline void localizeUISegmentedControl(UISegmentedControl* sc);
static inline void localizeUITextField(UITextField* tf);
static inline void localizeUITextView(UITextView* tv);
static inline void localizeUIViewController(UIViewController* vc);
static inline BOOL isLocalizable(NSObject *obj);
static NSBundle *_customBundle = nil;

void OHAutoNIBi18nSetCustomBundle(NSBundle *customBundle) {
    if (customBundle && [customBundle isKindOfClass:[NSBundle class]] && customBundle != _customBundle) {
        _customBundle = customBundle;
        NSLog(@"Locale changed! New bundle: %@", _customBundle);
    }
}

// ------------------------------------------------------------------------------------------------
#define LocalizeIfClass(Cls) if ([self isKindOfClass:[Cls class]]) localize##Cls((Cls*)self)
@implementation NSObject(OHAutoNIBi18n)

-(void)updateLocalization {
    LocalizeIfClass(UIBarButtonItem);
	else LocalizeIfClass(UIBarItem);
	else LocalizeIfClass(UIButton);
	else LocalizeIfClass(UILabel);
	else LocalizeIfClass(UINavigationItem);
	else LocalizeIfClass(UISearchBar);
	else LocalizeIfClass(UISegmentedControl);
	else LocalizeIfClass(UITextField);
	else LocalizeIfClass(UITextView);
	else LocalizeIfClass(UIViewController);
    
    if (self.isAccessibilityElement == YES)
    {
        if (!self.associatedDictionary[@"accessibilityLabel"]) {
            self.associatedDictionary[@"accessibilityLabel"] = self.accessibilityLabel ?: @"";
            self.associatedDictionary[@"accessibilityHint"] = self.accessibilityHint ?: @"";
        }
        self.accessibilityLabel = localizedString(self.associatedDictionary[@"accessibilityLabel"]);
        self.accessibilityHint = localizedString(self.associatedDictionary[@"accessibilityHint"]);
    }
}

@end

@interface NSObject(OHAutoNIBi18n_Internal)
-(void)localizeNibObject;
@end

@implementation NSObject(OHAutoNIBi18n_Internal)

-(void)localizeNibObject
{
    // Only observe or try to localize items if needed.
    if (isLocalizable(self)) {
#ifdef OHAutoNIBi18n_OBSERVE_LOCALE
        [LRNotificationObserver observeName:NSCurrentLocaleDidChangeNotification owner:self block:^(NSNotification *notification) {
            NSLog(@"Updating localization for %@ to %@", self, [[_customBundle bundlePath]lastPathComponent]);
            [self updateLocalization];
        }];
#endif

        [self updateLocalization];
    }
    // Call the original awakeFromNib method
	[self localizeNibObject]; // this actually calls the original awakeFromNib (and not localizeNibObject) because we did some method swizzling
}

#ifndef OHAutoNIBi18n_AUTOLOAD_OFF
+(void)load
{
    // Autoload : swizzle -awakeFromNib with -localizeNibObject as soon as the app (and thus this class) is loaded
	Method localizeNibObject = class_getInstanceMethod([NSObject class], @selector(localizeNibObject));
	Method awakeFromNib = class_getInstanceMethod([NSObject class], @selector(awakeFromNib));
	method_exchangeImplementations(awakeFromNib, localizeNibObject);
}
#endif

@end

/////////////////////////////////////////////////////////////////////////////

static NSString* localizedString(NSString* aString)
{
	if ([aString length] == 0)
		return nil;
    
    // Don't translate strings starting with a digit
	if ([[NSCharacterSet decimalDigitCharacterSet] characterIsMember:[aString characterAtIndex:0]])
		return aString;
	
    NSBundle *srcBundle = _customBundle ? _customBundle : [NSBundle mainBundle];
    
#ifdef OHAutoNIBi18n_DEBUG
#warning Debug mode for i18n is active
    static NSString* const kNoTranslation = @"";
	NSString* tr = [srcBundle localizedStringForKey:aString value:kNoTranslation table:nil];
	if ([tr isEqualToString:kNoTranslation])
    {
		if ([aString hasPrefix:@"•."])
        {
			// strings in XIB starting with '.' are typically used as temporary placeholder for design
            // and will be replaced by code later, so don't warn about them
			return aString;
		}
		NSLog(@"No translation for string '%@'",aString);
		tr = [NSString stringWithFormat:@"$%@$",aString];
	}
	return tr;
#else
    NSLog(@"string: %@, localization: %@", aString, NSLocalizedString(aString, kNoTranslation));
    return [srcBundle localizedStringForKey:aString value:nil table:nil];
#endif
}


// ------------------------------------------------------------------------------------------------


static void localizeUIBarButtonItem(UIBarButtonItem* bbi) {
	localizeUIBarItem(bbi); /* inheritence */

	NSMutableSet* locTitles = [[NSMutableSet alloc] initWithCapacity:[bbi.possibleTitles count]];
    if (bbi.possibleTitles.count > 0 && !bbi.associatedDictionary[@"possibleTitles[1]"]) {
        int i = 0;
        for (NSString *possibleTitle in bbi.possibleTitles) {
            bbi.associatedDictionary[[NSString stringWithFormat:@"possibleTitles[%i]", i++]] = possibleTitle ?: @"";
        }
    }
    int i = 0;
	for(NSString* str in bbi.possibleTitles) {
		[locTitles addObject:localizedString(bbi.associatedDictionary[[NSString stringWithFormat:@"possibleTitles[%i]", i++]])];
	}
	bbi.possibleTitles = [NSSet setWithSet:locTitles];
#if ! __has_feature(objc_arc)
	[locTitles release];
#endif
}

static void localizeUIBarItem(UIBarItem* bi) {
    if (!bi.associatedDictionary[@"title"]) {
        bi.associatedDictionary[@"title"] = bi.title ?: @"";
    }
	bi.title = localizedString(bi.associatedDictionary[@"title"]);
}

static void localizeUIButton(UIButton* btn) {
    NSString *title[4];
    if (!btn.associatedDictionary[@"titleForState:UIControlStateNormal"]) {
        btn.associatedDictionary[@"titleForState:UIControlStateNormal"] = [btn titleForState:UIControlStateNormal] ?: @"";
        btn.associatedDictionary[@"titleForState:UIControlStateHighlighted"] = [btn titleForState:UIControlStateHighlighted] ?: @"";
        btn.associatedDictionary[@"titleForState:UIControlStateDisabled"] = [btn titleForState:UIControlStateDisabled] ?: @"";
        btn.associatedDictionary[@"titleForState:UIControlStateSelected"] = [btn titleForState:UIControlStateSelected] ?: @"";
    }
    title[0] = btn.associatedDictionary[@"titleForState:UIControlStateNormal"];
    title[1] = btn.associatedDictionary[@"titleForState:UIControlStateHighlighted"];
    title[2] = btn.associatedDictionary[@"titleForState:UIControlStateDisabled"];
    title[3] = btn.associatedDictionary[@"titleForState:UIControlStateSelected"];

	[btn setTitle:localizedString(title[0]) forState:UIControlStateNormal];
	if (title[1] == [btn titleForState:UIControlStateHighlighted])
		[btn setTitle:localizedString(title[1]) forState:UIControlStateHighlighted];
	if (title[2] == [btn titleForState:UIControlStateDisabled])
		[btn setTitle:localizedString(title[2]) forState:UIControlStateDisabled];
	if (title[3] == [btn titleForState:UIControlStateSelected])
		[btn setTitle:localizedString(title[3]) forState:UIControlStateSelected];
}

static void localizeUILabel(UILabel* lbl) {
    if (!lbl.associatedDictionary[@"text"]) {
        lbl.associatedDictionary[@"text"] = lbl.text ?: @"";
    }
	lbl.text = localizedString(lbl.associatedDictionary[@"text"]);
}

static void localizeUINavigationItem(UINavigationItem* ni) {
    
    if (!ni.associatedDictionary[@"title"]) {
        ni.associatedDictionary[@"title"] = ni.title ?: @"";
        ni.associatedDictionary[@"prompt"] = ni.prompt ?: @"";
    }
    
	ni.title = localizedString(ni.associatedDictionary[@"title"]);
	ni.prompt = localizedString(ni.associatedDictionary[@"prompt"]);
}

static void localizeUISearchBar(UISearchBar* sb) {

	NSMutableArray* locScopesTitles = [[NSMutableArray alloc] initWithCapacity:[sb.scopeButtonTitles count]];
    
    if (!sb.associatedDictionary[@"placeholder"]) {
        sb.associatedDictionary[@"placeholder"] = sb.placeholder ?: @"";
        sb.associatedDictionary[@"prompt"] = sb.prompt ?: @"";
        sb.associatedDictionary[@"text"] = sb.text ?: @"";
        int i = 0;
        for (NSString *scopeTitle in sb.scopeButtonTitles) {
            sb.associatedDictionary[[NSString stringWithFormat:@"scopeButtonTitles[%i]", i++]] = scopeTitle ?: @"";
        }
    }
    
	sb.placeholder = localizedString(sb.placeholder);
	sb.prompt = localizedString(sb.prompt);
	sb.text = localizedString(sb.text);
	
    int i = 0;
	for(NSString* str in sb.scopeButtonTitles) {
		[locScopesTitles addObject:localizedString(sb.associatedDictionary[[NSString stringWithFormat:@"scopeButtonTitles[%i]", i++]])];
	}
	sb.scopeButtonTitles = [NSArray arrayWithArray:locScopesTitles];
#if ! __has_feature(objc_arc)
	[locScopesTitles release];
#endif
}

static void localizeUISegmentedControl(UISegmentedControl* sc) {

	NSUInteger n = sc.numberOfSegments;
    
    if (n > 0 && !sc.associatedDictionary[@"titleForSegmentAtIndex:0"]) {
        for (int i = 0; i < n; i++) {
            sc.associatedDictionary[[NSString stringWithFormat:@"titleForSegmentAtIndex:%i", i]] = [sc titleForSegmentAtIndex:i] ?: @"";
        }
    }
    
	for(int idx = 0; idx<n; ++idx) {
		[sc setTitle:localizedString(sc.associatedDictionary[[NSString stringWithFormat:@"titleForSegmentAtIndex:%i", idx]]) forSegmentAtIndex:idx];
	}
}

static void localizeUITextField(UITextField* tf) {
    if (!tf.associatedDictionary[@"text"]) {
        tf.associatedDictionary[@"text"] = tf.text ?: @"";
        tf.associatedDictionary[@"placeholder"] = tf.placeholder ?: @"";
    }
	tf.text = localizedString(tf.associatedDictionary[@"text"]);
	tf.placeholder = localizedString(tf.associatedDictionary[@"placeholder"]);
}

static void localizeUITextView(UITextView* tv) {
    if (!tv.associatedDictionary[@"text"]) {
        tv.associatedDictionary[@"text"] = tv.text ?: @"";
    }
	tv.text = localizedString(tv.associatedDictionary[@"text"]);
}

static void localizeUIViewController(UIViewController* vc) {
    if (!vc.associatedDictionary[@"title"]) {
        vc.associatedDictionary[@"title"] = vc.title ?: @"";
    }
	vc.title = localizedString(vc.associatedDictionary[@"title"]);
}

static BOOL isLocalizable(NSObject *obj) {
    return ([obj isKindOfClass:[UIBarButtonItem class]] ||
            [obj isKindOfClass:[UIBarItem class]] ||
            [obj isKindOfClass:[UIButton class]] ||
            [obj isKindOfClass:[UILabel class]] ||
            [obj isKindOfClass:[UINavigationItem class]] ||
            [obj isKindOfClass:[UISearchBar class]] ||
            [obj isKindOfClass:[UISegmentedControl class]] ||
            [obj isKindOfClass:[UITextField class]] ||
            [obj isKindOfClass:[UITextView class]] ||
            [obj isKindOfClass:[UIViewController class]]
            );
}

