//
//  AlbumInformation.m
//  vkPhotoViewerObjective
//
//  Created by Vitaliy on 11/7/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

#import "AlbumInformation.h"

@implementation AlbumInformation

- (id)initWithServerResponse:(NSDictionary*) responseObject {
    
    self = [super init];
    if (self) {
        
        self.albumId     = responseObject[@"aid"];
        self.name        = responseObject[@"title"];
        self.thumbId     = responseObject[@"thumb_id"];
        self.userId      = responseObject[@"owner_id"];
        self.photosCount = [responseObject[@"size"] integerValue];
    }
    return self;
}

@end
