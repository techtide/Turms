//
//  LoginFormViewController.m
//  happy day
//
//  Created by Arman Bhalla on 27/09/2014.
//  Copyright (c) 2014 Virtual Cheddar. All rights reserved.
//

#import "LoginFormViewController.h"
#import "ParseExampleAppDelegate.h"
#import <Parse/Parse.h>


@interface LoginFormViewController ()
//Outlets
@property (weak, nonatomic) IBOutlet UITextField *loginUsernameField;
@property (weak, nonatomic) IBOutlet UITextField *loginPasswordField;
@property (weak, nonatomic) IBOutlet UITextField *resetPasswordField;
@property (weak, nonatomic) IBOutlet UIButton *updatePasswordButton;

@end

@implementation LoginFormViewController
//Actions


- (void)viewDidLoad {
    [super viewDidLoad];
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)loginButton:(id)sender {
    NSError *error;
    PFUser *user=[PFUser logInWithUsername:_loginUsernameField.text password:_loginPasswordField.text error:&error ];
    PFUser *userOne = [PFUser currentUser];
    [user save];
    NSTimeInterval FOUR_MONTHS_AGO = 2921.94 * 60 * 60; //4 months in hours
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"updatedAt"
greaterThanOrEqualTo:[NSDate dateWithTimeIntervalSinceNow: FOUR_MONTHS_AGO]];
    NSString *inActiveUser = [query getObjectWithId:userOne];
    NSString *currentUser = userOne;
    if (inActiveUser==currentUser) {
        [[PFUser currentUser] deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            UIAlertView *inActiveAlert = [[UIAlertView alloc] initWithTitle:@"You've been inactive!" message:@"Hi! Since you haven't used the app in a rather long time (three to four months) our system deleted your account automatically. You can create another account by going to the Register form. If you believe this is an error you can contact us at turms@yqpc.net." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [inActiveAlert show];
            
        }];
    }else{
        if (!error) {
            NSLog(@"Login user!");
            _loginPasswordField.text = nil;
            _loginUsernameField.text = nil;
            ParseExampleAppDelegate *delegate= [[UIApplication sharedApplication]delegate];
            delegate.applicationUser=user;
            //maybe I should check this code, and if it doesn't have a query updating updatedAt fix it.
            [self performSegueWithIdentifier:@"login" sender:self];
        }
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"We're having trouble logging you in. Please check that you have entered the correct username or password, and that you are connected to a working network." delegate:self cancelButtonTitle:@"Retry" otherButtonTitles:nil];
            [alert show];
        }

        //Essential Profile Variables
    };
}
- (IBAction)updateButtonPressed:(id)sender {
    NSString *email = _resetPasswordField.text;
    //Sends an email to the user with a reset link using the Parse API.
    [PFUser requestPasswordResetForEmailInBackground:email];
    //Displays an alert to the user.
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email Sent"
                                                    message:@"An email containing a link to reset your password has been sent to the email you provided. If you don't see the email check your spam folder."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}







/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

@end
