//
//  AutoNibL10n.h
//  FoodReporter
//
//  Created by Olivier on 03/11/10.
//  Copyright 2010 FoodReporter. All rights reserved.
//

#import <Foundation/Foundation.h>


static NSString* localizedString(NSString* aString);

@interface AutoNibL10n : NSObject
@end

@interface NSObject(Auto_L10n)
-(void)localizeNibObject;
@end
