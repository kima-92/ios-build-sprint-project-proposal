//
//  AddChildOBJCViewController.m
//  Santa I Wish
//
//  Created by brian vilchez on 2/7/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

#import "AddChildOBJCViewController.h"
#import "Santa_I_Wish-Swift.h"
@interface AddChildOBJCViewController ()

@end

@implementation AddChildOBJCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
}

- (instancetype)initWithCoder:(NSCoder *)coder {
   self = [super initWithCoder:coder];
    
    if(self) {
        _santaIWishController = [[SantaIWishController alloc] init];
        _childParent = [[Parent alloc] init];
        
    }
    
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
          _santaIWishController = [[SantaIWishController alloc] init];
          _childParent = [[Parent alloc] init];
          
      }
    return self;
}

- (IBAction)backButton:(UIButton *)sender {
    [[self navigationController]popViewControllerAnimated:true];
}

- (IBAction)doneBUtton:(UIButton *)sender {
    NSString *childName = [[self childNameTextField]text];
    NSString * childAgeString = [[self childAgeTextField] text];
    NSInteger childAge = [childAgeString integerValue];
    [[self santaIWishController]addChildWithName:childName age: childAge context:[[CoreDataStack shared]mainContext]];
    [[self navigationController]popViewControllerAnimated:true];
}


@end
