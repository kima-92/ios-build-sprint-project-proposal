//
//  AddChildOBJCViewController.h
//  Santa I Wish
//
//  Created by brian vilchez on 2/7/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Santa_I_Wish-Swift.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddChildOBJCViewController : UIViewController

@property Parent *childParent;
@property SantaIWishController *santaIWishController;
@property (weak, nonatomic) IBOutlet UITextField *childNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *childAgeTextField;

@end

NS_ASSUME_NONNULL_END
