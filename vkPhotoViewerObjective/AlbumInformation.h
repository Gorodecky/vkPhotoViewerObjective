//
//  AlbumInformation.h
//  vkPhotoViewerObjective
//
//  Created by Vitaliy on 11/7/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotoInformation.h"

@interface AlbumInformation : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *albumId;
@property (nonatomic, strong) NSString *thumbId;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, assign) NSInteger photosCount;
@property (nonatomic, strong) PhotoInformation *preview;
@property (nonatomic, strong) NSArray *photos;

- (id)initWithServerResponse:(NSDictionary*) responseObject;

@end
