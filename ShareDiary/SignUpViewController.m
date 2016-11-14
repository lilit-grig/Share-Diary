//
//  SignUpViewController.m
//  LifeDiary
//
//  Created by Lilit Grigoryan on 11/11/16.
//  Copyright © 2016 GevorGNanyaN. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameSignUp;
@property (weak, nonatomic) IBOutlet UITextField *passwordSignUp;
@property (weak, nonatomic) IBOutlet UITextField *repeatPasswordSignUp;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.signInButton.layer.cornerRadius = 10;
    [self touchDismiss];
}

- (void)touchDismiss {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

-(void)dismissKeyboard {
    [self.usernameSignUp resignFirstResponder];
    [self.passwordSignUp resignFirstResponder];
    [self.repeatPasswordSignUp resignFirstResponder];

}

#pragma mark - SignUp Button events

- (IBAction)signUpAction:(id)sender {
    if ([self.usernameSignUp.text isEqualToString:@""] ||
        [self.passwordSignUp.text isEqualToString:@""] ||
        [self.repeatPasswordSignUp.text isEqualToString:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning!" message:@"All fields must be filled" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        if (self.passwordSignUp.text.length < 5 &&
            self.repeatPasswordSignUp.text.length < 5) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning!" message:@"Your password must contain at least 5 characters" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        } else if ([self.passwordSignUp.text isEqualToString:self.repeatPasswordSignUp.text]) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setBool:YES forKey:@"isRegistered"];
            [defaults setObject:self.usernameSignUp.text forKey:@"username"];
            [defaults setObject:self.passwordSignUp.text forKey:@"password"];
            [self performSegueWithIdentifier:@"GoMenuSignUp" sender:nil];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning!" message:@"Wrong password!" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
        
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.usernameSignUp) {
        [self.passwordSignUp becomeFirstResponder];
    } else if (textField == self.passwordSignUp) {
        [self.repeatPasswordSignUp becomeFirstResponder];
    } else if (textField == self.repeatPasswordSignUp) {
        [self signUpAction:nil];
    }
    return YES;
}

@end
