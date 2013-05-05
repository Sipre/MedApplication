//
//  MainMenuVC.m
//  MedApplication
//
//  Created by Lalo on 30/04/2013.
//  Copyright (c) 2013 Lalo. All rights reserved.
//

#import "MainMenuVC.h"

@interface MainMenuVC ()

@end

@implementation MainMenuVC {
    UIImageView *firstSplash;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //Create SlashScreen
    firstSplash = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SplashScreen.png"]];
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
    }];
}


#pragma mark - Button Actions Methods

- (IBAction)add:(id)sender {
    NSLog(@"Add button pressed");
    [self openNewViewController:@"AddMedicine"];
}

- (IBAction)list:(id)sender {
    NSLog(@"List button pressed");
    [self openNewViewController:@"MedicineList"];
}

- (IBAction)schedule:(id)sender {
    NSLog(@"Schedule button pressed");
    [self openNewViewController:@"Schedule"];
}

#pragma mark - User Defined Methods

- (void) openNewViewController:(NSString*) ViewControllerIndentifier{
    //Opens the View Controller with identifier passed by the parameter
    UIViewController *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:ViewControllerIndentifier];
    [self presentViewController:newViewController animated:YES completion:nil];
}

@end
