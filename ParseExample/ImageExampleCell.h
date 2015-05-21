//
//  ImageExampleCell.h
//  ParseExample
//
//  Created by Arman Bhalla on 8/24/14.
//  Copyright (c) 2014 virtualcheddar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageExampleCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *parseImage;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingSpinner;

@end
