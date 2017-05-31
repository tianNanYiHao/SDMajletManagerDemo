//
//  SDMajletCellHead.m
//  SDMajletManagerDemo
//
//  Created by tianNanYiHao on 2017/5/31.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import "SDMajletCellHead.h"

static CGFloat margX = 15.0f;

@interface SDMajletCellHead (){
    
    UILabel *titleLab;
    UILabel *subTItleLab;
    
}

@end
@implementation SDMajletCellHead


-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self buidUI];
    }return self;
}



- (void)buidUI{
    
    CGFloat labWith = (self.bounds.size.width - 2*margX)/2;
    
    titleLab = [[UILabel alloc] init];
    titleLab.frame = CGRectMake(margX, 0, labWith, self.bounds.size.height);
    titleLab.textAlignment = NSTextAlignmentLeft;
    titleLab.textColor = [UIColor darkGrayColor];
    titleLab.font = [UIFont systemFontOfSize:13];
    [self addSubview:titleLab];
    
    subTItleLab = [[UILabel alloc] init];
    subTItleLab.frame = CGRectMake(margX+labWith, 0, labWith, self.bounds.size.height);
    subTItleLab.textAlignment = NSTextAlignmentRight;
    subTItleLab.textColor = [UIColor lightGrayColor];
    subTItleLab.font = [UIFont systemFontOfSize:11];
    [self addSubview:subTItleLab];
    
}

- (void)setTitle:(NSString *)title{
    _title = title;
    titleLab.text = _title;
    
}

- (void)setSubTitle:(NSString *)subTitle{
    
    _subTitle = subTitle;
    subTItleLab.text = _subTitle;
    
}

@end
