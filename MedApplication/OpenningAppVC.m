//
//  OpenningAppVC.m
//  MedApplication
//
//  Created by Sipre on 05/05/13.
//  Copyright (c) 2013 Lalo. All rights reserved.
//

#import "OpenningAppVC.h"

@interface OpenningAppVC ()

@end

@implementation OpenningAppVC{
    UIImageView *firstSplash ;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //Create SlashScreen
    firstSplash = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"splashPOT.png"]];
    firstSplash.alpha = 1.0;
    [self.view addSubview:firstSplash];
    
    [UIView animateWithDuration:0.5 animations:^{
        firstSplash.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(finishSplash:) userInfo:nil repeats:NO];
    }]; //create schedule for the SplashScreen
    
    
    //[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
    
    
}

#pragma mark - Hide SplashScreen
-(void)finishSplash:(NSTimer *)timer {
    // hide image
    // Delete image
    [UIView animateWithDuration:.5 animations:^{
        firstSplash.alpha = 0.0;
    } completion:^(BOOL finished) {
        [firstSplash removeFromSuperview];
        [self openNewViewController:@"MainMenu"];
    }];
}


#pragma mark - User Defined Methods

- (void) openNewViewController:(NSString*) ViewControllerIndentifier{
    //Opens the View Controller with identifier passed by the parameter
    UIViewController *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:ViewControllerIndentifier];
    [self presentViewController:newViewController animated:YES completion:nil];
}


@end
