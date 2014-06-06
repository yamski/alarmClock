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


@interface ACAalarmsTVC () 

@end

@implementation ACAalarmsTVC


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

        self.view.backgroundColor = [UIColor colorWithRed:0.906f green:0.980f blue:0.937f alpha:1.0f];
        self.tableView.separatorInset = UIEdgeInsetsZero;
        self.tableView.separatorColor = [UIColor whiteColor];
        
        self.tableView.rowHeight = 125;
        
        UIView * header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
        
        header.backgroundColor = [UIColor colorWithRed:0.631f green:0.671f blue:0.671f alpha:1.0f];
        
        self.tableView.tableHeaderView = header;
        
        ACAalarmLabel * headerLabel = [[ACAalarmLabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
        [header addSubview:headerLabel];
        
        headerLabel.text = @"Saved Alarms";
        headerLabel.textAlignment = NSTextAlignmentCenter;
        headerLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:32];
        
        UISwipeGestureRecognizer * rightGest = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
        rightGest.direction = UISwipeGestureRecognizerDirectionRight;
        [self.view addGestureRecognizer:rightGest];
        
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
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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
    
    [cell.timesButton setTitle:[[ACAalarmData maindata].sortedTimes[indexPath.row] objectForKey:@"NSString"] forState:UIControlStateNormal];
    
    if ([ACAalarmData maindata].sortedTimes[indexPath.row][@"Notification"] != NULL) {
    
        cell.timesButton.backgroundColor = [UIColor colorWithRed:0.235f green:0.878f blue:0.388f alpha:1.0f];
        cell.alarmActive = YES;
    
        NSLog(@"green background");
    
    } else {
        cell.timesButton.backgroundColor = [UIColor colorWithRed:0.212f green:0.392f blue:0.475f alpha:1.0f];
        cell.alarmActive = NO;
        
         NSLog(@"blue background");
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

        
        [[ACAalarmData maindata].alarmList removeObjectIdenticalTo:[ACAalarmData maindata].sortedTimes[indexPath.row]];
        
        NSSortDescriptor *sortByDateAscending = [NSSortDescriptor sortDescriptorWithKey:@"NSDateNoDay" ascending:YES];
        NSMutableArray *descriptors = [[NSMutableArray  arrayWithObject:sortByDateAscending] mutableCopy];
        
        [ACAalarmData maindata].sortedTimes = [[[ACAalarmData maindata].alarmList sortedArrayUsingDescriptors:descriptors] mutableCopy];
        
        NSLog(@"sorted %d",[[ACAalarmData maindata].alarmList count]);
        NSLog(@"sorted %d",[[ACAalarmData maindata].sortedTimes count]);
      

        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
          NSLog(@"cell %d deleted", indexPath.row);
        
        //[self.tableView reloadData];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
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
