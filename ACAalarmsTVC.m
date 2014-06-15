//
//  ACAalarmsTVC.m
//  alarmClock
//
//  Created by JOHN YAM on 5/29/14.
//  Copyright (c) 2014 John Yam. All rights reserved.
//

#import "ACAalarmsTVC.h"
#import "ACAalarmData.h"
#import "ACATVCell.h"
#import "ACAalarmLabel.h"
#import "ACAbgLayer.h"

#import "ACATweetVC.h"



@interface ACAalarmsTVC () <ACATVCellDelegate>

@end

@implementation ACAalarmsTVC


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

        self.view.backgroundColor = [UIColor colorWithRed:0.906f green:0.980f blue:0.937f alpha:1.0f];
        self.tableView.separatorInset = UIEdgeInsetsZero;
        self.tableView.separatorColor = [UIColor whiteColor];
        
        self.tableView.rowHeight = 100;
        
        UIView * header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
        
        header.backgroundColor = [UIColor colorWithRed:0.631f green:0.671f blue:0.671f alpha:1.0f];
        
        self.tableView.tableHeaderView = header;
        
        ACAalarmLabel * headerLabel = [[ACAalarmLabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
        [header addSubview:headerLabel];
        
        headerLabel.text = @"Saved Alarms";
        headerLabel.textAlignment = NSTextAlignmentCenter;
        headerLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:32];
        
        UISwipeGestureRecognizer * rightGest = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
        rightGest.direction = UISwipeGestureRecognizerDirectionRight;
        [self.view addGestureRecognizer:rightGest];
        
//        UISwipeGestureRecognizer * leftGest = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
//        leftGest.direction = UISwipeGestureRecognizerDirectionLeft;
//        [self.view addGestureRecognizer:leftGest];
        
        [self.tableView registerClass:[ACATVCell class] forCellReuseIdentifier:@"cell"];

        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)swipeRight:gesture
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//- (void)swipeLeft:gesture
//{
//    ACATweetVC * tweetVC = [[ACATweetVC alloc] init];
//    
//    [self.navigationController pushViewController:tweetVC animated:YES];
//}

- (void)talktoTVC:(NSInteger)num
{
    [self.delegate statusColor:num];
}


//- (void)setSnoozeValues: (NSInteger)num
//{
//    [self.delegate addingSnooze:num];
//}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [[ACAalarmData maindata].sortedTimes count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACATVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.delegate = self;
    
    cell.index = indexPath.row;
    
    cell.timesLabel.text = [[ACAalarmData maindata].sortedTimes[indexPath.row] objectForKey:@"NSString"];
    
    if ([ACAalarmData maindata].sortedTimes[indexPath.row][@"Notification"] != NULL) {
    
        cell.bgLabel.backgroundColor = [UIColor colorWithRed:0.235f green:0.878f blue:0.388f alpha:1.0f];
        cell.alarmActive = YES;
        
        [self.delegate statusColor:1];
    
    } else {
        cell.bgLabel.backgroundColor = [UIColor colorWithRed:0.212f green:0.392f blue:0.475f alpha:1.0f];
        cell.alarmActive = NO;
        
        [self.delegate statusColor:2];

    }
    return cell;
}


- (BOOL)prefersStatusBarHidden
{
    return YES;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {

//        if (indexPath.row > [[ACAalarmData maindata].sortedTimes count]) {
//            return;
//        }
        
        [self.delegate statusColor:2];
        
        
        if ([ACAalarmData maindata].alarmList[indexPath.row][@"Notification"])
            
        {

        UILocalNotification * notification = [ACAalarmData maindata].alarmList[indexPath.row][@"Notification"];
        [[UIApplication sharedApplication] cancelLocalNotification:notification];
            
        }
        
         [[ACAalarmData maindata].alarmList removeObjectAtIndex:indexPath.row];


        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table vie
        
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([ACAalarmData maindata].sortedTimes[indexPath.row][@"Notification"]) {
        
        ACATweetVC * tweetVC = [[ACATweetVC alloc] init];
        
        [self.navigationController pushViewController:tweetVC animated:YES];
        
    }
    
    NSLog(@"you selected row %ld", (long)indexPath.row);
}



/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
