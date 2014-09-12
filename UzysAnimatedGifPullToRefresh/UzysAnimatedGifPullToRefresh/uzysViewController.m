//
//  uzysViewController.m
//  UzysAnimatedGifPullToRefresh
//
//  Created by Uzysjung on 2014. 4. 8..
//  Copyright (c) 2014년 Uzys. All rights reserved.
//
// Animated Gif Sources From
// https://dribbble.com/shots/1418440-Twisted-gif?list=searches&tag=animated_gif&offset=3
// https://dribbble.com/shots/1262399-The-End-gif?list=searches&tag=animated_gif&offset=51
// https://dribbble.com/shots/1421536-Cupido
// http://pixelbuddha.net/freebie/flat-preloaders

#import "uzysViewController.h"
#import "UIScrollView+UzysAnimatedGifPullToRefresh.h"
@interface uzysViewController ()<UITableViewDataSource,UITableViewDelegate>
//@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *pData;
@property (nonatomic,assign) BOOL isLoading;
@property (nonatomic,assign) BOOL useActivityIndicator;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
#define IS_IOS7 (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
#define CELLIDENTIFIER @"CELL"
@implementation uzysViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setupDataSource];
    if(IS_IOS7)
        self.automaticallyAdjustsScrollViewInsets = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"UzysAnimatedGifPullToRefresh";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CELLIDENTIFIER];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    __weak typeof(self) weakSelf =self;
    [self.tableView addPullToRefreshActionHandler:^{
        [weakSelf insertRowAtTop];
        
    } ProgressImagesGifName:@"spinner_dropbox@2x.gif" LoadingImagesGifName:@"run@2x.gif" ProgressScrollThreshold:70 LoadingImageFrameRate:30];
    if(IS_IOS7)
        [self.tableView addTopInsetInPortrait:64 TopInsetInLandscape:52];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark UITableView DataManagement
- (void)setupDataSource {
    self.pData = [NSMutableArray array];
    [self.pData addObject:@"0"];
    [self.pData addObject:@"1"];
    [self.pData addObject:@"2"];
    [self.pData addObject:@"3"];
    [self.pData addObject:@"4"];
    [self.pData addObject:@"5"];
    
    for(int i=0; i<20; i++)
        [self.pData addObject:[NSDate dateWithTimeIntervalSinceNow:-(i*100)]];
}

