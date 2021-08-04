//
//  ViewController.m
//  Pricr
//
//  Created by Santy Mendoza on 7/12/21.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import <Material/Material-umbrella.h>

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet TextField *usernameField;
@property (weak, nonatomic) IBOutlet TextField *passwordField;
@property (weak, nonatomic) IBOutlet RaisedButton *loginButton;
@property (weak, nonatomic) IBOutlet FlatButton *createButton;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self preparePasswordField];
    [self prepareUsernameField];
    self.loginButton.titleColor = Color.whiteColor;
    self.loginButton.pulseColor = Color.whiteColor;
    self.loginButton.backgroundColor = Color.systemBlueColor;

    
    
    // Do any additional setup after loading the view.
}


- (void) preparePasswordField {
    self.passwordField.placeholder = @"Password";
    self.passwordField.detail = @"At least 8 characters";
    self.passwordField.clearButtonMode = self.passwordField.isEditing;
    self.passwordField.textColor = Color.whiteColor;
    self.passwordField.backgroundColor = Color.darkGrayColor;
    self.passwordField.isVisibilityIconButtonEnabled = true;
        // Setting the visibilityIconButton color.
}

- (void) prepareUsernameField {
    self.usernameField.placeholder = @"Username";
    self.usernameField.textColor = Color.whiteColor;
    self.usernameField.backgroundColor = Color.darkGrayColor;
    self.usernameField.isClearIconButtonEnabled = TRUE;
    self.usernameField.clearButtonMode = self.usernameField.isEditing;
}

- (IBAction)loginPressed:(id)sender {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
        } else {
            NSLog(@"User logged in successfully");
            [self performSegueWithIdentifier:@"loggedInSegue" sender:nil];
            // display view controller that needs to shown after successful login
        }
    }];
}

@end
