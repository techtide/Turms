//
//  ParseImageViewController.m
//  ParseExample
//
//  HappyDay
//
//  Created by Arman Bhalla on 8/24/14.
//  Copyright (c) 2014 virtualcheddar. All rights reserved.
//

#import "ParseImageViewController.h"

@interface ParseImageViewController ()

@end

@implementation ParseImageViewController

@synthesize imagesCollection;



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self queryParseMethod];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)queryParseMethod {
    NSLog(@"start query");
    PFQuery *query = [PFQuery queryWithClassName:@"collectionViewData"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            imageFilesArray = [[NSArray alloc] initWithArray:objects];
            NSLog(@"%@", imageFilesArray);
            
            [imagesCollection reloadData];
        }
    }];
}



#pragma mark - UICollectionView data source

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [imageFilesArray count];
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"imageCell";
    ImageExampleCell *cell = (ImageExampleCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    PFObject *imageObject = [imageFilesArray objectAtIndex:indexPath.row];
    PFFile *imageFile = [imageObject objectForKey:@"imageFile"];
    
    cell.loadingSpinner.hidden = NO;
    [cell.loadingSpinner startAnimating];
    
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            cell.parseImage.image = [UIImage imageWithData:data];
            [cell.loadingSpinner stopAnimating];
            cell.loadingSpinner.hidden = YES;
        }
    }];
                
    return cell;
}

- (IBAction) unwindFromMessageChooser:(UIStoryboardSegue *)segue{
    NSLog(@"back from message chooser");
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

}


@end
