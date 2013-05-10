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

@interface MedicineListVC (){
    int editingMed;
}

@end


@implementation MedicineListVC{
    //NSArray *medicineList;
    NSArray *medicines;
    NSMutableArray *listOfItems;
    
    NSString *nameEditing;
    NSString *parameterEditing;
}

@synthesize medicineList;

@synthesize medicineTableView;

@synthesize secondView;
@synthesize navigationBar;

@synthesize attributesController;
@synthesize attributesTableView;

@synthesize edit;
@synthesize protectorView;

@synthesize editView;
@synthesize editTextField;
@synthesize topEditLabel;
@synthesize bottomEditLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    /*Second table view init*/
    editingMed=0;
    
    attributesController = [[medicineTableController alloc] init];
    attributesTableView.delegate = attributesController;
    attributesTableView.dataSource = attributesController;
    attributesController.view = attributesController.tableView;
  
    /*Core data search*/
    medicineList = [NSArray new];
    medicineList = [self searchMedicine:@"*"];
    
    medicines = [NSArray new];

    [medicineTableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backgroundPOT.png"]]];
    [attributesTableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backgroundPOT.png"]]];
   
    [protectorView setBackgroundColor:[UIColor grayColor]];
    protectorView.alpha=0.0;
    [self.view addSubview:protectorView];
    
    
    editView.layer.borderColor = [UIColor whiteColor].CGColor;
    editView.layer.borderWidth = 3.0f;
    [editView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundPOT.png"]]];
    editView.alpha = 0.0;
    [self.view addSubview:editView]; //agregamos el edit View
    editTextField.enabled = NO;
    
    //Initialize the Sections.
    listOfItems = [[NSMutableArray alloc] init];
    
    NSMutableArray *currently = [[NSMutableArray alloc] init];
    NSMutableArray *passed = [[NSMutableArray alloc] init];
    
    if(medicineList.count <= 0){
        NSLog(@"Nothing to do here :D");
    }
    else{
        for (NSManagedObject *obj in medicineList) {
            if ([[obj valueForKey:@"remainingDoses"] intValue] > 0) {
                [currently addObject:obj];
            }
            else{
                [passed addObject:obj];
            }
        }
    }
    [listOfItems addObject:currently];
    [listOfItems addObject:passed];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handlingAction:)
                                                 name:@"deleteMedicine"
                                               object:nil];
   [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showEditView:)
                                                 name:@"showEditView"
                                               object:nil];
}

- (void) handlingAction:(NSNotification *)notification{
    //NSLog(@"menu was pressed: %@", notification);
    NSLog(@"%@",notification.object);
    [self deleteMedicine:notification.object];
    [self viewDidLoad];
    [medicineTableView reloadData];
    [self slideView:secondView direction:YES];
    
}

- (void) showEditView:(NSNotification *)notification{
    NSLog(@"show Edit view");
    NSLog(@"%@",[[notification.userInfo allValues] objectAtIndex:0]);
    
    nameEditing = notification.object;
    parameterEditing = [[notification.userInfo allValues] objectAtIndex:0];
    
    NSArray *matchingData = [self searchMedicine:nameEditing];
    if(matchingData.count <= 0){
        NSLog(@"No medicine found");
    }
    else{
        for (NSManagedObject *obj in matchingData) {
            NSString *data = [obj valueForKey: parameterEditing];
            
            if([parameterEditing isEqualToString:@"quantity"] ){
                editTextField.text = data;
                topEditLabel.text = @"Quantity";
                bottomEditLabel.text = [NSString stringWithFormat:@"%@ %@",[obj valueForKey:@"doseUnit"], @"per dose"];
            }
            if([parameterEditing isEqualToString:@"frecuency"]) {
                editTextField.text = data;
                topEditLabel.text = @"Every";
                bottomEditLabel.text =@"hours";
            }
            if([parameterEditing isEqualToString:@"duration"]) {
                editTextField.text = data;
                topEditLabel.text = @"For";
                bottomEditLabel.text =@"days";
            }
            
            
        }
        [UIView animateWithDuration:0.3 animations:^{
            protectorView.alpha=0.2;
            editView.alpha=1.0;
        }];
    }
}

- (IBAction)increaseEdit:(id)sender {
    int val = [editTextField.text intValue];
    if(val < 15){
        val++;
    }
    editTextField.text = [NSString stringWithFormat:@"%d",val];
}

- (IBAction)decreaseEdit:(id)sender {
    int val = [editTextField.text intValue];
    if(val > 1){
        val--;
    }
    editTextField.text = [NSString stringWithFormat:@"%d",val];
}

