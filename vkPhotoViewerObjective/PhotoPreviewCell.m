//
//  PhotoPreviewCell.m
//  vkPhotoViewerObjective
//
//  Created by Vitaliy on 11/8/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

#import "PhotoPreviewCell.h"
#import "AlbumInformation.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface PhotoPreviewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *albumImage;
@property (weak, nonatomic) IBOutlet UILabel *albumName;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;


@end

@implementation PhotoPreviewCell

- (void)udateWithAlbumInformation:(AlbumInformation *)album {
    
    _albumName.text  = album.name;
    _indicator.hidden = NO;
    [_indicator startAnimating];
    _albumImage.clipsToBounds = YES;
    
    if (album.preview.previewUrl) {
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:album.preview.photoUrl]];
        
        [_albumImage setImageWithURLRequest:request
                           placeholderImage:nil
                                    success:^(NSURLRequest *request, NSHTTPURLResponse * response, UIImage *image) {
                                        
                                        NSLog(@"Sucess Photo uploaded");
                                        _albumImage.hidden = NO;
                                        [_indicator stopAnimating];
                                        _albumImage.image = image;
                                        _indicator.hidden = YES;
                                
                                } failure:^(NSURLRequest * request, NSHTTPURLResponse * response, NSError * error) {
                                    
                                        NSLog(@"Error photo upload");
                                    }];
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
