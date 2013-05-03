//
//  ScheduleCell.h
//  MedApplication
//
//  Created by Sipre on 02/05/13.
//  Copyright (c) 2013 Lalo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScheduleCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *timeScheduleLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameScheduleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *medicineImage;
@end
