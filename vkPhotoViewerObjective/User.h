//
//  User.h
//  vkPhotoViewerObjective
//
//  Created by Vitaliy on 11/7/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong, nonatomic) NSString* firstName;
@property (strong, nonatomic) NSString* lastName;
@property (strong, nonatomic) NSString* userId;
@property (strong, nonatomic) NSURL*    imageUrl;

- (id) initWithServerResponse:(NSDictionary*) responseObject;

@end
