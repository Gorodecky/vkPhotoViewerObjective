//
//  AlbumsViewController.m
//  vkPhotoViewerObjective
//
//  Created by Vitaliy on 11/8/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

#import "AlbumsViewController.h"
#import "ServerManager.h"
#import "User.h"
#import "AlbumInformation.h"
#import "PhotoPreviewCell.h"
#import "PhotoListViewController.h"


@interface AlbumsViewController () <UITableViewDataSource, UITableViewDelegate>

{
    NSArray *albums;
}


@property (assign, nonatomic) BOOL firstTimeAppear;
@property (weak, nonatomic) IBOutlet UITableView *albumsTable;

@end

@implementation AlbumsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"PhotoPreviewCell" bundle:nil];
    [[self albumsTable] registerNib:nib forCellReuseIdentifier:@"cellIdn"];
    
    _albumsTable.delegate = self;
    _albumsTable.dataSource = self;
    
    
    self.firstTimeAppear = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.firstTimeAppear) {
        
        self.firstTimeAppear = NO;
        
        [[ServerManager shareManager] authorizeUser:^(User *user) {
            
            NSLog(@"AUTHORIZED!");
            NSLog(@"%@ %@", user.firstName, user.lastName);
            
            [[ServerManager shareManager] getAlbumsWithUserId:user.userId onSuccess:^(NSArray *albumsInformation) {
                
                if (albumsInformation.count > 0) {
                    
                    albums =  albumsInformation;
                    
                    [self getPhotoInformationForAlbums];
                    
                    [_albumsTable reloadData];
                    
                } else {
                    
                    PhotoListViewController* alert =[[PhotoListViewController alloc]init];
                    
                    [alert createAlertViewControllerWithTitle:@"Notification" mesage:@"Missing any albums"];
                    
                }
            } onFailure:^(NSError *error, NSInteger statusCode) {
                PhotoListViewController* alert =[[PhotoListViewController alloc]init];
                
                [alert createAlertViewControllerWithTitle:@"Error" mesage:@"Can not obtain albums"];
                
            }];
        }];
    }
}


- (void)getPhotoInformationForAlbums
{
    for (AlbumInformation *album in albums) {
        
        [[ServerManager shareManager] getPhotoInformationWithUserId:album.userId
                                                            albumId:album.albumId
                                                            photoId:album.thumbId
                                                          onSuccess:^(PhotoInformation *photoInformation) {
                                                              
                                                              album.preview = photoInformation;
                                                              
                                                              [_albumsTable reloadData];
                                                              
                                                          } onFailure:^(NSError *error, NSInteger statusCode) {
                                                              
                                                              NSLog(@"Can not download information about photo = %@",error);
                                                          }];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return albums.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 110;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdn = @"cellIdn";
    
    PhotoPreviewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdn];
    
    AlbumInformation *albumInformation = albums[indexPath.row];
    
    [cell udateWithAlbumInformation:albumInformation];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AlbumInformation *selectedAlbum = albums[indexPath.row];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PhotoListViewController *detailViewController = [storyboard instantiateViewControllerWithIdentifier:@"PhotoListViewController"];
    
    detailViewController.album = selectedAlbum;
    
    [self.navigationController pushViewController:detailViewController animated:YES];
    
    
    //presentViewController:detailViewController animated:YES completion:nil];
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
