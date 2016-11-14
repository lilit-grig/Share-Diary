//
//  LogInViewController.m
//  LifeDiary
//
//  Created by Lilit Grigoryan on 11/11/16.
//  Copyright © 2016 GevorGNanyaN. All rights reserved.
//

#import "LogInViewController.h"

@interface LogInViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameLogIn;
@property (weak, nonatomic) IBOutlet UITextField *passwordLogIn;
@property (weak, nonatomic) IBOutlet UIButton *logInButton;

@end

@implementation LogInViewController

- (void)touchDismiss {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

-(void)dismissKeyboard {
    [self.usernameLogIn resignFirstResponder];
    [self.passwordLogIn resignFirstResponder];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.logInButton.layer.cornerRadius = 10;
    [self touchDismiss];
}

#pragma mark - LogIn Button events

- (IBAction)logInAction:(id)sender {
    if ([self.usernameLogIn.text isEqualToString:@""] ||
        [self.passwordLogIn.text isEqualToString:@""]) {
        UIAlertController *alert
        = [UIAlertController alertControllerWithTitle:@"Warning!" message:@"All fields must be filled" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([self.usernameLogIn.text isEqualToString:[defaults stringForKey:@"username"]] &&
            [self.passwordLogIn.text isEqualToString:[defaults stringForKey:@"password"]] ) {
            [self performSegueWithIdentifier:@"GoMenuLogIn" sender:nil];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning!" message:@"Invalid username or password" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.usernameLogIn) {
        [self.passwordLogIn becomeFirstResponder];
    } else if (textField == self.passwordLogIn) {
        [self logInAction:nil];
    }
    return YES;
}

@end