- (void)insertRowAtTop {
    __weak typeof(self) weakSelf = self;
    self.isLoading =YES;
    int64_t delayInSeconds = 2.2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    
        [weakSelf.tableView beginUpdates];
        [weakSelf.pData insertObject:[NSDate date] atIndex:0];
        [weakSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
        [weakSelf.tableView endUpdates];
        
        //Stop PullToRefresh Activity Animation
        [weakSelf.tableView stopRefreshAnimation];
        weakSelf.isLoading =NO;

    });
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.pData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CELLIDENTIFIER];
    
    if([[self.pData objectAtIndex:indexPath.row] isKindOfClass:[NSString class]] && [[self.pData objectAtIndex:indexPath.row] isEqualToString:@"0"])
    {
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.text = @"Progress Image by Array";
    }
    else if([[self.pData objectAtIndex:indexPath.row] isKindOfClass:[NSString class]] &&[[self.pData objectAtIndex:indexPath.row] isEqualToString:@"1"])
    {
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.text = @"DropBox";
    }
    else if([[self.pData objectAtIndex:indexPath.row] isKindOfClass:[NSString class]] &&[[self.pData objectAtIndex:indexPath.row] isEqualToString:@"2"])
    {
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.text = @"Cupido";
    }
    else if([[self.pData objectAtIndex:indexPath.row] isKindOfClass:[NSString class]] &&[[self.pData objectAtIndex:indexPath.row] isEqualToString:@"3"])
    {
        cell.textLabel.textColor = [UIColor blackColor];

        NSString *strLabel = [NSString stringWithFormat:@"Alpha Transition %@",self.tableView.showAlphaTransition ?@"ON":@"OFF"];
        cell.textLabel.text = strLabel;
    }
    else if([[self.pData objectAtIndex:indexPath.row] isKindOfClass:[NSString class]] &&[[self.pData objectAtIndex:indexPath.row] isEqualToString:@"4"])
    {
        cell.textLabel.textColor = [UIColor blackColor];
        
        NSString *strLabel = [NSString stringWithFormat:@"Variable Size %@",self.tableView.showVariableSize ?@"ON":@"OFF"];
        cell.textLabel.text = strLabel;
    }
    else if([[self.pData objectAtIndex:indexPath.row] isKindOfClass:[NSString class]] &&[[self.pData objectAtIndex:indexPath.row] isEqualToString:@"5"])
    {
        cell.textLabel.textColor = [UIColor blackColor];
        NSString *strLabel;
        if(self.useActivityIndicator)
        {
            NSArray *IndicatorStyle = @[@"WhiteLarge",@"White",@"Gray"];
            strLabel = [NSString stringWithFormat:@"Indcator Style %@",IndicatorStyle[self.tableView.activityIndcatorStyle]];
        }
        else
        {
            strLabel = @"UIActivityIndicator non-exist. (Tap \'Progress Image by Array\')";
        }
        cell.textLabel.text = strLabel;
    }
    else
    {
        NSDate *date = [self.pData objectAtIndex:indexPath.row];
        cell.textLabel.textColor = [UIColor grayColor];
        cell.textLabel.text = [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterMediumStyle];
    }
    
    cell.contentView.backgroundColor = [UIColor whiteColor];

    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.isLoading)
    {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    if([[self.pData objectAtIndex:indexPath.row] isKindOfClass:[NSString class]] && [[self.pData objectAtIndex:indexPath.row] isEqualToString:@"0"])
    {
        [self.tableView removePullToRefreshActionHandler];
        
        __weak typeof(self) weakSelf =self;
        
        NSMutableArray *progress =[NSMutableArray array];
        for (int i=0;i<83;i++)
        {
            NSString *fname = [NSString stringWithFormat:@"Preloader_9_%05d",i];
            [progress addObject:[UIImage imageNamed:fname]];
        }
        [self.tableView addPullToRefreshActionHandler:^{
            [weakSelf insertRowAtTop];

        } ProgressImages:progress ProgressScrollThreshold:60];
        self.useActivityIndicator = YES;
    }
    else if([[self.pData objectAtIndex:indexPath.row] isKindOfClass:[NSString class]] && [[self.pData objectAtIndex:indexPath.row] isEqualToString:@"1"])
    {
        [self.tableView removePullToRefreshActionHandler];
        
        __weak typeof(self) weakSelf =self;
        [self.tableView addPullToRefreshActionHandler:^{
            [weakSelf insertRowAtTop];

        } ProgressImagesGifName:@"spinner_dropbox@2x.gif" LoadingImagesGifName:@"run@2x.gif" ProgressScrollThreshold:60 LoadingImageFrameRate:30];
        self.useActivityIndicator = NO;

    }
    else if([[self.pData objectAtIndex:indexPath.row] isKindOfClass:[NSString class]] && [[self.pData objectAtIndex:indexPath.row] isEqualToString:@"2"])
    {
        [self.tableView removePullToRefreshActionHandler];
        
        __weak typeof(self) weakSelf =self;
        [self.tableView addPullToRefreshActionHandler:^{
            [weakSelf insertRowAtTop];
            
        } ProgressImagesGifName:@"cupido@2x.gif" LoadingImagesGifName:@"jgr@2x.gif" ProgressScrollThreshold:70];
        self.useActivityIndicator = NO;
    }
    else if([[self.pData objectAtIndex:indexPath.row] isKindOfClass:[NSString class]] && [[self.pData objectAtIndex:indexPath.row] isEqualToString:@"3"])
    {
        self.tableView.showAlphaTransition = !self.tableView.showAlphaTransition;
       
    }
    else if([[self.pData objectAtIndex:indexPath.row] isKindOfClass:[NSString class]] && [[self.pData objectAtIndex:indexPath.row] isEqualToString:@"4"])
    {
        self.tableView.showVariableSize = !self.tableView.showVariableSize;
    }
    else if([[self.pData objectAtIndex:indexPath.row] isKindOfClass:[NSString class]] && [[self.pData objectAtIndex:indexPath.row] isEqualToString:@"5"])
    {
        static NSInteger styleCnt =0;
        styleCnt++;
        if(styleCnt >2)
            styleCnt = 0;
        self.tableView.activityIndcatorStyle = styleCnt;
    }

    [self.tableView reloadData];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

@end
