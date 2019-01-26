//
//  EGBTableViewController.m
//  29UITableViewStaticCellsHW
//
//  Created by Eduard Galchenko on 1/26/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

#import "EGBTableViewController.h"

@interface EGBTableViewController ()

@end

static NSString *kApplicationName           = @"name";
static NSString *kApplicationSurname        = @"surname";
static NSString *kApplicationAge            = @"age";
static NSString *kApplicationLogin          = @"login";
static NSString *kApplicationPassword       = @"password";
static NSString *kApplicationPhone          = @"phone";
static NSString *kApplicationEmail          = @"email";
static NSString *kApplicationAddress        = @"address";
static NSString *kApplicationGender         = @"gender";
static NSString *kApplicationExperienced    = @"experienced";
static NSString *kApplicationVolume         = @"volume";
static NSString *kApplicationLevel          = @"level";

@implementation EGBTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self loadApplication];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self selector:@selector(notificationKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [nc addObserver:self selector:@selector(notificationKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void) dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notifications

- (void) notificationKeyboardWillShow:(NSNotification*) notification {
    
    NSLog(@"notificationKeyboardWillShow:\n%@", notification.userInfo);
}

- (void) notificationKeyboardWillHide:(NSNotification*) notification {
    
    NSLog(@"notificationKeyboardWillHide:\n%@", notification.userInfo);
}

#pragma mark - Save and Load Data

- (void) saveApplication {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:self.nameField.text forKey:kApplicationName];
    [userDefaults setObject:self.surnameField.text forKey:kApplicationSurname];
    [userDefaults setObject:self.ageField.text forKey:kApplicationAge];
    [userDefaults setObject:self.loginField.text forKey:kApplicationLogin];
    [userDefaults setObject:self.passwordField.text forKey:kApplicationPassword];
    [userDefaults setObject:self.phoneField.text forKey:kApplicationPhone];
    [userDefaults setObject:self.emailField.text forKey:kApplicationEmail];
    [userDefaults setObject:self.addressField.text forKey:kApplicationAddress];
    [userDefaults setInteger:self.genderControl.selectedSegmentIndex forKey:kApplicationGender];
    [userDefaults setBool:self.experiencedUserSwitch.isOn forKey:kApplicationExperienced];
    [userDefaults setDouble:self.volumeSlider.value forKey:kApplicationVolume];
    [userDefaults setDouble:self.levelSlider.value forKey:kApplicationLevel];
    
    [userDefaults synchronize];
}

- (void) loadApplication {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    self.nameField.text = [userDefaults objectForKey:kApplicationName];
    self.surnameField.text = [userDefaults objectForKey:kApplicationSurname];
    self.ageField.text = [userDefaults objectForKey:kApplicationAge];
    self.loginField.text = [userDefaults objectForKey:kApplicationLogin];
    self.passwordField.text = [userDefaults objectForKey:kApplicationPassword];
    self.phoneField.text = [userDefaults objectForKey:kApplicationPhone];
    self.emailField.text = [userDefaults objectForKey:kApplicationEmail];
    self.addressField.text = [userDefaults objectForKey:kApplicationAddress];
    self.genderControl.selectedSegmentIndex = [userDefaults integerForKey:kApplicationGender];
    self.experiencedUserSwitch.on = [userDefaults boolForKey:kApplicationExperienced];
    self.volumeSlider.value = [userDefaults doubleForKey:kApplicationVolume];
    self.levelSlider.value = [userDefaults doubleForKey:kApplicationLevel];
}

#pragma mark - Actions

- (IBAction)actionTextChanged:(UITextField *)sender {
    
    [self saveApplication];
}

- (IBAction)actionValueChanged:(id)sender {
    
    [self saveApplication];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([textField isEqual:self.phoneField]) {
        
        return [self textField:textField checkingPhoneNumber:range replacementString:string];
    }
    
    if ([textField isEqual:self.ageField]) {
        
        return [self textField:textField checkingAge:range replacementString:string];
    }
    
    if ([textField isEqual:self.emailField]) {
        
        return [self textField:textField checkingEmail:range replacementString:string];
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    NSInteger currentTextField = [self.allTextFields indexOfObject:textField];
    NSInteger lastAddressField = [self.allTextFields indexOfObject:[self.allTextFields lastObject]];
    
    if (currentTextField < [self.allTextFields count]) {
        
        if (currentTextField != lastAddressField) {
            
            UITextField * nextTextField = self.allTextFields[currentTextField + 1];
            [nextTextField becomeFirstResponder];
            
        } else {
            
            [textField resignFirstResponder];
        }
    }
    
    return YES;
}

#pragma mark - Private Methods

- (BOOL)textField:(UITextField *)textField checkingEmail:(NSRange)range replacementString:(NSString *)string {
    
    NSMutableCharacterSet* alphanumericeSet = [NSMutableCharacterSet alphanumericCharacterSet];
    [alphanumericeSet addCharactersInString:@"@."];
    
    NSCharacterSet* atSet = [alphanumericeSet invertedSet];
    
    NSArray* components = [string componentsSeparatedByCharactersInSet:atSet];
    
    if (components.count > 1) {
        
        return NO;
    }
    
    if ([string containsString:@"@"] && [textField.text containsString:@"@"]) {
        
        NSRange existingRange = [textField.text localizedStandardRangeOfString:@"@"];
        
        if (!NSLocationInRange(existingRange.location, range)) {
            return NO;
        }
        
    }
    
    NSString* newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    return newString.length < 30;
}

- (BOOL)textField:(UITextField *)textField checkingAge:(NSRange)range replacementString:(NSString *)string {
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSCharacterSet *set = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSArray *result = [string componentsSeparatedByCharactersInSet:set];
    
    if ([result count] > 1) {
        
        return NO;
    }
    
    NSLog(@"Age newString = %@", newString);
    
    return YES;
}


- (BOOL)textField:(UITextField *)textField checkingPhoneNumber:(NSRange)range replacementString:(NSString *)string {
    
    NSCharacterSet *validationSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSArray *components = [string componentsSeparatedByCharactersInSet:validationSet];
    
    if ([components count] > 1) {
        return NO;
    }
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    // +XX (XXX) XXX-XXXX
    
    NSLog(@"new string: %@", newString);
    
    NSArray *validComponents = [newString componentsSeparatedByCharactersInSet:validationSet];
    newString = [validComponents componentsJoinedByString:@""];
    
    // XXXXXXXXXXXX
    
    NSLog(@"new string fixed: %@", newString);
    
    static const int localNumberMaxLength = 7;
    static const int countryCodeMaxLength = 3;
    static const int areaCodeMaxLength = 3;
    
    if ([newString length] > localNumberMaxLength + countryCodeMaxLength + areaCodeMaxLength) {
        
        return NO;
    }
    
    NSMutableString *resultString = [NSMutableString string];
    
    // +XX (XXX) XXX-XXXX
    
    NSInteger localNumberLength = MIN([newString length], localNumberMaxLength);
    
    if (localNumberLength > 0) {
        
        NSString *number = [newString substringFromIndex:(int)[newString length] - localNumberLength];
        
        [resultString appendString:number];
        
        if ([resultString length] > 3) {
            
            [resultString insertString:@"-" atIndex:3];
        }
    }
    
    if ([newString length] > localNumberMaxLength) {
        
        NSInteger areaCodeLength = MIN([newString length] - localNumberLength, areaCodeMaxLength);
        
        NSRange areaRange = NSMakeRange((int)[newString length] - localNumberMaxLength - areaCodeLength, areaCodeLength);
        
        NSString *area = [newString substringWithRange:areaRange];
        
        area = [NSString stringWithFormat:@"(%@) ", area];
        
        [resultString insertString:area atIndex:0];
    }
    
    if ([newString length] > localNumberMaxLength + areaCodeMaxLength) {
        
        NSInteger countryCodeLength = MIN([newString length] - localNumberLength - areaCodeMaxLength, countryCodeMaxLength);
        
        NSRange countryRange = NSMakeRange(0, countryCodeLength);
        
        NSString *countryCode = [newString substringWithRange:countryRange];
        
        countryCode = [NSString stringWithFormat:@"+%@ ", countryCode];
        
        [resultString insertString:countryCode atIndex:0];
    }
    
    textField.text = resultString;
    
    return NO;
}

@end
