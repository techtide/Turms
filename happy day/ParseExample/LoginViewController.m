//
//  LoginViewController.m
//  HappyDay
//
//  Created by Arman Bhalla on 8/24/14.
//  Copyright (c) 2014 virtualcheddar. All rights reserved.
//

#import "LoginViewController.h"
#import "ParseExampleAppDelegate.h"
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *exclamationMark;
@property (weak, nonatomic) IBOutlet UILabel *loadingText;

@end

@implementation LoginViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
}



-(void)viewDidAppear:(BOOL)animated {
    
    PFUser *user = [PFUser currentUser];
    [user save];
   }
   
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registerAction:(id)sender {
    [_usernameField resignFirstResponder];
    [_passwordField resignFirstResponder];
    [_reEnterPasswordField resignFirstResponder];
    [_emailField resignFirstResponder];
    [self checkFieldsComplete];
}

- (void) checkFieldsComplete {
    if ([_usernameField.text isEqualToString:@""] ||  [_passwordField.text isEqualToString:@""] || [_reEnterPasswordField.text isEqualToString:@""] ||  [_emailField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"You need to complete all fields." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else {
        [self checkPasswordsMatch];
    }
}

- (void) checkPasswordsMatch {
    if (![_passwordField.text isEqualToString:_reEnterPasswordField.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"The passwords entered don't match." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else {
        [self.view endEditing:YES];
        [self registerNewUser];
    }
}

- (void) registerNewUser {
    NSLog(@"Completing Registration with Parse. %@",_usernameField);
    PFUser *newUser = [PFUser user];
    newUser.username = _usernameField.text;
    newUser.password = _passwordField.text;
    newUser.email = _emailField.text;
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            _usernameField.text = nil;
            _passwordField.text = nil;
            _reEnterPasswordField.text = nil;
            _emailField.text = nil;
            _exclamationMark.hidden=NO;
            _loadingText.hidden=NO;
            // Associate the device with a user (vital for push notifications)
            PFInstallation *installation = [PFInstallation currentInstallation];
            installation[@"user"] = [PFUser currentUser];
            [installation saveInBackground];
            PFUser *user = [PFUser currentUser];
            user.ACL = [PFACL ACLWithUser:user];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registered!" message:@"Your account has been created. Please sign into your account from the Login button below." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else {
            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Please make sure that you copied your password correctly. If this isn't the case another user might have the same username or email as you chose." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [errorAlert show];
        }
    }];
    
    
  
    
    
}

- (IBAction)viewPolicy:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://yqpc.net/turms/privacypolicy.htm"]];
}


    
    




-(IBAction)unWindFromLogin:(UIStoryboardSegue*)unWindSegue{
    
}







@end
