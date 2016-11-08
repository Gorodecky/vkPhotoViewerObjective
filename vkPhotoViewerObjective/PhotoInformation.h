//
//  PhotoInformation.h
//  vkPhotoViewerObjective
//
//  Created by Vitaliy on 11/7/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoInformation : NSObject

@property (nonatomic, strong) NSString* photoId;
@property (nonatomic, strong) NSString* previewUrl;
@property (nonatomic, strong) NSString* photoUrl;
@property (nonatomic, strong) NSString* albumId;
@property (nonatomic, strong) NSString* ownerId;

- (id)initWithServerResponse:(NSDictionary*) responseObject;

@end
