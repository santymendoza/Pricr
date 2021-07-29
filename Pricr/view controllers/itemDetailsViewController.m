//
//  itemDetailsViewController.m
//  Pricr
//
//  Created by Santy Mendoza on 7/15/21.
//

#import "itemDetailsViewController.h"
#import <Parse/Parse.h>
#import "LoginViewController.h"
#import "ItemCollectionViewCell.h"
#import "Item.h"
#import "RelatedCollectionViewCell.h"
#import "Listing.h"
#import <WebBrowser/WebBrowser-umbrella.h>
#import <KINWebBrowser/KINWebBrowserViewController.h>
#import <WebKit/WebKit.h>

@interface itemDetailsViewController () <UICollectionViewDelegate,UICollectionViewDataSource, WKNavigationDelegate>
@property (weak, nonatomic) IBOutlet PFImageView *itemImage;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UILabel *itemName;
@property (weak, nonatomic) IBOutlet UILabel *itemDescription;
@property (weak, nonatomic) IBOutlet UICollectionView *relatedItemsCollection;
@property (weak, nonatomic) IBOutlet UILabel *itemPrice;
@property (strong,nonatomic) NSArray *arrayOfItems;
@property (strong,nonatomic) WKWebView *webview;



@end

@implementation itemDetailsViewController
- (IBAction)favorited:(id)sender {
    [self likeItem: _item];
}

- (void) likeItem:(Item *)item {
    if (![self isFavorited:self.item.favoriters]){

        if (item.favoriters == nil) {
            item.favoriters = [NSMutableArray new];
            [item[@"favoriters"] addObject:PFUser.currentUser];
        }
        else if (![item.favoriters containsObject:PFUser.currentUser]){
            NSMutableArray *tst = item.favoriters;
            item.favoriters = [NSMutableArray new];
            item.favoriters = tst;
            [item[@"favoriters"] addObject:PFUser.currentUser];
        }
        [self.favoriteButton setSelected:TRUE];
    }
    else{
        NSUInteger *index = 0;
        for (PFUser *favoriter in item[@"favoriters"]){
            if ([favoriter.objectId isEqual: PFUser.currentUser.objectId]){
                NSMutableArray *test = item.favoriters;
                item.favoriters = [NSMutableArray new];
                item.favoriters = test;
                [item[@"favoriters"] removeObjectAtIndex: index];
            }
            index++;
        }
        [self.favoriteButton setSelected:FALSE];
    }
    [item saveInBackground];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    if(![self.item isEqual: nil]){
        [self getItem];
    }
    [self makeDetails];
    self.relatedItemsCollection.delegate = self;
    self.relatedItemsCollection.dataSource = self;
    
    
    //layout stuff
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) self.relatedItemsCollection.collectionViewLayout;
    layout.minimumInteritemSpacing = 2;
    layout.minimumLineSpacing = 2;
    
    CGFloat itemsPerLine = 3;
    CGFloat itemWidth = (self.relatedItemsCollection.frame.size.width - layout.minimumInteritemSpacing * (itemsPerLine - 1)) / itemsPerLine;
    CGFloat itemHeight = itemWidth * 1.5;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    //double tap to like
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTap];
    
    [self getRelatedItems];
}
- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {
        [self likeItem: _item];
    }
}

