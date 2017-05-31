//
//  TestCellCollectionViewCell.m
//  SDMajletManagerDemo
//
//  Created by tianNanYiHao on 2017/5/27.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import "SDMajletCell.h"

@interface SDMajletCell()
{
    UIImageView *iconImageView;
    UILabel *titleLab;
    CAShapeLayer *_borderLayer;
}
@end

@implementation SDMajletCell


-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self buidUI];
    }return self;
}


-(void)buidUI{
    
    self.layer.cornerRadius = 5.0f;
    self.layer.masksToBounds = YES;
    
    
    iconImageView = [[UIImageView alloc] init];
    [self addSubview:iconImageView];
    
    
    
    titleLab = [[UILabel alloc] init];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.textColor = [UIColor darkTextColor];
    [self addSubview:titleLab];
    
    
    
    [self addBorderLayer];
    
    
}

-(void)addBorderLayer{
    _borderLayer = [CAShapeLayer layer];
    _borderLayer.bounds = self.bounds;
    _borderLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    _borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:_borderLayer.bounds cornerRadius:self.layer.cornerRadius].CGPath;
    _borderLayer.lineWidth = 1.5f;
    _borderLayer.lineDashPattern = @[@5, @3];
    _borderLayer.fillColor = [UIColor clearColor].CGColor;
    _borderLayer.strokeColor = [UIColor colorWithRed:204/255.0f green:204/255.0f blue:204/255.0f alpha:1].CGColor;
    [self.layer addSublayer:_borderLayer];
    _borderLayer.hidden = true;
}




-(void) setFont:(CGFloat)font{
    _font = font;
    titleLab.font = [UIFont systemFontOfSize:_font];
}
-(void)setTitle:(NSString *)title{
    _title = title;
    titleLab.text = title;
}
-(void)setIconName:(NSString *)iconName{
    _iconName = iconName;
    
    UIImage *image = [UIImage imageNamed:_iconName];
    iconImageView.image = [UIImage imageNamed:_iconName];
    
    CGSize size = self.bounds.size;
    iconImageView.frame = CGRectMake(0, 0, image.size.width,image.size.height);
    iconImageView.center = CGPointMake(self.bounds.size.width/2, image.size.height/2);
    titleLab.frame = CGRectMake(0, iconImageView.frame.size.height, size.width, size.height-image.size.height);
    
}



-(void)setIsMoving:(BOOL)isMoving{
    _isMoving = isMoving;
    if (_isMoving) {
        titleLab.textColor = [UIColor lightGrayColor];
        iconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@Gray",_iconName]];
        _borderLayer.hidden = false;
    }else{
        titleLab.textColor = [UIColor darkTextColor];
        iconImageView.image = [UIImage imageNamed:_iconName];
        _borderLayer.hidden = true;
    }
    
}





@end
