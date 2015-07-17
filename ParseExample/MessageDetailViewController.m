//
//  MessageDetailViewController.m
//  happy day
//
//  Created by Arman Bhalla on 19/10/2014.
//  Copyright (c) 2014 Virtual Cheddar. All rights reserved.
//

#import "MessageDetailViewController.h"
#import "ParseExampleAppDelegate.h"
#import "ChatViewController.h"
@interface MessageDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;
@property (weak, nonatomic) IBOutlet UILabel *explanationLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdLabel;
@property (weak, nonatomic) IBOutlet UILabel *sentFromLabel;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *replyButton;


@end

@implementation MessageDetailViewController

- (void)viewDidLoad {
    
    
    
    
    
    
    //Shows the name of the message from the Parse database.
    //Tell UI to show the values of the labels.
    
    [self.parseMessage refresh];
    
    NSNumber *boolNumber = [self.parseMessage objectForKey:@"public"];
    BOOL b = [boolNumber boolValue];
    if(b == YES) {
        self.replyButton.enabled = NO;
        self.replyButton.title =  nil;
    }
    
    
    self.navigationController.navigationBar.topItem.title = self.parseMessage[@"title"];
    self.categoryLabel.text = self.parseMessage[@"category"];
    self.noteLabel.text = self.parseMessage[@"note"];
    self.explanationLabel.text = self.parseMessage[@"explanation"];
    NSDate *date = self.parseMessage.createdAt;
    self.createdLabel.text = [NSDateFormatter localizedStringFromDate:date
                                                            dateStyle:NSDateFormatterShortStyle
                                                            timeStyle:NSDateFormatterShortStyle];
    PFUser *user = self.parseMessage[@"user"];
    [user refresh];
    self.sentFromLabel.text = user.username;
    
    //Retrieve Image
    PFFile *image = [self.parseMessage objectForKey:@"picture"];
    NSData *imageData = [image getData];
    
    //sets images
    UIImage *picture = [UIImage imageWithData:imageData];
    [self.image setImage:picture];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    [self.parseMessage delete];
    
}
- (IBAction)reply:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reply"
                                                    message:@"To reply to the user who sent this message, type in what you want to say to them, and then tap on the 'Reply,' button. Otherwise, select the 'Cancel,' button. You can also start a real time, stacked conversation with them by clicking the 'Real Time Stack Chat.'"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Reply", @"Real Time Stack Chat", NULL];
    [alert show];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [alertView cancelButtonIndex]) {
        NSLog(@"cancel");
    }
    if (buttonIndex == 1) {
        NSString *content = [alertView textFieldAtIndex:0].text;    //stores content typed in reply in a variable
        // Perform action to send to the original sender
        
        PFObject *replyMessage = [PFObject objectWithClassName:@"CustomMessage"];
        replyMessage[@"title"]= @"New reply!";
        replyMessage[@"note"]= @"This is a reply to your earlier message.";
        replyMessage[@"explanation"]=content;
        replyMessage[@"toUser"]=self.parseMessage[@"user"]; //Sets the message the person sends to be == the person who sent it
        replyMessage[@"category"]=self.parseMessage[@"category"];
        replyMessage[@"user"]=[PFUser currentUser];
        [replyMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                //show alert
                UIAlertView *sucess = [[UIAlertView alloc]
                                       initWithTitle: @"Reply Sent"
                                       message: @"Your reply has been sent."
                                       delegate:self
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:NULL];
                [sucess show];
            } else {
                // There was a problem, check error.description
                UIAlertView *error = [[UIAlertView alloc]
                                      initWithTitle: @"Error Occured"
                                      message: @"An error occured. Try again later or email turms@yqpc.net"
                                      delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:NULL];
                [error show];
            }
        }];
        
        
    }
    if(buttonIndex == 2) {
        ChatViewController *viewController=[[ChatViewController alloc]initWithNibName:@"ChatViewController" bundle:nil];
        
        [self presentViewController:viewController animated:YES completion:nil];
 
    }
    
}

@end

