//
//  MedicineListVC.m
//  MedApplication
//
//  Created by Lalo on 30/04/2013.
//  Copyright (c) 2013 Lalo. All rights reserved.
//

#import "MedicineListVC.h"
#import "CoreDataVC.h"
#import "AppDelegate.h"

@interface MedicineListVC ()

@end


@implementation MedicineListVC{
    NSArray *medicineList;
}

@synthesize medicineTableView;
@synthesize progressBar;

@synthesize secondView;
@synthesize navigationBar;

@synthesize attributesController;
@synthesize attributesTableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    /*Second table view init*/
    attributesController = [[medicineTableController alloc] init];
    attributesTableView.delegate = attributesController;
    attributesTableView.dataSource = attributesController;
    attributesController.view = attributesController.tableView;
    
    /*Core data search*/
    medicineList = [NSArray new];
    medicineList = [self searchMedicine:@"*"];    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    NSLog(@"Back to Main Menu");
    [self openNewViewController:@"MainMenu"];
}

- (IBAction)rightNavButton:(id)sender { //next
    NSLog(@"Right Button");
    [self openNewViewController:@"AddMedicine"];
}


#pragma mark - TableView Cell


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self searchMedicine:@"*"].count;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MedicineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"medicineCell"];
    
    cell.medicineNameLabel.text = [[medicineList objectAtIndex:indexPath.row ] valueForKey:@"name"];
    
    return cell;
}

//this method is used when the user select a cell in the "tableview"
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView deselectRowAtIndexPath:indexPath animated:TRUE];

    //[tableView beginUpdates];
    //[tableView reloadData];
    //[tableView endUpdates];
    //[navigationBar setTitle:[[medicineList objectAtIndex:indexPath.row] objectForKey:@"name"]];
    NSString *nameSelected = [NSString stringWithFormat: @"%@",[[medicineList objectAtIndex:indexPath.row ] valueForKey:@"name"]];
    [navigationBar setTitle:nameSelected];
    NSLog(@"%@",[[medicineList objectAtIndex:indexPath.row ] valueForKey:@"name"]);
    [self slideView:secondView direction:NO];
    [progressBar setProgress:0.75];
}


- (IBAction)back2:(id)sender {
    [self slideView:secondView direction:YES];
}

- (IBAction)edit:(id)sender {
}

#pragma mark - User Defined Methods

- (void) openNewViewController:(NSString*) ViewControllerIndentifier{
    //Opens the View Controller with identifier passed by the parameter
    UIViewController *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:ViewControllerIndentifier];
    [self presentViewController:newViewController animated:YES completion:nil];
}

- (void)slideView:(UIView*)view direction:(BOOL)isLeftToRight {
    CGRect frame = view.frame;
    frame.origin.x = (isLeftToRight) ? 0 : 320;
    view.frame = frame;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    frame.origin.x = (isLeftToRight) ? 320 : 0;
    view.frame = frame;
    [UIView commitAnimations];
}

@end
