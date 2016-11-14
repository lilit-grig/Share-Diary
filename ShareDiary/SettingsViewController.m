//
//  SettingsViewController.m
//  SlideOutMenu
//
//  Created by Mac on 10/19/16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import "SettingsViewController.h"
#import "SWRevealViewController.h"


@interface SettingsViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordNewTextField;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self touchDismiss];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.translucent = YES;
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.barButton setTarget: self.revealViewController];
        [self.barButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)touchDismiss {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

-(void)dismissKeyboard {
    [self.usernameTextField resignFirstResponder];;
    [self.passwordTextField resignFirstResponder];
    [self.passwordNewTextField resignFirstResponder];
}

#pragma Mark - Password (username) changer

- (IBAction)changeAccount {
    if ([self.usernameTextField.text isEqualToString:@""] ||
        [self.passwordTextField.text isEqualToString:@""] ||
        [self.passwordNewTextField.text isEqualToString:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning!" message:@"Invalid text field" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        if (self.passwordTextField.text.length < 5 ||
            self.passwordNewTextField.text.length < 5) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning!" message:@"Your password must contain at least 5 characters" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
            
        } else if ([self.passwordTextField.text isEqualToString:self.passwordNewTextField.text]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Do you you want to change your account username and password?" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:self.usernameTextField.text forKey:@"username"];
                [defaults setObject:self.passwordTextField.text forKey:@"password"];
                [defaults synchronize];
                
            }];
            [alert addAction:actionCancel];
            [alert addAction:actionConfirm];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning!" message:@"Wrong password!" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.usernameTextField) {
        [self.passwordTextField becomeFirstResponder];
    } else if (textField == self.passwordTextField) {
        [self.passwordNewTextField becomeFirstResponder];
    } else if (textField == self.passwordNewTextField) {
        [self changeAccount];
    }
    return YES;
}


    
@end
