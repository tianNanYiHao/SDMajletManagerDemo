//
//  SDMajletView.m
//  SDMajletManagerDemo
//
//  Created by tianNanYiHao on 2017/5/26.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import "SDMajletView.h"
#import "SDMajletCell.h"
#import "SDMajletCellHead.h"

#define ViewSize self.bounds
static CGFloat margSpaceX = 10.0f;  //cell间距x
static CGFloat margSpaceY = 8.0f;  //cell间距y
static CGFloat columnNumber = 4.0f;// cell 列数


@interface SDMajletView()<UICollectionViewDelegate,UICollectionViewDataSource>{
    
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) SDMajletCell *dragingCell;  //被拖动的(瓷砖)cell(item)
@property (nonatomic, strong) NSIndexPath *dragingFromindexPath; //被拖动的cell的indexPaht
@property (nonatomic, strong) NSIndexPath *dragingToindexPaht;   //目标cell的indexPaht


@end

@implementation SDMajletView




/**
 初始化

 @param frame frame
 @return SDMajletView实例
 */
- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
    
}



- (void)createUI{
#pragma mark - 创建collectionView
    //flowLayout布局
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat spaceCount = columnNumber + 1 ; //(间隙count永远比列数多1)
    CGFloat cellWith = (self.bounds.size.width - spaceCount*margSpaceX)/columnNumber;
    //cell size
    UIImage *iconImag = [UIImage imageNamed:@"more"];
    //布局item大小
    flowLayout.itemSize = CGSizeMake(cellWith, iconImag.size.height*2);
    //布局边距
    flowLayout.sectionInset = UIEdgeInsetsMake(margSpaceY, margSpaceX, margSpaceY, margSpaceX);
    //布局最小行间距
    flowLayout.minimumLineSpacing = margSpaceY;
    //布局最小列间距
    flowLayout.minimumInteritemSpacing = margSpaceX;
    //布局头部viewSize
    flowLayout.headerReferenceSize = CGSizeMake(ViewSize.size.width, 44);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:ViewSize collectionViewLayout:flowLayout];
    _collectionView.showsHorizontalScrollIndicator = YES;
    _collectionView.backgroundColor = [UIColor whiteColor];
    //复用ID必须和代理中的ID一致
    [_collectionView registerClass:[SDMajletCell class] forCellWithReuseIdentifier:@"SDMajletCell"];
    //注册头部视图
    [_collectionView registerClass:[SDMajletCellHead class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SDMajletCellHead"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self addSubview:_collectionView];
    
#pragma mark - 创建一个单独的(瓷砖)cell用于跟随手势拖动
    _dragingCell = [[SDMajletCell alloc] initWithFrame:CGRectMake(0, 0, flowLayout.itemSize.width, flowLayout.itemSize.height)];
    _dragingCell.hidden = YES;
    [self addSubview:_dragingCell];
    
    
#pragma mark - 创建长按拖动手势
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressMethod:)];
    longPressGesture.minimumPressDuration = 0.3f;
    [_collectionView addGestureRecognizer:longPressGesture];
    
    
    
}
#pragma mark - 长按手势方法
-(void)longPressMethod:(UILongPressGestureRecognizer*)gesture{
    
    //1 获取手势触发点Point
    CGPoint point = [gesture locationInView:_collectionView];
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            [self dragBegin:point];
        }
            break;
            
        case UIGestureRecognizerStateChanged:
        {
            [self dragChange:point];
        }
            break;
          
        case UIGestureRecognizerStateEnded:
        {
            [self dragEnd:point];
        }
            break;
            
        default:
            break;
    }
    
    
}
#pragma mark - 开始拖动
-(void)dragBegin:(CGPoint)point{
    //获取拖动的cell的indexPaht
    _dragingFromindexPath = [self getDragingFromIndexPathWithPoint:point];
    
    if (!_dragingFromindexPath) {
        return;
    }
    //把被拖动cell拿到最上层
    [_collectionView bringSubviewToFront:_dragingCell];
    
    //拿到被拖动的真正cell 更新样式
    SDMajletCell *cell = (SDMajletCell*)[_collectionView cellForItemAtIndexPath:_dragingFromindexPath];
    cell.isMoving = YES;
    
    //更新拖动(瓷砖)的cell样式
    _dragingCell.frame = cell.frame;
    _dragingCell.title = cell.title;
    _dragingCell.iconName = cell.iconName;
    _dragingCell.hidden = NO;
    _dragingCell.transform = CGAffineTransformMakeScale(1.2, 1.2);
    
}

#pragma mark - 拖动中...
-(void)dragChange:(CGPoint)point{
    if (!_dragingFromindexPath) {
        return;
    }
    //让被拖动的cell 更随手势移动
    _dragingCell.center = point;
    
    //获取目标cell的indexPaht
    _dragingToindexPaht = [self getDragingToIndexPathWithPoint:point];
    
    //交换位置,如果目标indexPath找不到则不交换
    if (_dragingFromindexPath && _dragingToindexPaht) {
        //先更新数据源
        [self uplogadInusesTitles];
        //在交换位置(UI层面)
        [_collectionView moveItemAtIndexPath:_dragingFromindexPath toIndexPath:_dragingToindexPaht];
        _dragingFromindexPath = _dragingToindexPaht;
       
    }
}

