//
//  ServerManager.h
//  vkPhotoViewerObjective
//
//  Created by Vitaliy on 11/7/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

#import <Foundation/Foundation.h>
@class User, PhotoInformation, AlbumInformation;

@interface ServerManager : NSObject

@property (strong, nonatomic, readonly) User* currentUser;

+ (ServerManager*) shareManager;

- (void) authorizeUser:(void(^)(User* user)) completion;

- (void) getUser:(NSString*) userID
       onSuccess:(void(^)(User* user)) success
       onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void) getAlbumsWithUserId:(NSString*) userId
                   onSuccess:(void(^)(NSArray* albums)) success
                   onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void) getPhotoInformationWithUserId:(NSString*) userId
                               albumId:(NSString*) albumId
                               photoId:(NSString*) photoId
                             onSuccess:(void(^)(PhotoInformation *photoInformation))success
                             onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void) getPhotosFromAlbum:(AlbumInformation*)album
                  onSuccess:(void(^)(NSArray* photos)) success
                  onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

@end
