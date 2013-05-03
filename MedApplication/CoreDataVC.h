//
//  CoreDataVC.h
//  MedApplication
//
//  Created by Sipre on 01/05/13.
//  Copyright (c) 2013 Lalo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoreDataVC : UIViewController

- (NSArray *)searchMedicine:(NSString *)name;
- (void)addMedicine: (NSDictionary *)medicine;
- (void) deleteMedicine:(NSString *)name;

@end
