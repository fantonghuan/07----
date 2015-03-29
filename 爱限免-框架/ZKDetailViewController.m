//
//  ZKDetailViewController.m
//  爱限免-框架
//
//  Created by cyan on 15-3-11.
//  Copyright (c) 2015年 cyan. All rights reserved.
//

#import "ZKDetailViewController.h"
#import "AppListModel.h"
#import "SnapShotModel.h"
#import "ZKimageView.h"

#import "UMSocial.h"

@interface ZKDetailViewController () <UIActionSheetDelegate>

@property (nonatomic, strong) UIScrollView *snapShotView;//截图视图
@property (nonatomic, strong) NSMutableArray *snapShots;//保存截图信息

@property (nonatomic, strong) UIScrollView *bottomView;//提示底部应用的滚动视图
@property (nonatomic, strong) NSMutableArray *bootomData;

@property (nonatomic, strong) UIImageView *leftView;


@end

@implementation ZKDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //1.设置上上部的UI
    [self setTopUI];
    //2.下载应用的截图
    [self downloadSnapShotImage];
    //3.设置下部的应用
    [self setBottomUI];
    //4.下载周围的应用
    _bootomData = [NSMutableArray array];
    [self downloadBottomApplicationList];
    
}

- (void)downloadBottomApplicationList {
    NSString *path = [NSString stringWithFormat:NEARBY_APP_URL,40.0209,116.2148];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        
//        NSLog(@"%@", string);
        
        //解析
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSArray *arr = dic[@"applications"];
        
        for (NSDictionary *dic in arr) {
            AppListModel *model = [AppListModel applistModelWithDic:dic];
            
            [_bootomData addObject:model];
            
            [self setNearByAPPScrollView];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"失败");
    }];
    
}

- (void)setNearByAPPScrollView {
    
    CGFloat w = 40;
    for (int i = 0; i < _bootomData.count; i++) {
        ZKimageView *imageView = [[ZKimageView alloc] initWithFrame:CGRectMake(10+i*(w+10), 0, w, w)];
        
        AppListModel *model = _bootomData[i];
        
        [imageView setImageWithURL:[NSURL URLWithString:model.iconUrl]];
        
        [_bottomView addSubview:imageView];
        
        imageView.clipsToBounds = YES;
        imageView.layer.cornerRadius = 10;
        imageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        imageView.model = model;
        [imageView addGestureRecognizer:tap];
        
        //底部题目
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10+i*(w+10), w, w, 15)];
        
        nameLabel.text = model.name;
        nameLabel.font = UIFONT10;
        
        [_bottomView addSubview:nameLabel];
    }
    
    _bottomView.contentSize = CGSizeMake(10+(w+10)*_bootomData.count, 0);
}

- (void)tapImageView:(UITapGestureRecognizer *)tap {
    ZKimageView *imageView = (ZKimageView *)tap.view;
    
    ZKDetailViewController *detail = [[ZKDetailViewController alloc] init];
    
    detail.detailModel = imageView.model;
    
    [self.navigationController pushViewController:detail animated:YES];
}


- (void)setBottomUI {
    UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(10, 64+280+5, 300, 80)];
    
    background.image = [UIImage imageNamed:@"appdetail_recommend"];
    
    background.userInteractionEnabled = YES;
    
    background.backgroundColor = [UIColor blueColor];
    
    [self.view addSubview:background];
    
    //创建滚动视图
    _bottomView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 15, 280, 55)];
    
    [background addSubview:_bottomView];
}

- (void)downloadSnapShotImage {
    
    //单独请求详情界面
    NSString *path = [NSString stringWithFormat:DETAIL_URL,[_detailModel.applicationId intValue]];
    AFHTTPRequestOperationManager *manager= [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        NSLog(@"%@", string);
        
        //解析
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSArray *array = dic[@"photos"];
        
        _snapShots = [NSMutableArray array];
        
        for (NSDictionary *dic in array) {
            SnapShotModel *model = [SnapShotModel modelWithDic:dic];
            
            [_snapShots addObject:model];
        }
        
        [self createSnapShotView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)createSnapShotView {
    
    CGFloat width = 80;
    for (int i = 0; i < _snapShots.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*(width+5), 0, width, 100)];
        
        SnapShotModel *model = _snapShots[i];
        [imageView setImageWithURL:[NSURL URLWithString:model.smallUrl]];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nextPage:)];
        
        [imageView addGestureRecognizer:tap];
        imageView.userInteractionEnabled = YES;
        
        [_snapShotView addSubview:imageView];
        
        imageView.tag = i+100;
    }
    
    //内容的尺寸
    _snapShotView.contentSize = CGSizeMake(width*_snapShots.count, 0);
}

