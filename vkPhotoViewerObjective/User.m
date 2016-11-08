//
//  User.m
//  vkPhotoViewerObjective
//
//  Created by Vitaliy on 11/7/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

#import "User.h"

@implementation User

- (id) initWithServerResponse:(NSDictionary*) responseObject {
    self = [super init];
    if (self) {
        
        self.firstName = responseObject[@"first_name"];
        self.lastName = responseObject[@"last_name"];
        self.userId = responseObject[@"uid"];
        
        NSString* urlString = [responseObject objectForKey:@"photo_50"];
        
        if (urlString) {
            self.imageUrl = [NSURL URLWithString:urlString];
        }
    }
    return self;
}

@end
