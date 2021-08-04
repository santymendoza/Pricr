//
//  SearchViewController.m
//  Pricr
//
//  Created by Santy Mendoza on 7/20/21.
//

#import "SearchViewController.h"
#import "HomeCollectionViewController.h"
#import <Parse/Parse.h>
#import "Item.h"
#import "ItemCollectionViewCell.h"
#import "itemDetailsViewController.h"

@interface SearchViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *itemCollectionView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (strong,nonatomic) NSMutableArray *arrayOfItems;
@property (strong,nonatomic) NSMutableArray *filteredItems;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation SearchViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.itemCollectionView.delegate = self;
    self.itemCollectionView.dataSource = self;
    self.searchBar.delegate = self;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
   [self.refreshControl addTarget: self action:@selector(getData) forControlEvents: UIControlEventValueChanged];
   [self.itemCollectionView  insertSubview:self.refreshControl atIndex:0];
   
    UICollectionViewFlowLayout *layout = self.itemCollectionView.collectionViewLayout;
    
    
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    
    CGFloat posterPerLine = 3;
    CGFloat itemWidth = (self.itemCollectionView.frame.size.width - layout.minimumInteritemSpacing * (posterPerLine - 1)) / posterPerLine;
    CGFloat itemHeight = itemWidth * 1.75;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    
    
    // Register cell classes
    [self.itemCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    [self getData];
}

//- (void) eliminateListings{
//    NSMutableArray *arr = [NSMutableArray new];
//
//    for (Item *item in self.arrayOfItems){
//        [arr addObject:item];
//        for (Item *item2 in self.arrayOfItems){
//            if (item.name == item2.name && item != item2){
//                [arr removeObject:item];
//            }
//        }
//    }
//    self.arrayOfItems = arr;
//
//}


- (void) getData {
    // construct PFQuery
    PFQuery *itemQuery = [PFQuery queryWithClassName:@"Item"];
    [itemQuery orderByDescending:@"createdAt"];
    [itemQuery includeKey:@"author"];
    [itemQuery includeKey:@"prices"];
    itemQuery.limit = 20;

    // fetch data asynchronously
    [itemQuery findObjectsInBackgroundWithBlock:^(NSArray<Item *> * _Nullable items, NSError * _Nullable error) {
        if (items) {
            
            self.arrayOfItems = items;
            self.filteredItems = self.arrayOfItems;
            [self.itemCollectionView reloadData];
            [self.refreshControl endRefreshing];
        }
        else {
            // handle error
        }
    }];
}

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{

    if (searchText.length != 0){
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(name CONTAINS[cd] %@)", searchText];
        self.filteredItems = [self.arrayOfItems filteredArrayUsingPredicate:predicate];
    }
    else{
        self.filteredItems = self.arrayOfItems;
    }
    [self.itemCollectionView reloadData];
}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = true;
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = false;
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
    self.filteredItems = self.arrayOfItems;
    [self.itemCollectionView reloadData];
}


//#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UITableView *tappedCell = sender;
    NSIndexPath *indexPath = [self.itemCollectionView indexPathForCell: tappedCell];
    NSDictionary *item = self.filteredItems[indexPath.item];
    
    itemDetailsViewController *detailViewController = [segue destinationViewController];
    detailViewController.item = item;
}


//#pragma mark <UICollectionViewDataSource>



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.filteredItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ItemCollectionViewCell" forIndexPath:indexPath];
    
    Item *item = self.filteredItems[indexPath.item];
    
    cell.contentView.layer.cornerRadius = 10;
    cell.contentView.layer.masksToBounds = YES;

    
    [cell setItem:item];
    
    return cell;
    
}

#pragma mark <UICollectionViewDelegate>


@end

