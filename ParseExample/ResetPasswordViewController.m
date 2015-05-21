//
//  ResetPasswordViewController.m
//  Happy Med
//
//  Created by Arman Bhalla on 22/02/2015.
//  Copyright (c) 2015 Virtual Cheddar. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "ParseExampleAppDelegate.h"
#import <Parse/Parse.h>

@interface ResetPasswordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *resetPasswordField;
@property (weak, nonatomic) IBOutlet UIButton *updatePasswordButton;

@end

@implementation ResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _resetPasswordField.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)updateButtonPressed:(id)sender {
    //Initiates users email into a string.
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
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
