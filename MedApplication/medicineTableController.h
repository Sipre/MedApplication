//
//  medicineTableController.h
//  MedApplication
//
//  Created by Lalo on 03/05/2013.
//  Copyright (c) 2013 Lalo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgressCell.h"
#import "Cell.h"
#import "MedicineCell.h"
#import "ImageCell.h"


@interface medicineTableController : UITableViewController{
    int editable;
}

@property (strong, nonatomic) NSMutableDictionary *medicineAttributes;
-(void) editing:(int) editab;



@end
