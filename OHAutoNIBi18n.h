//
//  OHAutoNIBi18n.h
//
//  Created by Olivier on 03/11/10.
//  Copyright 2010 FoodReporter. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString* const OHAutoNIBi18nCustomBundle;

/**
 *  Updates the custom localization Bundle used by OHAutoNIBi18n instead of the app's main bundle
 *  @param customBundle The new Bundle
 */
void OHAutoNIBi18nSetCustomBundle(NSBundle *customBundle);

@interface NSObject(OHAutoNIBi18n)
/**
 *  Reloads this control's localized properties set by OHAutoNIBi18n
 */
-(void)updateLocalization;
@end