- (BOOL) isFavorited: (NSMutableArray *) favoriters {
    
    for (PFUser *favoriter in favoriters){
        if ([favoriter.objectId isEqual: PFUser.currentUser.objectId]){
            return TRUE;
        }
    }
    return FALSE;
}
- (IBAction)searchTarget:(id)sender {
    self.webview = [WKWebView new];
    self.webview.navigationDelegate = self;
    self.view = self.webview;
    NSURL *url = [NSURL URLWithString:[@"https://www.target.com/s?searchTerm=" stringByAppendingString:[self.item.searchTitle stringByReplacingOccurrencesOfString:@" "withString:@"+"]]];
    [self.webview loadRequest:[NSURLRequest requestWithURL:url]];
    self.webview.allowsBackForwardNavigationGestures = TRUE;
   
}
- (IBAction)searchWalmart:(id)sender {
    self.webview = [WKWebView new];
    self.webview.navigationDelegate = self;
    self.view = self.webview;
    NSURL *url = [NSURL URLWithString:[@"https://www.walmart.com/search/?query=" stringByAppendingString:[self.item.searchTitle stringByReplacingOccurrencesOfString:@" "withString:@"%20"]]];
    [self.webview loadRequest:[NSURLRequest requestWithURL:url]];
    self.webview.allowsBackForwardNavigationGestures = TRUE;
}

- (void) makeDetails{
    self.itemName.text = self.item[@"name"];
    self.itemDescription.text = self.item[@"description"];
    self.itemImage.file = self.item[@"image"];
    if ([self isFavorited:self.item.favoriters]){
        [self.favoriteButton setSelected:TRUE];
    }
    Listing *new = self.item[@"prices"][0];
    self.itemPrice.text = new.price;
    [self.itemImage loadInBackground];
}
- (void) getItem{
    PFQuery *itemQuery = [PFQuery queryWithClassName:@"Item"];
    [itemQuery orderByDescending:@"createdAt"];
    [itemQuery includeKey:@"prices"];
    [itemQuery includeKey:@"favoriters"];
    [itemQuery includeKey:@"objectId"];
    itemQuery.limit = 20;
    // fetch data asynchronously
    [itemQuery findObjectsInBackgroundWithBlock:^(NSArray<Item *> * _Nullable items, NSError * _Nullable error) {
        if (items) {
            for (id item in items) {
                for (id listing in item[@"prices"]){
                    
                    if ([listing[@"name"] isEqual: self.listing[@"name"]]){
                        self.item = item;
                        [self makeDetails];
                    }
                }
            }
        }
        else {
        }
    }];
}

- (void) getRelatedItems{
    NSUInteger sizeOfArray = 4;
    NSMutableArray *relatedItems = [NSMutableArray array];
    NSMutableArray *relatedItemObjects = [NSMutableArray array];
    for (id itemList in [self.item.relatedItems reverseObjectEnumerator]){
        if(itemList != nil){
            for (id item in itemList){
                if(sizeOfArray != 0){
                    [relatedItems addObject:item];
                    sizeOfArray--;
                }
            }
        }
    }
    PFQuery *itemQuery = [PFQuery queryWithClassName:@"Item"];
    [itemQuery orderByDescending:@"createdAt"];
    [itemQuery includeKey:@"prices"];
    [itemQuery includeKey:@"favoriters"];
    [itemQuery includeKey:@"objectId"];
    itemQuery.limit = 4;
    // fetch data asynchronously
    [itemQuery findObjectsInBackgroundWithBlock:^(NSArray<Item *> * _Nullable items, NSError * _Nullable error) {
        if (items) {
            for (Item *item in items) {
                for (Item *relatedItem in relatedItems){
                    if ([relatedItem.objectId isEqual:item.objectId]){
                        [relatedItemObjects addObject:item];
                    }
                }
            }
            self.arrayOfItems = relatedItemObjects;
            [self.relatedItemsCollection reloadData];

        }
        else {
        }
    }];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
     RelatedCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"relatedCell" forIndexPath:indexPath];
    
    Item *item = self.arrayOfItems[indexPath.item];
    
    [cell setItem:item];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return  self.arrayOfItems.count;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UITableView *tappedCell = sender;
    NSIndexPath *indexPath = [self.relatedItemsCollection indexPathForCell: tappedCell];
    NSDictionary *item = self.arrayOfItems[indexPath.item];
    
    itemDetailsViewController *detailViewController = [segue destinationViewController];
    detailViewController.item = item;
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
