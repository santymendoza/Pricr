//
//  ReviewViewController.m
//  Pricr
//
//  Created by Santy Mendoza on 8/4/21.
//

#import "ReviewViewController.h"
#import <Parse/Parse.h>
#import "Review.h"
#import "ReviewViewCell.h"



@interface ReviewViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *starOne;
@property (weak, nonatomic) IBOutlet UIButton *starTwo;
@property (weak, nonatomic) IBOutlet UIButton *starThree;
@property (weak, nonatomic) IBOutlet UIButton *starFour;
@property (weak, nonatomic) IBOutlet PFImageView *ItemImage;
@property (weak, nonatomic) IBOutlet UIButton *starFive;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextView *reviewTextView;
@property (strong,nonatomic) NSNumber *numStars;
@property (strong,nonatomic) NSString *date;
@property (strong,nonatomic) NSMutableArray *arrayOfReviews;



@end

@implementation ReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getData];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //set item image
    self.ItemImage.file = self.item[@"image"];
    self.ItemImage.layer.cornerRadius = 10.0;
    self.ItemImage.clipsToBounds = YES;
    [self.ItemImage loadInBackground];
    
    
}
- (IBAction)postButton:(id)sender {
    //get date
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    self.date = [dateFormatter stringFromDate:[NSDate date]];
    [Review postReview:self.numStars item:self.item review:self.reviewTextView.text date:self.date withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"successfully uploaded a review!");
            [self dismissViewControllerAnimated:YES completion:nil];
        } else{
            NSLog(@"did not post review!");
        }
    }];
    
}
- (IBAction)starOneTapped:(id)sender {
    [self clearStars];
    [self.starOne setSelected:TRUE];
    self.numStars = @1;
}
- (IBAction)starTwoTapped:(id)sender {
    [self clearStars];
    [self.starTwo setSelected:TRUE];
    [self.starOne setSelected:TRUE];
    self.numStars = @2;

}
- (IBAction)starThreeTapped:(id)sender {
    [self clearStars];
    [self.starThree setSelected:TRUE];
    [self.starTwo setSelected:TRUE];
    [self.starOne setSelected:TRUE];
    self.numStars = @3;
}
- (IBAction)starFourTapped:(id)sender {
    [self clearStars];
    [self.starFour setSelected:TRUE];
    [self.starThree setSelected:TRUE];
    [self.starTwo setSelected:TRUE];
    [self.starOne setSelected:TRUE];
    self.numStars = @4;
}
- (IBAction)starFiveTapped:(id)sender {
    [self clearStars];
    [self.starFive setSelected:TRUE];
    [self.starFour setSelected:TRUE];
    [self.starThree setSelected:TRUE];
    [self.starTwo setSelected:TRUE];
    [self.starOne setSelected:TRUE];
    self.numStars = @5;
    

}

- (void) clearStars{
    [self.starFive setSelected:FALSE];
    [self.starFour setSelected:FALSE];
    [self.starThree setSelected:FALSE];
    [self.starTwo setSelected:FALSE];
    [self.starOne setSelected:FALSE];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void) getData {
    // construct PFQuery
    self.arrayOfReviews = [NSMutableArray new];
    PFQuery *reviewQuery = [PFQuery queryWithClassName:@"Review"];
    [reviewQuery orderByDescending:@"createdAt"];
    [reviewQuery includeKey:@"reviewer"];
    [reviewQuery includeKey:@"item"];

    reviewQuery.limit = 20;

    // fetch data asynchronously
    [reviewQuery findObjectsInBackgroundWithBlock:^(NSArray<Review *> * _Nullable reviews, NSError * _Nullable error) {
        if (reviews) {
            for (Review *review in reviews){
                if ([review.item.objectId isEqual:self.item.objectId]){
                    [self.arrayOfReviews addObject:review];
                    [self.tableView reloadData];

                }
            }
        }
        else {
            // handle error
        }
    }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    ReviewViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReviewCell" forIndexPath:indexPath];
    [cell updateWithInfo: self.arrayOfReviews[indexPath.row]];
    
    
    return cell;
}



- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfReviews.count;
}


@end
