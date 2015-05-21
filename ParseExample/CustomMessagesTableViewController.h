//
//  ParseExampleViewController.h
//  HappyDay
//
//  Created by Arman Bhalla on 8/24/14.
//  Copyright (c) 2014 virtualcheddar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ParseExampleCell.h"


@interface CustomMessagesTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate> {
    
    NSArray *colorsArray;
}

@property (weak, nonatomic) IBOutlet UITableView *colorsTable;

@end
