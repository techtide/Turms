//
//  CustomMessageViewController.m
//  happy day (happy med)
//
//  Created by Arman˙ on 31/08/2014.
//  Copyright (c) 2014 Virtual Cheddar. All rights reserved.
//

#import "CustomMessageViewController.h"
#import "ParseExampleAppDelegate.h"
#import "MBProgressHUD.h"


@interface CustomMessageViewController () <UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating>


@property (weak, nonatomic) IBOutlet UITextField *titleTextField;

@property (weak, nonatomic) IBOutlet UITextField *noteTextField;

@property (weak, nonatomic) IBOutlet UITextField *explainedTextField;

@property (weak, nonatomic) IBOutlet UITextField *categoryTextfield;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *publicLabel;

@property (weak, nonatomic) IBOutlet UISegmentedControl *messageTypeSegmentedControl;

@property (weak, nonatomic) IBOutlet UITableView *usersTable;

@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, strong) NSMutableArray *searchResult;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


@property BOOL searchControllerWasActive;
@property BOOL searchControllerSearchFieldWasFirstResponder;

@end

#pragma mark -

NSData *imageData;
bool public;
NSMutableArray *users;
@implementation CustomMessageViewController



- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    //Hides some fields
    _usersTable.hidden = NO;
    _publicLabel.hidden = YES;
    _searchBar.hidden = NO;
    
    
    //Initializes Public/Private segmented control/switcher
    [self.messageTypeSegmentedControl setSelectedSegmentIndex:0];
    
    //Removes the current user from the table view
    ParseExampleAppDelegate *delegate=[[UIApplication sharedApplication] delegate];
    PFQuery *query = [PFUser query];
    users = [[query findObjects] mutableCopy];
    //Renive the current user with a for loop
    for(PFUser *user in users){
        if ([user.objectId isEqualToString:delegate.applicationUser.objectId]){
            [users removeObject:user];
            break;
        }
        
    }
    self.searchResult = [NSMutableArray arrayWithArray:users];
    [users removeObject:delegate.applicationUser];
    
    
    
    [self.usersTable setDelegate:self];
    [self.usersTable setDataSource:self];
    [self.usersTable reloadData];
    
    //public = false;
    
    _titleTextField.delegate = self;
    _noteTextField.delegate = self;
    _explainedTextField.delegate = self;
    _categoryTextfield.delegate = self;
    //[_usersTable registerClass:self forCellReuseIdentifier:@"userCell"];
}

//Image choosing utilities
- (IBAction)chooseImage:(id)sender {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    self.imageView.image=image;
    
    [picker dismissViewControllerAnimated:NO completion:nil];
    
}

- (IBAction)messageTypeChanged:(id)sender {
    //Method manages segmented controller
    
    if (self.messageTypeSegmentedControl.selectedSegmentIndex ==0) {
        public = false;
        _usersTable.hidden = NO;
        _publicLabel.hidden=YES;
        _searchBar.hidden = NO;
    }else {
        public = true;
        _usersTable.hidden=YES;
        _publicLabel.hidden=NO;
        _searchBar.hidden = YES;
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    //[users removeAllObjects];
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF.username contains [c] %@", searchText];
    
    self.searchResult = [NSMutableArray arrayWithArray: [users filteredArrayUsingPredicate:resultPredicate]];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
}

-(IBAction)saveCustomMessage{
  

    PFObject *parseMessage = [PFObject objectWithClassName:@"CustomMessage"];
    //starts the hUD
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //sets hud style
    hud.mode =  MBProgressHUDModeIndeterminate;
    //sets hud label
    hud.labelText = @"Sending";
    //displays the HUD
    [hud show:YES];
    //variables set to equal fields
    //manages who to send msg to
    
    PFUser *toUser=nil;

    bool goOn = NO;
    if (public == NO) {
        //Send based on the user selected on table view.
        NSIndexPath *index = (self.searchDisplayController.active) ? [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow]
        : [self.usersTable indexPathForSelectedRow];
        
        if(index == nil) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"Select a User"
                                  message: @"Select a user to send the message."
                                  delegate: nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
            toUser = nil;
            [hud hide: YES];
            goOn = NO;
        }else {
            goOn = YES;
            
            //assert(index != nil);
            toUser = [self.searchResult objectAtIndex:index.row];
            [parseMessage setObject:[NSNumber numberWithBool:NO] forKey:@"public"];
        }
     
    } else{
        //Send to a random user using a uint32
        
        uint32_t random = arc4random_uniform([users count]);
        PFUser *randomUser = [users objectAtIndex:random];
        
        toUser = randomUser;
        [parseMessage setObject:[NSNumber numberWithBool:YES] forKey:@"public"];
        
        
    }
    if (toUser!= nil && goOn){
        //update initiatly startes here. 1.1
        NSString *title = _titleTextField.text;
        NSString *note = _noteTextField.text;
        NSString *explanation = _explainedTextField.text;
        NSString *category = _categoryTextfield.text;
        parseMessage[@"title"]=title;
        parseMessage[@"note"]=note;
        parseMessage[@"explanation"]=explanation;
        parseMessage[@"category"]=category;
        ParseExampleAppDelegate *delegate=[[UIApplication sharedApplication] delegate];
        parseMessage[@"user"]=delegate.applicationUser;
        parseMessage[@"toUser"]=toUser;
       
        UIImage *image = [_imageView image];
        NSData *imageData = UIImagePNGRepresentation(image);
        PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
        [parseMessage setObject:imageFile forKey:@"picture"];
    
    [parseMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"Sent"
                                  message: @"Your message has been sent."
                                  delegate: nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
            //hud displays
            [hud hide:YES];
        } else {
            // There was a problem, check error.description
            [hud hide:YES];
            UIAlertView *error = [[UIAlertView alloc]
                                  initWithTitle: @"Error Occurred"
                                  message: @"An error occured. Try again later or email turms@yqpc.net"
                                  delegate: nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [error show];
        }
    }];
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //sets cell identifier to the same one in the storyboard.
    static NSString *CellIdentifier = @"userCell";
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //NSLog(@"%@", cell);
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    PFObject *tempObject = [self.searchResult objectAtIndex:indexPath.row];
    
    cell.text= [tempObject objectForKey:@"username"];
    
    
    return cell;
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.searchResult = [NSMutableArray arrayWithArray:users];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.searchResult.count;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}



@end

