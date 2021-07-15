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

@interface ProfileViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic) IBOutlet UICollectionView *itemCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (strong,nonatomic) NSArray *arrayOfItems;



@end

static NSString * const reuseIdentifier = @"Cell";

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.name.text = PFUser.currentUser.username;
    
    
    
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
