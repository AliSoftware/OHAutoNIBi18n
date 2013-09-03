//
//  MainViewController.m
//  OHAutoNIBi18n
//
//  Created by Olivier Halligon on 03/09/13.
//
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //label.text = NSLocalizedString(@"greetings",@"Text to say hello"); // NOT NEEDED ANYMORE!
}

- (IBAction)buttonAction:(id)sender
{
    // Here you can use the utility macros _T defined in OHL10nMacros.h (imported in the pch of this demo app)
    [[[UIAlertView alloc] initWithTitle:_T(@"alert.title")
                                message:_Tf(@"alert.message", [UIDevice currentDevice].name)
                               delegate:nil
                      cancelButtonTitle:_T(@"alert.button")
                      otherButtonTitles:nil] show];
}

@end
