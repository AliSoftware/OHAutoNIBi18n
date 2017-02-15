//
//  OHAutoNIBi18n.h
//
//  Created by Olivier on 15/02/17.
//  Copyright 2010 FoodReporter. All rights reserved.
//


@interface OHAutoNIBi18n: NSObject
/// This method is only typically useful if you embed OHAutoNIBi18n in a framework
/// which contains storyboards & XIBs you want to auto-translate.
/// Because in that case, we'll typically have to looup for the localizations for your
/// storyboards & XIBs in your framework's bundle, and not in the host app's bundle
///
/// Call this method as early as possible in your framework life cycle (especially before
/// it loads any storyboard or XIB) to specify the bundle of your framework, and
/// optionally an alternate table name if it's named other than the default "Localizable"
///
/// @param bundle    The bundle of the framework containing the localization strings file
/// @param tableName The name of the strings file where to look up for localizations
///                  (without the ".strings" or ".stringsdict" extension). Defaults to "Localizable".
+ (void)setLocalizationBundle:(NSBundle* __nullable)bundle tableName:(NSString* __nullable)tableName;
@end
