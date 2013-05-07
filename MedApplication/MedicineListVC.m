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
    //NSArray *medicineList;
}

@synthesize medicineList;

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
    NSString *nameSelected = [NSString stringWithFormat: @"%@",[[medicineList objectAtIndex:indexPath.row ] valueForKey:@"name"]];
    [navigationBar setTitle:nameSelected];
    
  
    
    attributesController.medicineAttributes = [NSMutableDictionary new];
    
    [attributesTableView reloadData];
    attributesController.medicineAttributes = [self getSelectedMedicineAttributes:indexPath.row];
        
    [self slideView:secondView direction:NO];
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

# pragma mark - User Defined Methods

- (NSMutableDictionary *) getSelectedMedicineAttributes: (int) selectedRow{
    /*Returns an NSMutableDictionary with the attributes of the selected cell*/
    NSMutableDictionary *medicineAttributes = [[NSMutableDictionary alloc] init];
    
    [[medicineList objectAtIndex:0] valueForKey:@"name"];
    
    NSManagedObject *medicine = [medicineList objectAtIndex:selectedRow];
    
    [medicineAttributes setValue: [medicine valueForKey:@"name"]        forKey:@"name"];
    [medicineAttributes setValue: [medicine valueForKey:@"frecuency"]   forKey:@"frecuency"];
    [medicineAttributes setValue: [medicine valueForKey:@"quantity"]    forKey:@"quantity"];
    [medicineAttributes setValue: [medicine valueForKey:@"duration"]    forKey:@"duration"];
    [medicineAttributes setValue: [medicine valueForKey:@"image"]       forKey:@"imge"];
    [medicineAttributes setValue: [medicine valueForKey:@"doseUnit"]    forKey:@"doseUnit"];
    [medicineAttributes setValue: [medicine valueForKey:@"remainingDoses"] forKey:@"remainingDoses"];
    [medicineAttributes setValue: [medicine valueForKey:@"startDate"]   forKey:@"startDate"];
    
    return medicineAttributes;
}

@end
