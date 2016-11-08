//
//  ServerManager.m
//  vkPhotoViewerObjective
//
//  Created by Vitaliy on 11/7/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

#import "ServerManager.h"
#import "User.h"
#import "AccessToken.h"
#import <AFNetworking/AFNetworking.h>
#import "LoginViewController.h"
#import "AlbumInformation.h"
#import "PhotoInformation.h"

@interface ServerManager();

@property (strong, nonatomic) AFHTTPSessionManager* requestOperationManager;
@property (strong, nonatomic) AccessToken* accessToken;

@end

@implementation ServerManager

+ (ServerManager*) shareManager {
    
    static ServerManager* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once (&onceToken, ^{
        
        manager = [[ServerManager alloc] init];
    });
    
    return manager;
}

- (id)init {
    
    self = [super init];
    if (self) {
        
        NSURL* url = [NSURL URLWithString:@"https://api.vk.com/method/"];
        self.requestOperationManager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
    }
    return self;
}

- (void) authorizeUser:(void(^)(User* user)) completion {
    
    LoginViewController* vc =
    [[LoginViewController alloc] initWithCompletionBlock:^(AccessToken *token) {
        
        self.accessToken = token;
        
        if (token) {
            
            [self getUser:self.accessToken.userID
                onSuccess:^(User* user) {
                    if (completion) {
                        completion(user);
                    }
                }
                onFailure:^(NSError *error, NSInteger statusCode) {
                    
                    if (completion) {
                        completion(nil);
                    }
                }];
            
        } else  if (completion) {
            
            completion(nil);
        }
    }];
    
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    UIViewController* mainVC = [[[[UIApplication sharedApplication] windows] firstObject] rootViewController];
    
    [mainVC presentViewController:nav
                         animated:YES
                       completion:nil];
}

- (void) getUser:(NSString*) userID
       onSuccess:(void(^)(User* user)) success
       onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    NSDictionary* params =
    [NSDictionary dictionaryWithObjectsAndKeys:
     userID,        @"user_id",
     @"photo_50",   @"username",
     @"nom",        @"name_case", nil];
    
    [self.requestOperationManager
     GET:@"users.get"
     parameters:params
     progress:^(NSProgress * _Nonnull downloadProgress) {
         
     } success:^(NSURLSessionDataTask * operation, id  _Nullable responseObject) {
         NSLog(@"JSON: %@", responseObject);
         
         NSArray* dictsArray = [responseObject objectForKey:@"response"];
         
         if ([dictsArray count] > 0) {
             User* user = [[User alloc] initWithServerResponse:[dictsArray firstObject]];
             if (success) {
                 success(user);
             }
         } else {
             
             if (failure) {
                 NSLog(@"Error");
             }
         }
         
     } failure:^(NSURLSessionDataTask * operation, NSError *  error) {
         NSLog(@"Error %@", error);
     }];
}

- (void) getAlbumsWithUserId:(NSString*) userId
                   onSuccess:(void(^)(NSArray* albums)) success
                   onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    NSDictionary *params = @{@"user_id":userId,
                             @"version":@"5.41"};
    
    [self.requestOperationManager
     GET:@"photos.getAlbums"
     parameters:params
     progress:^(NSProgress * _Nonnull downloadProgress) {
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         
         if (responseObject[@"response"] != nil)
         {
             NSMutableArray *albums = [NSMutableArray array];
             
             for (NSDictionary *albumDictionary in responseObject[@"response"]) {
                 
                 AlbumInformation *albumInfo = [[AlbumInformation alloc]
                                                initWithServerResponse:albumDictionary];
                 
                 if (albumInfo) {
                     
                     [albums addObject:albumInfo];
                 }
             }
             success(albums);
         } else {
             
             success(nil);
         }
         
         NSLog(@"responseObject = %@",responseObject);
         
     } failure:^(NSURLSessionDataTask * operation, NSError * _Nonnull error) {
         NSLog(@"Error %@", error);
     }];
}

- (void) getPhotoInformationWithUserId:(NSString*) userId
                               albumId:(NSString*) albumId
                               photoId:(NSString*) photoId
                             onSuccess:(void(^)(PhotoInformation *photoInformation)) success
                             onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    NSDictionary *params = @{@"owner_id":userId,
                             @"album_id":albumId,
                             @"photo_ids":photoId};
    
    [self.requestOperationManager GET:@"photos.get" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * operation, id  _Nullable responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        
        PhotoInformation *info = [[PhotoInformation alloc] initWithServerResponse:[responseObject[@"response"] firstObject]];
        
        if (info) {
            
            success(info);
        } else {
            NSLog(@"Error");
        }
    } failure:^(NSURLSessionDataTask * operation, NSError * _Nonnull error) {
        NSLog(@"Error %@", error);
        
    }];
    
}

- (void) getPhotosFromAlbum:(AlbumInformation*) album
                  onSuccess:(void(^)(NSArray* photos)) success
                  onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    NSDictionary *params = @{@"owner_id":album.userId,
                             @"album_id":album.albumId};
    
    [self.requestOperationManager GET:@"photos.get" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * operation, id  _Nullable responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        
        NSMutableArray *photosList = [NSMutableArray array];
        
        for (NSDictionary *dictionary in responseObject[@"response"]) {
            
            PhotoInformation *photoInfo = [[PhotoInformation alloc] initWithServerResponse:dictionary];
            
            if (photoInfo) {
                
                [photosList addObject:photoInfo];
            }
        }
        success(photosList);
        
    } failure:^(NSURLSessionDataTask * operation, NSError * _Nonnull error) {
        NSLog(@"Error %@", error);
        
        
    }];
}

@end
