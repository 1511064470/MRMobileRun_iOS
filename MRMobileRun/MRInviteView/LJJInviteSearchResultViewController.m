//
//  LJJInviteSearchResultViewController.m
//  MRMobileRun
//
//  Created by J J on 2019/4/6.
//

#import "LJJInviteSearchResultViewController.h"
#import "LJJInviteSearchResultView.h"
#import "LJJInviteViewModel.h"
#import "LJJInviteSearchView.h"
#import "HttpClient.h"
#import "ZYLMainViewController.h"

@interface LJJInviteSearchResultViewController ()

@property (nonatomic,strong) LJJInviteSearchResultView *resultView;
@property (nonatomic,strong) NSUserDefaults *personData;
@property (nonatomic,strong) NSTimer *timer;
@end

@implementation LJJInviteSearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.777];
    self.view.backgroundColor = [UIColor colorWithRed:246/255.0 green:249/255.0 blue:250/255.0 alpha:1/1.0];
    _resultView = [[LJJInviteSearchResultView alloc] init];
    
    //邀约导航栏
    _resultView.imageNavigation = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav导航栏底"]];
    _resultView.imageNavigation.frame = CGRectMake(0, 0, screenWidth, screenHeigth * 0.0959502);
    [self.view addSubview:_resultView.imageNavigation];
    NSLog(@"导航栏界面");
    
    //邀约label
    if (screenHeigth > 800)
    {
        _resultView.labelInvite = [[UILabel alloc] initWithFrame:CGRectMake(0, screenHeigth * 0.04422, screenWidth, 45)];
    }
    else
    {
       _resultView.labelInvite = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, screenWidth, 45)];
    }
    
    _resultView.labelInvite.textAlignment = NSTextAlignmentCenter;
    _resultView.labelInvite.text = @"邀约";
    [self.view addSubview:_resultView.labelInvite];
    
    //返回按钮
    _resultView.back = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"返回箭头_黑"]];
    if (screenHeigth > 800)
    {
        _resultView.back.frame = CGRectMake(screenWidth * 0.058, screenHeigth * 0.06, screenWidth * 0.034444, screenWidth * 0.0493333);
    }
    else if (screenHeigth > 600 && screenHeigth < 800)
    {
        _resultView.back.frame = CGRectMake(screenWidth * 0.058, screenHeigth * 0.0455, screenWidth * 0.03, screenWidth * 0.06);
    }
    else if (screenHeigth < 600)
    {
        _resultView.back.frame = CGRectMake(screenWidth * 0.058, screenHeigth * 0.06, screenWidth * 0.03, screenWidth * 0.06);
    }
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backBtn)];
    _resultView.back.userInteractionEnabled = YES;
    [_resultView.back addGestureRecognizer:gesture];
    [self.view addSubview:_resultView.back];
    
    //搜索结果label
    _resultView.labelResult = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth * 0.06, screenHeigth * 0.1222, screenWidth * 0.5, screenHeigth * 0.03)];
    _resultView.labelResult.text = @"搜索结果";
    _resultView.labelResult.textColor = [UIColor grayColor];
    [self.view addSubview:_resultView.labelResult];
    // Do any additional setup after loading the view.
    
    //个人信息底板
    _resultView.cellImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"个人信息卡片底板"]];
    _resultView.cellImage.frame = CGRectMake(screenWidth * 0.012, screenHeigth * 0.1746626, screenWidth * 0.976, screenHeigth * 0.15);
    
    [self.view addSubview:_resultView.cellImage];
    
    
    //添加按钮
    _resultView.btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    [_resultView.btnAdd setImage:[UIImage imageNamed:@"添加icon"] forState:UIControlStateNormal];
    _resultView.btnAdd.frame = CGRectMake(screenWidth * 0.845, screenHeigth * 0.224887, screenWidth * 0.03866666, screenWidth * 0.03866666);
    [_resultView.btnAdd addTarget:self action:@selector(addPerson) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_resultView.btnAdd];
    
    //竖分割线
    _resultView.imageCut = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"竖分割线"]];
    _resultView.imageCut.frame = CGRectMake(screenWidth * 0.78, screenHeigth * 0.20914543, screenWidth * 0.001333, screenHeigth * 0.050974);
    [self.view addSubview:_resultView.imageCut];
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setLabelInformation)  name:@"information" object:nil];
}

