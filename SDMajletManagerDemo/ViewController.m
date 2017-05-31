//
//  ViewController.m
//  SDMajletManagerDemo
//
//  Created by tianNanYiHao on 2017/5/26.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import "ViewController.h"
#import "SDMajletView.h"

@interface ViewController ()
{
    SDMajletView *v;
}
@end

@implementation ViewController
- (IBAction)updata:(id)sender {
    [v callBacktitlesBlock:^(NSMutableArray *inusesTitles, NSMutableArray *unusesTitles) {
        
        NSLog(@"%@",inusesTitles);
        NSLog(@"%@",unusesTitles);
        
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
     v = [[SDMajletView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64)];
    
                NSArray *arrInuses = @[@{@"iconName":@"zhuanzhang",@"title":@"及时转账"},
                                       @{@"iconName":@"shouji",@"title":@"手机充值"},
                                       @{@"iconName":@"youka",@"title":@"油卡充值"},
                                       @{@"iconName":@"dianziquan",@"title":@"电子券"},
                                       @{@"iconName":@"kepiao",@"title":@"长途客票"},
                                       @{@"iconName":@"qiangsheng",@"title":@"强生叫车"},
                                       @{@"iconName":@"shangcheng",@"title":@"掌上商城"}
                                       ];
    v.inUseTitles = [NSMutableArray arrayWithArray:arrInuses];
                NSArray *arrUnuses = @[
                                       @{@"iconName":@"game",@"title":@"游戏中心"},
                                       @{@"iconName":@"jd",@"title":@"京东特卖"},
                                       @{@"iconName":@"life",@"title":@"生活缴费"},
                                       @{@"iconName":@"shanghu",@"title":@"商户通"}
                                       ];
    v.unUseTitles = [NSMutableArray arrayWithArray:arrUnuses];
    

    
    [self.view addSubview:v];
    

}



@end