#pragma mark - 结束拖动
-(void)dragEnd:(CGPoint)point{
    if (!_dragingFromindexPath) {
        return;
    }
    CGRect newFrame = [_collectionView cellForItemAtIndexPath:_dragingFromindexPath].frame;
    _dragingCell.transform = CGAffineTransformMakeScale(1.0, 1.0);
    [UIView animateWithDuration:0.3f animations:^{
        //跟新拖动cell的样式
        _dragingCell.frame = newFrame;
    } completion:^(BOOL finished) {
        _dragingCell.hidden = YES;
        
        //拿到被拖动的真正cell 更新样式
        SDMajletCell *cell = (SDMajletCell*)[_collectionView cellForItemAtIndexPath:_dragingFromindexPath];
        cell.isMoving = NO;
        
        
    }];
}

//找出被拖动的cell的indexPath
- (NSIndexPath*)getDragingFromIndexPathWithPoint:(CGPoint)point{
    NSIndexPath *indexPahtTemp = nil;
    
    //获取当前可见cell的indexPaht组
    NSArray *indexPahtArr = [_collectionView indexPathsForVisibleItems];
    for (NSIndexPath *indexPath in indexPahtArr) {
        //下半部分不用排序
        if (indexPath.section >0) {
            continue;
        }
        //上半部分中 找出点所在的indexPath
        BOOL isContains = CGRectContainsPoint([_collectionView cellForItemAtIndexPath:indexPath].frame, point);
        if (isContains == YES) {
            indexPahtTemp = indexPath;
            break;
        }
    }
    return indexPahtTemp;
}


//找出目标cell的indexPath
-(NSIndexPath*)getDragingToIndexPathWithPoint:(CGPoint)point{
    NSIndexPath *indexPahtTemp = nil;
    //获取当前可见cell的indexPaht组
    NSArray *indexPahtArr = [_collectionView indexPathsForVisibleItems];
    for (NSIndexPath *indexPath in indexPahtArr) {
        //如果是自己,则不需要排序
        if (indexPath == _dragingFromindexPath) {
            continue;
        }
        //下半部分不用排序
        if (indexPath.section >0) {
            continue;
        }
        //上半部分中 找出点所在的indexPath
        BOOL isContains = CGRectContainsPoint([_collectionView cellForItemAtIndexPath:indexPath].frame, point);
        if (isContains == YES) {
            indexPahtTemp = indexPath;
            break;
        }
    }
    return indexPahtTemp;
}





#pragma mark - collectionViewDelegate/DataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return section ==0 ? _inUseTitles.count:_unUseTitles.count;
}


-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    static NSString *headID = @"SDMajletCellHead";
    SDMajletCellHead *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headID forIndexPath:indexPath];
    if (indexPath.section == 0) {
        headView.title = @"我的应用";
        headView.subTitle = @"长按并拖拽调整";
    }else{
        headView.title = @"未选择的应用";
        headView.subTitle = @"点击添加或删除应用";
    }
    return headView;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"SDMajletCell";
    SDMajletCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.font = 13;
    cell.iconName = indexPath.section == 0? [_inUseTitles[indexPath.row] objectForKey:@"iconName"]: [_unUseTitles[indexPath.row] objectForKey:@"iconName"];
    cell.title = indexPath.section == 0? [_inUseTitles[indexPath.row] objectForKey:@"title"] : [_unUseTitles[indexPath.row] objectForKey:@"title"];
    
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        //只剩一个的时候不可删除
        if ([_collectionView numberOfItemsInSection:0] == 1)
        {
            return;
        }
        id obj = [_inUseTitles objectAtIndex:indexPath.row];
        [_inUseTitles removeObject:obj];
        [_unUseTitles insertObject:obj atIndex:0];
        [_collectionView moveItemAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        
    }else{
        id obj = [_unUseTitles objectAtIndex:indexPath.row];
        [_unUseTitles removeObject:obj];
        [_inUseTitles addObject:obj];
        [_collectionView moveItemAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForRow:_inUseTitles.count-1 inSection:0]];
    }
    
}

#pragma mark - 交换数组中的数据
-(void)uplogadInusesTitles{
    
    id obj = [_inUseTitles objectAtIndex:_dragingFromindexPath.row];
    [_inUseTitles removeObject:obj];
    [_inUseTitles insertObject:obj atIndex:_dragingToindexPaht.row];
    
}



/**
 回调方法返回上下数组
 
 @param block 代码块
 */
-(void)callBacktitlesBlock:(SDMajletBlock)block{
    
    _block = block;
    
    _block(_inUseTitles,_unUseTitles);
    
}



@end
