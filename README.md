# What's this

This class allows you to **automate the internationalisation** (i18n) of your interface (XIB files) **without any additional code in your application**. No more using multiple XIBs for various locales or having outlets just to translate the text of a label!

Simply use the keys of your Localizable.strings in the text of any element in your XIB
(title of an `UIButton`, text of a `UILabel`, …), and it will be automatically translated on the fly at runtime!

* You don't need to have one XIB file by language/locale any more!
* You don't need to have an `IBOutlet` to all of your XIB objects just to translate their text manually by code with `NSLocalizedString`!

> Note: strings starting with a digit won't be translated. This is a feature used to avoid useless translation of static numbers you put in your XIB (especially because you will probably change this "0.00" string in your XIB with some real value by code later)


# Installation

To use this, simply **add `OHAutoNIBi18n.m` in your project** and… that's all! `OHAutoNIBi18n` will be loaded automatically at runtime and translate your XIB on the fly without any additional line of code.

If you also want to use the `_T()`, `_Tf()` and `_Tfn()` macros, you can also add and `#import "OHL10nMacros.h"`.

Alternatively, you can install all of it using CocoaPods. Simply add `pod "OHAutoNIBi18n"` to your `Podfile`.


# Debugging your unlocalized strings

You can `#define OHAutoNIBi18n_DEBUG 1` if you want `OHAutoNIBi18n` to warn every time it encounters a string for which it does not find any translation in your `Localizable.strings` file. In that case, it will log a message in your console and add the `$` character around the text in your XIB at runtime so you can easily see it.

> Note that you can use strings starting with a "." in your XIB (like ".Lorem ipsum dolor sit amet" to avoid warnings on those strings when `OHAutoNIBi18n_DEBUG` is set. This is useful for your strings you use only as layout helpers (dummy strings to help you see your label in your XIB, which is easier than an empty label to help you position it), like for a `UILabel` in a custom `UITableViewCell` for which you don't want those warnings, knowing that you will override its text by code anyway.


# How it works

This class uses method swizzling to intercept the calls to awakeFromNib and automatically localize any objet created/extracted from a XIB file by the runtime. The method swizzling is done automatically when your application is loaded in memory, so you don't even to add code to install this: the only presence of the OHAutoNIBi18n.m file in your project make everything magic!


### Comparison with Xcode 4.5's "Base Localization"

Starting with Xcode 4.5, you can use the "Base Localisation" (see [Apple Tutorial: Internationalize your application](https://developer.apple.com/library/ios/referencelibrary/GettingStarted/RoadMapiOS/chapters/InternationalizeYourApp/InternationalizeYourApp/InternationalizeYourApp.html)).

But this process requires that you create a `*.strings` file for each of your XIB files, with the same name as the XIB file.

This can become quite a pain:

* If you have a lot of XIB files, you will have to create as many `.strings` files, resulting in a lot of files
* This is also problematic for every generic term in your application that is used across multiple XIB, like some vocabulary or strings specific to your application domain and used in all of your XIB files. In that case, Base Localization requires that you repeat this term in every of your `.strings` files, whereas with `OHAutoNIBi18n` you can just translate it once in your `Localizable.strings`.

# License

This code is distributed under the MIT License.
