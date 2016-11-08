//
//  PhotoInformation.m
//  vkPhotoViewerObjective
//
//  Created by Vitaliy on 11/7/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

#import "PhotoInformation.h"

@implementation PhotoInformation

- (id)initWithServerResponse:(NSDictionary*) responseObject {
    
    self = [super init];
    if (self) {
        
        self.photoId    = responseObject[@"pid"];
        self.previewUrl = responseObject[@"src_small"];
        self.photoUrl   = responseObject[@"src_big"];
        self.albumId    = responseObject[@"aid"];
        self.ownerId    = responseObject[@"owner_id"];
    }
    return self;
}

@end
