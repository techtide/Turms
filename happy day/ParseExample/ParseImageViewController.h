//
//  ParseImageViewController.h
//  HappyDay
//
//  Created by Arman Bhalla on 8/24/14.
//  Copyright (c) 2014 virtualcheddar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageExampleCell.h"
#import <Parse/Parse.h>

@interface ParseImageViewController : UIViewController {
    
    NSArray *imageFilesArray;
    NSMutableArray *imagesArray;
}

@property (weak, nonatomic) IBOutlet UICollectionView *imagesCollection;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextField *noteField;
@property (weak, nonatomic) IBOutlet UITextField *explainField;
@property (weak, nonatomic) IBOutlet UITextField *categoryField;

@end