- (void)nextPage:(UITapGestureRecognizer *)tap {
    
    UIImageView *imageView = (UIImageView *)tap.view;
    LookSnapShotViewController *look = [[LookSnapShotViewController alloc] init];
    
    look.snapShotModel = _snapShots[imageView.tag-100];
    
    [self.navigationController pushViewController:look animated:YES];
    
}

- (void)setTopUI {
    
    CGFloat leftGap = 10;
    CGFloat gap = 5;
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(leftGap, 64, 300, 280)];
    
    backgroundView.image = [UIImage imageNamed:@"appdetail_background"];
    backgroundView.userInteractionEnabled = YES;//允许用户交互
    [self.view addSubview:backgroundView];
    
    //左边图片
    _leftView = [[UIImageView alloc] initWithFrame:CGRectMake(leftGap, gap+5, 80, 80)];
    
    [_leftView setImageWithURL:[NSURL URLWithString:_detailModel.iconUrl]];
    
    _leftView.clipsToBounds = YES;
    _leftView.layer.cornerRadius = 10;
    
    [backgroundView addSubview:_leftView];
    
    //应用的名字
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_leftView.frame)+gap, gap+10, 200, 30)];
    
    nameLabel.text = _detailModel.name;
    nameLabel.font = UIBOLDFONT16;
    
    [backgroundView addSubview:nameLabel];
    
    //原价类型
    UILabel *normalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_leftView.frame)+gap, CGRectGetMaxY(nameLabel.frame), 120, 25)];
    
    normalPriceLabel.text = [NSString stringWithFormat:@"原价:￥%@ %@中", _detailModel.lastPrice,_proTitle];
    normalPriceLabel.font = UIFONT13;
    
    [backgroundView addSubview:normalPriceLabel];
    
    //类型
    UILabel *categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_leftView.frame)+gap, CGRectGetMaxY(normalPriceLabel.frame), 120, 25)];
    
    categoryLabel.text = [NSString stringWithFormat:@"类型:%@", _detailModel.categoryName];
    
    categoryLabel.font = UIFONT13;
    [backgroundView addSubview:categoryLabel];
    
    //软件大小
    UILabel *fileLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(normalPriceLabel.frame), CGRectGetMaxY(nameLabel.frame), 90, 25)];
    fileLabel.font = UIFONT13;
    fileLabel.text = [NSString stringWithFormat:@"%@ MB", _detailModel.fileSize];
    
    [backgroundView addSubview:fileLabel];
    
    //评分
    UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(normalPriceLabel.frame), CGRectGetMaxY(fileLabel.frame), 90, 25)];
    commentLabel.font = UIFONT13;
    commentLabel.text = [NSString stringWithFormat:@"评分:%@", _detailModel.starCurrent];
    
    [backgroundView addSubview:commentLabel];
    
    //三个按钮
    NSArray *titles = @[@"分享", @"收藏", @"下载"];
    NSArray *images = @[@"Detail_btn_left", @"Detail_btn_middle", @"Detail_btn_right"];
    
    for (int i = 0; i < titles.count; i++) {
        
        DataCenter *center = [DataCenter singleInstance];
        
        __block BOOL isCollect = [center selectAppListModel:self.detailModel andRecondType:RecondTypeWithCollection];
        
        ZKButton *btn = [ZKButton buttonWithFrame:CGRectMake(i*99, CGRectGetMaxY(_leftView.frame)+gap, 99, 40) type:UIButtonTypeCustom title:titles[i] backgroundImage:images[i] image:nil andBlock:^(ZKButton *button) {
            //功能
            
            if (0 == i) {
                //分享
                //1. 使用系统的方法
                UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"分享" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"新浪微博", @"微信好友", @"微信圈子", @"邮件", @"短信", nil];
                
                [sheet showInView:self.view];
                //2. 使用UM的API                // 第二种 直接加载的是友盟的view
                
                /**
                 弹出一个分享列表的类似iOS6的UIActivityViewController控件
                 
                 @param controller 在该controller弹出分享列表的UIActionSheet
                 @param appKey 友盟appKey
                 @param shareText  分享编辑页面的内嵌文字
                 @param shareImage 分享内嵌图片,用户可以在编辑页面删除
                 @param snsNames 你要分享到的sns平台类型，该NSArray值是`UMSocialSnsPlatformManager.h`定义的平台名的字符串常量，有UMShareToSina，UMShareToTencent，UMShareToRenren，UMShareToDouban，UMShareToQzone，UMShareToEmail，UMShareToSms等
                 @param delegate 实现分享完成后的回调对象，如果不关注分享完成的状态，可以设为nil
                 */
                
//                [UMSocialSnsService presentSnsIconSheetView:self appKey:@"507fcab25270157b37000010" shareText:[NSString stringWithFormat:@"应用 %@ 的详情是：%@",self.detailModel.name,self.detailModel.description] shareImage:_leftView.image shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToEmail,UMShareToSms,nil] delegate:nil];
                
            } else if (1 == i) {
                //收藏
                if (isCollect == NO) {
                    [button setTitle:@"取消收藏" forState:UIControlStateNormal];
                    
                    isCollect = YES;
                    
                    [center addApplistModel:_detailModel andRecondType:RecondTypeWithCollection];
                } else {
                    [button setTitle:@"收藏" forState:UIControlStateNormal];
                    
                    isCollect = NO;
                    
                    [center deleteApplistModel:_detailModel andRecondType:RecondTypeWithCollection];
                }
            } else {
                //下载
#pragma mark -- 下载
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_detailModel.itunesUrl]];
            }
            
        }];
        
        if (i == 1) {
            if (isCollect == YES) {
                [btn setTitle:@"取消收藏" forState:UIControlStateNormal];
            }
        }
        
        [backgroundView addSubview:btn];
    }
    
    //截图视图
    _snapShotView = [[UIScrollView alloc] initWithFrame:CGRectMake(leftGap, CGRectGetMaxY(_leftView.frame)+40, 280, 100)];
    
    _snapShotView.backgroundColor = [UIColor redColor];
    
    [backgroundView addSubview:_snapShotView];
    
    //详情
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftGap, CGRectGetMaxY(_snapShotView.frame), 280, 50)];
    detailLabel.numberOfLines = 0;
    detailLabel.font = UIFONT10;
    detailLabel.text = _detailModel.description;
    [backgroundView addSubview:detailLabel];
    
}

#pragma mark -- UIActionDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex < 5) {
        //定义分享的内容
        NSString *sharedText = @"祝大家都能找到10W/D的工作";
        
        //设置将分享的内容和代理对象
        [[UMSocialControllerService defaultControllerService] setShareText:sharedText shareImage:_leftView.image socialUIDelegate:nil];
        
        //定义分享平台
        NSArray *sharePlatform = @[UMShareToSina, UMShareToWechatSession, UMShareToWechatTimeline, UMShareToEmail, UMShareToSms];
        
        //选定当前的平台
        UMSocialSnsPlatform *platform = [UMSocialSnsPlatformManager getSocialPlatformWithName:sharePlatform[buttonIndex]];
        
        /**
         定义响应点击平台后的block对象
         
         @param presentingController 点击后弹出的分享页面或者授权页面所在的UIViewController对象
         @param socialControllerService 可以用此对象的socialControllerService.socialData可以获取分享内嵌文字、内嵌图片，分享次数等
         @param isPresentInController 如果YES代表弹出(present)到当前UIViewController，否则push到UIViewController的navigationController
         */
        
        platform.snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);

    } 

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
