//
//  ACAcollectionVC.m
//  alarmClock
//
//  Created by JOHN YAM on 6/2/14.
//  Copyright (c) 2014 John Yam. All rights reserved.
//

#import "ACAcollectionVC.h"
#import "ACAalarmData.h"

@interface ACAcollectionVC ()<UICollectionViewDelegateFlowLayout>

@end

@implementation ACAcollectionVC


- (id)initWithCollectionViewLayout:(UICollectionViewFlowLayout *)layout
{
    self = [super initWithCollectionViewLayout:layout];
    
    if (self) {
        
        self.view.backgroundColor = [UIColor lightGrayColor];
        
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        self.collectionView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
        
    }
    return self;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[ACAalarmData maindata].sortedTimes count];
    
    //[cell.timesButton setTitle:[[ACAalarmData maindata].sortedTimes[indexPath.row] objectForKey:@"NSString"] forState:UIControlStateNormal];

}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
  

    UIButton * timeButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 100, 60)];
    timeButton.backgroundColor = [UIColor magentaColor];
    
    [timeButton setTitle:[[ACAalarmData maindata].sortedTimes[indexPath.row] objectForKey:@"NSString"] forState:UIControlStateNormal];
    
    [cell.contentView addSubview: timeButton];
    
    cell.backgroundColor = [UIColor yellowColor];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(20, 20);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
