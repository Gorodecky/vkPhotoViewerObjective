//
//  PhotoCollectionViewCell.m
//  vkPhotoViewerObjective
//
//  Created by Vitaliy on 11/8/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

#import "PhotoCollectionViewCell.h"
#import "PhotoInformation.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface PhotoCollectionViewCell ()

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *indicator;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@end

@implementation PhotoCollectionViewCell

- (void)awakeFromNib {
    _imageView.hidden = YES;
    _indicator.hidden = NO;
    [_indicator startAnimating];
}

- (void)updateWithPhotoInformation:(PhotoInformation*)photoInformation {
    NSLog(@"updateWithPhotoInformation for photo =%@",photoInformation.photoId);
    
    if (photoInformation.previewUrl) {
        
        _indicator.hidden = NO;
        [_indicator startAnimating];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:photoInformation.previewUrl]];
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^(void){
            
            [_imageView setImageWithURLRequest:request
                              placeholderImage:nil
                                       success:^(NSURLRequest *request, NSHTTPURLResponse * response, UIImage *theImage) {
                                           
                                           dispatch_async(dispatch_get_main_queue(), ^(void){
                                               NSLog(@"Sucess Photo uploaded");
                                               _imageView.image = theImage;
                                               _imageView.hidden = NO;
                                               [_indicator stopAnimating];
                                               _indicator.hidden = YES;
                                           });
                                           
                                       } failure:^(NSURLRequest * request, NSHTTPURLResponse * response, NSError * error) {
                                           dispatch_async(dispatch_get_main_queue(), ^(void){
                                               NSLog(@"Error photo upload");
                                           });
                                       }];
        });
    }
}



@end
