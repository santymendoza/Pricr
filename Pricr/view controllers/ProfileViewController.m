//
//  ProfileViewController.m
//  Pricr
//
//  Created by Santy Mendoza on 7/12/21.
//

#import "ProfileViewController.h"
#import <Parse/Parse.h>
#import "LoginViewController.h"
#import "ItemCollectionViewCell.h"
#import "Item.h"
#import <QuartzCore/QuartzCore.h>
#import "itemDetailsViewController.h"

@interface ProfileViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic) IBOutlet UICollectionView *itemCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (strong,nonatomic) NSArray *arrayOfItems;
@property (weak, nonatomic) IBOutlet PFImageView *profilePic;
@property (strong,nonatomic) PFUser *user;



@end

static NSString * const reuseIdentifier = @"Cell";

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.user = PFUser.currentUser;
    self.name.text = self.user.username;
    self.profilePic.file = self.user[@"profilePic"];
    self.profilePic.frame = CGRectMake(0, 0, 175, 175);
    self.profilePic.layer.cornerRadius = self.profilePic.frame.size.width * .5;
    self.profilePic.clipsToBounds = YES;
    [self.profilePic loadInBackground];

    
    
    
    self.itemCollectionView.delegate = self;
    self.itemCollectionView.dataSource = self;
    
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

- (IBAction)logoutPressed:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [[UIApplication sharedApplication].keyWindow setRootViewController: loginViewController];
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
    }];
}

- (void) getData {
    // construct PFQuery
    PFQuery *itemQuery = [PFQuery queryWithClassName:@"Item"];
    [itemQuery whereKey:@"author" equalTo:PFUser.currentUser];
    [itemQuery orderByDescending:@"createdAt"];
    [itemQuery includeKey:@"author"];
    itemQuery.limit = 20;

    // fetch data asynchronously
    [itemQuery findObjectsInBackgroundWithBlock:^(NSArray<Item *> * _Nullable items, NSError * _Nullable error) {
        if (items) {
            self.arrayOfItems = items;
            [self.itemCollectionView reloadData];
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
    UITableView *tappedCell = sender;
    NSIndexPath *indexPath = [self.itemCollectionView indexPathForCell: tappedCell];
    NSDictionary *item = self.arrayOfItems[indexPath.item];
    
    itemDetailsViewController *detailViewController = [segue destinationViewController];
    detailViewController.item = item;
}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ItemCollectionViewCell" forIndexPath:indexPath];
    
    Item *item = self.arrayOfItems[indexPath.item];
    
    [cell setItem:item];
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrayOfItems.count;
}



@end
