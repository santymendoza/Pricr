//
//  ListingsViewController.m
//  Pricr
//
//  Created by Santy Mendoza on 8/2/21.
//

#import "ListingsViewController.h"
#import "ListingTableViewCell.h"
#import "Listing.h"


@interface ListingsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *arrayOfListings;
@end

@implementation ListingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    // Do any additional setup after loading the view.
}

- (void) getData {
    // construct PFQuery
    self.arrayOfListings = [NSMutableArray new];
    PFQuery *listingQuery = [PFQuery queryWithClassName:@"Listing"];
    [listingQuery orderByDescending:@"createdAt"];
    [listingQuery includeKey:@"author"];
    [listingQuery includeKey:@"prices"];
    listingQuery.limit = 20;

    // fetch data asynchronously
    [listingQuery findObjectsInBackgroundWithBlock:^(NSArray<Listing *> * _Nullable listings, NSError * _Nullable error) {
        if (listings) {
            for (Listing *lstng in listings){
                if ([lstng.name isEqual:self.item.name]){
                    [self.arrayOfListings addObject:lstng];
                    [self.tableView reloadData];

                }
            }
        }
        else {
            // handle error
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfListings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ListingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListingCell" forIndexPath:indexPath];
    
    [cell updateWithInfo: self.arrayOfListings[indexPath.row]];
    
    
    return cell;
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
