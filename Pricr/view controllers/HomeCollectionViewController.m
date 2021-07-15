//
//  HomeCollectionViewController.m
//  Pricr
//
//  Created by Santy Mendoza on 7/12/21.
//

#import "HomeCollectionViewController.h"
#import <Parse/Parse.h>
#import "Item.h"
#import "ItemCollectionViewCell.h"
#import "itemDetailsViewController.h"

@interface HomeCollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) IBOutlet UICollectionView *itemCollectionView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (strong,nonatomic) NSArray *arrayOfItems;



@end

@implementation HomeCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.itemCollectionView.delegate = self;
    self.itemCollectionView.dataSource = self;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
   [self.refreshControl addTarget: self action:@selector(getData) forControlEvents: UIControlEventValueChanged];
   [self.itemCollectionView  insertSubview:self.refreshControl atIndex:0];
   
    UICollectionViewFlowLayout *layout = self.collectionView.collectionViewLayout;
    
    
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    
    CGFloat posterPerLine = 3;
    CGFloat itemWidth = (self.collectionView.frame.size.width - layout.minimumInteritemSpacing * (posterPerLine - 1)) / posterPerLine;
    CGFloat itemHeight = itemWidth * 1.75;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    [self getData];
}



- (void) getData {
    // construct PFQuery
    PFQuery *itemQuery = [PFQuery queryWithClassName:@"Item"];
    [itemQuery orderByDescending:@"createdAt"];
    [itemQuery includeKey:@"author"];
    itemQuery.limit = 20;

    // fetch data asynchronously
    [itemQuery findObjectsInBackgroundWithBlock:^(NSArray<Item *> * _Nullable items, NSError * _Nullable error) {
        if (items) {
            self.arrayOfItems = items;
            [self.collectionView reloadData];
            [self.refreshControl endRefreshing];
        }
        else {
            // handle error
        }
    }];
}



//#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UITableView *tappedCell = sender;
    NSIndexPath *indexPath = [self.itemCollectionView indexPathForCell: tappedCell];
    NSDictionary *item = self.arrayOfItems[indexPath.item];
    
    itemDetailsViewController *detailViewController = [segue destinationViewController];
    detailViewController.item = item;
}


//#pragma mark <UICollectionViewDataSource>



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrayOfItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ItemCollectionViewCell" forIndexPath:indexPath];
    
    Item *item = self.arrayOfItems[indexPath.item];
    
    [cell setItem:item];
    
    return cell;
    
}

#pragma mark <UICollectionViewDelegate>


@end
