//
//  CustomMessagesTableViewController.m
//  HappyDay
//
//  Created by Arman Bhalla on 8/24/14.
//  Copyright (c) 2014 virtualcheddar. All rights reserved.
//

#import "CustomMessagesTableViewController.h"
#import "ParseExampleAppDelegate.h"
#import "MessageDetailViewController.h"
#import "ResetPasswordViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface CustomMessagesTableViewController ()


@end

@implementation CustomMessagesTableViewController

@synthesize colorsTable;

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.colorsTable addSubview:refreshControl];
    [self retrieveFromParse];
    
}


-(void)refresh:(id)sender{
    if([(NSObject *)sender isKindOfClass:[UIRefreshControl class]]){
        UIRefreshControl *spinner = (UIRefreshControl *)sender;
        //There's probably a better way to do this with NSTimer, but that solution would be a little complicated for the Treehouse Forum, so I'll just use C's sleep function here
        sleep(2);
        //On its own, the UIRefreshControl class doesn't know when you're done refreshing, and therefore, won't know when to stop its animation, until you tell it to
        [spinner endRefreshing];
    }
}


- (void) retrieveFromParse {
    
    PFQuery *retrieveMessages = [PFQuery queryWithClassName:@"CustomMessage"];
    [retrieveMessages whereKeyDoesNotExist:@"toUser"];
    PFQuery *retrieveMessages2 = [PFQuery queryWithClassName:@"CustomMessage"];
    ParseExampleAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [retrieveMessages2 whereKey:@"toUser" equalTo:delegate.applicationUser];
    NSMutableArray *queries=[[NSMutableArray alloc] init];
    [queries addObject:retrieveMessages];
    [queries addObject:retrieveMessages2];
    
    PFQuery *retrieveMessages3 = [PFQuery orQueryWithSubqueries:queries];
    [retrieveMessages3
     findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
         if (!error) {
             colorsArray = [[NSArray alloc] initWithArray:objects];
         }
         [colorsTable reloadData];
     }];
}







//*********************Setup table of folder names ************************

//get number of sections in tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

//get number of rows by counting number of folders
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return colorsArray.count;
}

//setup cells in tableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //setup cell
    static NSString *CellIdentifier = @"customMessageCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    PFObject *tempObject = [colorsArray objectAtIndex:indexPath.row];
    
    cell.text= [tempObject objectForKey:@"title"];
    
    return cell;
}


//user selects folder to add tag to
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"cell tapped");

    LAContext *context = [[LAContext alloc] init];
    NSError *error = nil;
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                localizedReason:@"We need to verify that you are the owner of this device so you can view this message. Place your finger on the home button without holding down."
                          reply:^(BOOL success, NSError *error) {
                              
                              if (error) {
                                  
                                  return;
                              }
                              
                              if (success) {
                                  
                              } else {
                                  
                              }
                              
                          }];
        
    }
    
    
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"Table has been scrolled");
    [self retrieveFromParse];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"messageDetail"])  {
        MessageDetailViewController *controller = [segue.destinationViewController topViewController];
        NSInteger *messageIndex = [self.colorsTable indexPathForSelectedRow].row;
        PFObject *tempObject = [colorsArray objectAtIndex: messageIndex];
        controller.parseMessage = tempObject;
        
    }
    
    
}
-(IBAction)unWindFromMessageDetail:(UIStoryboardSegue*)unWindSegue{
    
}

#pragma table v

@end
