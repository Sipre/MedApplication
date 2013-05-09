//
//  ScheduleVC.m
//  MedApplication
//
//  Created by Lalo on 30/04/2013.
//  Copyright (c) 2013 Lalo. All rights reserved.
//

#import "ScheduleVC.h"
#import "AppDelegate.h"

@interface ScheduleVC ()

@end

@implementation ScheduleVC{
    NSArray *medicineList;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    medicineList = [NSArray new];
    medicineList = [self searchMedicine:@"*"];
    
}




- (IBAction)back:(id)sender {
    NSLog(@"Back to Main Menu");
    [self openNewViewController:@"MainMenu"];
}

#pragma mark - Another Methods


- (void) openNewViewController:(NSString*) ViewControllerIndentifier{
    //Opens the View Controller with identifier passed by the parameter
    UIViewController *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:ViewControllerIndentifier];
    [self presentViewController:newViewController animated:YES completion:nil];
}


#pragma mark - TableView Cell


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self searchMedicine:@"*"].count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ScheduleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScheduleCell"];
    
    cell.nameScheduleLabel.text = [[medicineList objectAtIndex:indexPath.row ] valueForKey:@"name"];
    //Show medicine image
    NSString *imageName = [NSString stringWithFormat:@"%@.png",[[medicineList objectAtIndex:indexPath.row ] valueForKey:@"image"]];
    
    [cell.medicineImage setImage:[UIImage imageNamed:imageName]];
    
    return cell;
}

//this method is used when the user select a cell in the "tableview"
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    
    //[tableView beginUpdates];
    //[tableView reloadData];
    //[tableView endUpdates];
}




@end
