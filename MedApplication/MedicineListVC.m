//
//  MedicineListVC.m
//  MedApplication
//
//  Created by Lalo on 30/04/2013.
//  Copyright (c) 2013 Lalo. All rights reserved.
//

#import "MedicineListVC.h"

@interface MedicineListVC ()

@end


@implementation MedicineListVC

@synthesize medicineTableView;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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

}


#pragma mark - TableView Cell


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MedicineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"medicineCell"];
    
    cell.medicineNameLabel.text = @"Medicine";
    
    //cell.image.image = [UIImage imageNamed:[images objectAtIndex:indexPath.row]];
    
    return cell;
}

//Esta funcion se ejecuta cuando el usuario selecciona una celda de nuestra tableview
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    
    
    //[tableView beginUpdates];
    //[tableView reloadData];
    //[tableView endUpdates];
}

#pragma mark - Another Methods

- (void) openNewViewController:(NSString*) ViewControllerIndentifier{
    //Opens the View Controller with identifier passed by the parameter
    UIViewController *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:ViewControllerIndentifier];
    [self presentViewController:newViewController animated:YES completion:nil];
}

@end