- (void)setLabelInformation
{
    _personData = [NSUserDefaults standardUserDefaults];
    NSLog(@"hahaha学院 = %@",[_personData valueForKey:@"personCollege"]);
    NSLog(@"hahaha姓名 = %@",[_personData valueForKey:@"personNickname"]);
    NSLog(@"hahaha学号 = %@",[_personData valueForKey:@"personStuID"]);
    
    //昵称
    _resultView.labelName = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth * 0.123, screenHeigth * 0.20764618, screenWidth * 0.5, screenHeigth * 0.023)];
    _resultView.labelName.textColor = [UIColor darkGrayColor];
    _resultView.labelName.text = [_personData valueForKey:@"personNickname"];
    [self.view addSubview:_resultView.labelName];
    
    //学院
    _resultView.labelCollege = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth * 0.123, screenHeigth * 0.24333, screenWidth * 0.2573333, screenHeigth * 0.02473333)];
    _resultView.labelCollege.text = [_personData valueForKey:@"personCollege"];
    _resultView.labelCollege.textColor = [UIColor grayColor];
    
    [self.view addSubview:_resultView.labelCollege];
    
    //学号
    _resultView.labelStuID = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth * 0.5, screenHeigth * 0.24333, screenWidth * 0.2573333, screenHeigth * 0.02473333)];
    _resultView.labelStuID.textColor = [UIColor grayColor];
    _resultView.labelStuID.text = [_personData valueForKey:@"personStuID"];
    [self.view addSubview:_resultView.labelStuID];
    if (screenHeigth > 700)
    {
        _resultView.labelName.font = [UIFont systemFontOfSize:19];
        _resultView.labelCollege.font = [UIFont systemFontOfSize:16];
        _resultView.labelStuID.font = [UIFont systemFontOfSize:16];
    }
    else if (screenHeigth > 600 && screenHeigth < 700)
    {
        _resultView.labelName.font = [UIFont systemFontOfSize:16];
        _resultView.labelCollege.font = [UIFont systemFontOfSize:13];
        _resultView.labelStuID.font = [UIFont systemFontOfSize:13];
    }
    else if (screenHeigth < 600)
    {
        _resultView.labelName.font = [UIFont systemFontOfSize:14];
        _resultView.labelCollege.font = [UIFont systemFontOfSize:11];
        _resultView.labelStuID.font = [UIFont systemFontOfSize:11];
    }
}

- (void)addPerson
{
    _resultView.labelResult.text = @"已邀约";
    _resultView.labelStuID.frame = CGRectMake(screenWidth * 0.66, screenHeigth * 0.24333, screenWidth * 0.2573333, screenHeigth * 0.02473333);

    [_resultView.btnAdd setImage:[UIImage imageNamed:@"继续添加icon"] forState:UIControlStateNormal];
    _resultView.btnAdd.frame = CGRectMake(screenWidth * 0.877, screenHeigth * 0.1222, screenHeigth * 0.03, screenHeigth * 0.03);
    [_resultView.btnAdd addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [_resultView.imageCut removeFromSuperview];
    NSLog(@"按钮");
    
    //为cellImage添加手势
    UISwipeGestureRecognizer *left = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(LeftSwipe:)];
    left.direction = UISwipeGestureRecognizerDirectionLeft;
    _resultView.cellImage.userInteractionEnabled = YES;
    [_resultView.cellImage addGestureRecognizer:left];
    
    [self searchNetWork];
}

- (void)searchNetWork
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    HttpClient *client = [HttpClient defaultClient];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[_personData valueForKey:@"personStuID"] forKey:@"student_id"];
    [dic setObject:[NSString stringWithFormat:@"[%@]",[_personData valueForKey:@"personStuID"]] forKey:@"invitees"];
    NSDictionary *head = @{@"Content-Type":@"application/x-www-form-urlencoded",@"token":[user objectForKey:@"token"]};
    [client requestWithHead:kCommitRunTogetherInfo method:HttpRequestPost parameters:dic head:head prepareExecute:^{
        //
    } progress:^(NSProgress *progress) {
        //
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"发射成功");
        NSLog(@"%@",responseObject);
        
        //查询邀约是否成功
        [self judgeTheLastInviteOkOrNot];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"发射失败");
        NSLog(@"%@",error);
    }];
    
}

- (void)judgeTheLastInviteOkOrNot
{
    NSLog(@"查询最近一次邀约是否邀约成功");
    //被邀请人
    NSLog(@"%@",[_personData valueForKey:@"personStuID"]);
    
    //默认时间为7.77秒
    _timer = [NSTimer scheduledTimerWithTimeInterval:7.77 target:self selector:@selector(lastInviteNetWork) userInfo:nil repeats:YES];
}

- (void)lastInviteNetWork
{
    [_timer invalidate];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];

    HttpClient *client = [HttpClient defaultClient];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[_personData valueForKey:@"personStuID"] forKey:@"student_id"];
    NSDictionary *head = @{@"Content-Type":@"application/x-www-form-urlencoded",@"token":[user objectForKey:@"token"]};
    [client requestWithHead:kTheLastInviteOkOrNot method:HttpRequestGet parameters:dic head:head prepareExecute:^{
        //
    } progress:^(NSProgress *progress) {
        //
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        
        
        NSArray *array = [responseObject objectForKey:@"data"];
        NSString *string = [[array objectAtIndex:0] objectForKey:@"result"];
        NSString *copyStr = [NSString stringWithFormat:@"%@",string];
        if ([copyStr isEqualToString:@"1"])
        {
            NSLog(@"接受邀请");
            self.view.backgroundColor = [UIColor blackColor];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //NSLog(@"发射失败");
        NSLog(@"%@",error);
    }];
}

- (void)LeftSwipe:(UISwipeGestureRecognizer *)swipe
{
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        NSLog(@"左");
    }
}

- (void)backBtn
{
    [self removeChildVc:self];
    NSLog(@"back");
    ZYLMainViewController *mainVC = [[ZYLMainViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController: mainVC];
    [UIApplication sharedApplication].keyWindow.rootViewController = nav;
}

//移除当前VC
- (void)removeChildVc:(UIViewController *)vc
{
    [vc willMoveToParentViewController:nil];
    if (![vc isViewLoaded])
        [vc removeFromParentViewController];
    else
    {
        [vc.view removeFromSuperview];
        [vc removeFromParentViewController];
    }
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