- (IBAction)saveEditButton:(id)sender {
    
   //[medicineAttributes setValue: [medicine valueForKey:@"quantity"]    forKey:@"quantity"];
    if([parameterEditing isEqualToString:@"quantity"] ){
        [self changeValueOfMedicine:nameEditing withValueForKey:editTextField.text forKey:parameterEditing];
        [attributesController.medicineAttributes setValue:editTextField.text forKey:parameterEditing];
    }
    if([parameterEditing isEqualToString:@"frecuency"]) {
        NSManagedObject *medicine = [[self searchMedicine:nameEditing] objectAtIndex:0];
        int oldFrecuency = [[medicine valueForKey:@"frecuency"] intValue];
        //int oldDuration = [[medicine valueForKey:@"duration"] intValue];
        int oldRemainingDoses = [[medicine valueForKey:@"remainingDoses"] intValue];
        //int oldTotalRemainingDoses = ((24000/oldFrecuency)*oldDuration)/1000;
        
        int newFrecuency = [editTextField.text intValue];
        int deltaDuration = ((oldRemainingDoses*oldFrecuency)*1000)/24000;
        int newReaminingDoses = ((24000/newFrecuency)*deltaDuration)/1000;
        NSString *remainigDoses = [NSString stringWithFormat:@"%d",newReaminingDoses];
        
        [self changeValueOfMedicine:nameEditing withValueForKey:editTextField.text forKey:parameterEditing];
        [self changeValueOfMedicine:nameEditing withValueForKey:remainigDoses forKey:@"remainingDoses"];
        
        [attributesController.medicineAttributes setValue:editTextField.text forKey:parameterEditing];
        [attributesController.medicineAttributes setValue:remainigDoses forKey:@"remainingDoses"];
    }
    if([parameterEditing isEqualToString:@"duration"]) {
        NSManagedObject *medicine = [[self searchMedicine:nameEditing] objectAtIndex:0];
        int oldFrecuency = [[medicine valueForKey:@"frecuency"] intValue];
        int oldDuration = [[medicine valueForKey:@"duration"] intValue];
        int oldRemainingDoses = [[medicine valueForKey:@"remainingDoses"] intValue];
        //int oldTotalRemainingDoses = ((24000/oldFrecuency)*oldDuration)/1000;

        int newDuration = [editTextField.text intValue];
        int deltaDuration = newDuration - oldDuration;
        int newReaminingDoses = ((24000/oldFrecuency)*deltaDuration)/1000;
        int totalRemaingDoses = newReaminingDoses+oldRemainingDoses;
        NSString *remainigDoses = [NSString stringWithFormat:@"%d",totalRemaingDoses];
        
        [self changeValueOfMedicine:nameEditing withValueForKey:editTextField.text forKey:parameterEditing];
        [self changeValueOfMedicine:nameEditing withValueForKey:remainigDoses forKey:@"remainingDoses"];
        
        [attributesController.medicineAttributes setValue:editTextField.text forKey:parameterEditing];
        [attributesController.medicineAttributes setValue:remainigDoses forKey:@"remainingDoses"];
    }
    
    [attributesTableView reloadData];
    [UIView animateWithDuration:0.3 animations:^{
        protectorView.alpha=0.0;
        editView.alpha=0.0;
    }];
}

- (IBAction)cancelEditButton:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        protectorView.alpha=0.0;
        editView.alpha=0.0;
    }];
 //nothing to do here :P
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [listOfItems count];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  [[listOfItems objectAtIndex:section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if(section == 0)
        return @"Current treatments";
    else
        return @"Past treatments";
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(20, 8, 320, 20);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    //label.shadowColor = [UIColor grayColor];
    //label.shadowOffset = CGSizeMake(-1.0, 1.0);
    label.font = [UIFont boldSystemFontOfSize:16];
    label.text = sectionTitle;
    
    UIView *view = [[UIView alloc] init];
    [view addSubview:label];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    MedicineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"medicineCell"];
    cell.medicineNameLabel.text = [[[listOfItems objectAtIndex:indexPath.section] objectAtIndex:indexPath.row ] valueForKey:@"name"];
    //Show medicine image
    NSString *imageName = [NSString stringWithFormat:@"%@.png",[[[listOfItems objectAtIndex:indexPath.section] objectAtIndex:indexPath.row ] valueForKey:@"image"]];
    [cell.medicineImage setImage:[UIImage imageNamed:imageName]];

    return cell;
}

//this method is used when the user select a cell in the "tableview"
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    NSString *nameSelected = [NSString stringWithFormat:  @"%@",[[[listOfItems objectAtIndex:indexPath.section] objectAtIndex:indexPath.row ] valueForKey:@"name"]];
    [navigationBar setTitle:nameSelected];
    
    attributesController.medicineAttributes = [NSMutableDictionary new];
    attributesController.medicineAttributes = [self getSelectedMedicineAttributes:indexPath];
   
    [attributesTableView reloadData];
    [self slideView:secondView direction:NO];
}


- (IBAction)back2:(id)sender {
    [self slideView:secondView direction:YES];
}

- (IBAction)edit:(id)sender {
    NSLog(@"editPressed");
    if (editingMed == 0) {
        editingMed++;
        [attributesController editing:editingMed];
        edit.title = @"Done";
        }
    else{
        editingMed--;
        [attributesController editing:editingMed];
        edit.title = @"Edit";
    }
    [attributesTableView reloadData];
    
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

- (NSMutableDictionary *) getSelectedMedicineAttributes: (NSIndexPath *)indexPath{
    /*Returns an NSMutableDictionary with the attributes of the selected cell*/
    NSMutableDictionary *medicineAttributes = [[NSMutableDictionary alloc] init];
    
    NSManagedObject *medicine = [[listOfItems objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    [medicineAttributes setValue: [medicine valueForKey:@"name"]        forKey:@"name"];
    [medicineAttributes setValue: [medicine valueForKey:@"frecuency"]   forKey:@"frecuency"];
    [medicineAttributes setValue: [medicine valueForKey:@"quantity"]    forKey:@"quantity"];
    [medicineAttributes setValue: [medicine valueForKey:@"duration"]    forKey:@"duration"];
    [medicineAttributes setValue: [medicine valueForKey:@"image"]       forKey:@"image"];
    [medicineAttributes setValue: [medicine valueForKey:@"doseUnit"]    forKey:@"doseUnit"];
    [medicineAttributes setValue: [medicine valueForKey:@"remainingDoses"] forKey:@"remainingDoses"];
    [medicineAttributes setValue: [medicine valueForKey:@"startDate"]   forKey:@"startDate"];
    [medicineAttributes setValue: [medicine valueForKey:@"nextDose"]   forKey:@"nextDose"];
    
    return medicineAttributes;
}




@end
