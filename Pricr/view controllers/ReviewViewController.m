//
//  ReviewViewController.m
//  Pricr
//
//  Created by Santy Mendoza on 8/4/21.
//

#import "ReviewViewController.h"
#import <Parse/Parse.h>



@interface ReviewViewController ()
@property (weak, nonatomic) IBOutlet UIButton *starOne;
@property (weak, nonatomic) IBOutlet UIButton *starTwo;
@property (weak, nonatomic) IBOutlet UIButton *starThree;
@property (weak, nonatomic) IBOutlet UIButton *starFour;
@property (weak, nonatomic) IBOutlet PFImageView *ItemImage;
@property (weak, nonatomic) IBOutlet UIButton *starFive;
@property (weak, nonatomic) IBOutlet UITextView *reviewTextView;
@property (strong,nonatomic) NSNumber *numStars;

@end

@implementation ReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //set item image
    self.ItemImage.file = self.item[@"image"];
    self.ItemImage.layer.cornerRadius = 10.0;
    self.ItemImage.clipsToBounds = YES;
    [self.ItemImage loadInBackground];
    
    
}
- (IBAction)postButton:(id)sender {
    
}
- (IBAction)starOneTapped:(id)sender {
}
- (IBAction)starTwoTapped:(id)sender {
    [self clearStars];
    [self starOneTapped:nil];

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

@end
