//
//  PhotoListViewController.h
//  vkPhotoViewerObjective
//
//  Created by Vitaliy on 11/8/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AlbumInformation;

@interface PhotoListViewController : UIViewController

@property (nonatomic, strong) AlbumInformation *album;
- (void) createAlertViewControllerWithTitle:(NSString*)title mesage:(NSString*)mesage;
@end
