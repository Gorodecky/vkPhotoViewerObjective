//
//  PhotoCollectionViewCell.h
//  vkPhotoViewerObjective
//
//  Created by Vitaliy on 11/8/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PhotoInformation;

@interface PhotoCollectionViewCell : UICollectionViewCell

- (void)updateWithPhotoInformation:(PhotoInformation*)photoInformation;

@end
