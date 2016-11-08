//
//  LoginViewController.h
//  vkPhotoViewerObjective
//
//  Created by Vitaliy on 11/7/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AccessToken;

typedef void(^LoginCompletionBlock)(AccessToken* token);

@interface LoginViewController : UIViewController

- (id) initWithCompletionBlock:(LoginCompletionBlock) completionBlock;

@end
