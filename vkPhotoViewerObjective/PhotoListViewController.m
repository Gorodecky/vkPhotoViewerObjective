//
//  PhotoListViewController.m
//  vkPhotoViewerObjective
//
//  Created by Vitaliy on 11/8/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

#import "PhotoListViewController.h"
#import "AlbumInformation.h"
#import "PhotoInformation.h"
#import "ServerManager.h"
#import "PhotoCollectionViewCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface PhotoListViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

{
    BOOL nibMyCellloaded;
}

@property (nonatomic, weak) IBOutlet UICollectionView*        photosCollection;
@property (weak, nonatomic) IBOutlet UIView*                  viewPhotoReview;
@property (weak, nonatomic) IBOutlet UIImageView*             fullscreenPhoto;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView* activityLoadFullscreen;
@property (weak, nonatomic) IBOutlet UIButton*                closeBtn;

@end

@interface PhotoListViewController ()

@end

@implementation PhotoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    nibMyCellloaded = NO;
    
    self.navigationController.navigationBar.hidden = NO;
    
    [_photosCollection registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:@"FlickrCell"];
    
    self.title = _album.name;
    
    _photosCollection.delegate = self;
    _photosCollection.dataSource = self;
    
    
    
    [[ServerManager shareManager] getPhotosFromAlbum:_album onSuccess:^(NSArray *photos) {
        
        if (photos.count > 0) {
            
            _album.photos = photos;
            
            [_photosCollection reloadData];
        } else {
            
            [self createAlertViewControllerWithTitle:@"Notification"
                                              mesage:@"Missing photos in the album"];
            
        }
        
    } onFailure:^(NSError *error, NSInteger statusCode) {
        
        [self createAlertViewControllerWithTitle:@"Error"
                                          mesage:@"Can not obtain photos"];
    }];
}

- (void) createAlertViewControllerWithTitle:(NSString*)title mesage:(NSString*)mesage {
    
    UIAlertController* alert = [UIAlertController
                                alertControllerWithTitle:title
                                message:mesage
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* action = [UIAlertAction
                             actionWithTitle:@"Ok"
                             style:UIAlertActionStyleDefault
                             handler:nil];
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
    return _album.photos.count;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = @"FlickrCell";
    
    if(!nibMyCellloaded) {
        
        UINib *nib = [UINib nibWithNibName:@"PhotoCollectionViewCell" bundle: nil];
        [cv registerNib:nib forCellWithReuseIdentifier:identifier];
        nibMyCellloaded = YES;
    }
    
    PhotoCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"FlickrCell"
                                                                  forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];
    
    PhotoInformation *photoInformation = _album.photos[indexPath.row];
    
    [cell updateWithPhotoInformation:photoInformation];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.view bringSubviewToFront:_viewPhotoReview];
    
    [_viewPhotoReview bringSubviewToFront:_activityLoadFullscreen];
    [_activityLoadFullscreen startAnimating];
    _activityLoadFullscreen.hidden = NO;
    _viewPhotoReview.hidden = NO;
    _fullscreenPhoto.hidden = YES;
    
    [self loadPhotoInFullScreen:_album.photos[indexPath.row]];
    
    // TODO: Select Item
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}

#pragma mark - Action

- (IBAction)onClose:(id)sender {
    
    _viewPhotoReview.hidden = YES;
}

#pragma mark -

- (void)loadPhotoInFullScreen:(PhotoInformation*)photoInformation {
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:photoInformation.photoUrl]];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^(void){
        [_fullscreenPhoto setImageWithURLRequest:request
                                placeholderImage:nil
                                         success:^(NSURLRequest *request, NSHTTPURLResponse * response, UIImage *theImage) {
                                             
                                             dispatch_async(dispatch_get_main_queue(), ^(void){
                                                 NSLog(@"Sucess Photo uploaded");
                                                 _fullscreenPhoto.image = theImage;
                                                 _fullscreenPhoto.hidden = NO;
                                                 
                                                 [_activityLoadFullscreen stopAnimating];
                                                 _activityLoadFullscreen.hidden = YES;
                                             });
                                         } failure:^(NSURLRequest * request, NSHTTPURLResponse * response, NSError * error) {
                                             dispatch_async(dispatch_get_main_queue(), ^(void){
                                                 
                                                 [self createAlertViewControllerWithTitle:@"Error" mesage:@"Can not download image"];
                                             });
                                         }];
    });
}


@end
