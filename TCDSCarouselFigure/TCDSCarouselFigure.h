/*
 
 
 
        *****************             ********              *********                   *****************
                *                 *             *           *           *               *               *
                *               *                 *         *              *            *
                *               *                           *               *           *
                *               *                           *               *           *
                *               *                           *               *           *
                *               *                           *               *           *****************
                *               *                           *               *                           *
                *               *                           *               *                           *
                *               *                           *               *                           *
                *               *                 *         *              *                            *
                *                 *             *           *           *               *               *
                *                     ********              *********                   *****************
 
 
 
 
 
                                                    天朝吊丝
*/


#import <UIKit/UIKit.h>

@class TCDSCarouselFigure;

@protocol TCDSCarouselFigureDelegate <NSObject>

@optional
    //轮播图滚动时调用的方法
-(void)carouseFigurePageValueDidChanged:(TCDSCarouselFigure *)carouseFigure;

@end

    //轮播图的数据源方式
typedef NS_ENUM(NSUInteger, TCDSCarouselFigureSourceType) {
    TCDSCarouselFigureSourceTypeURLS,
    TCDSCarouselFigureSourceTypeIMGS
};
    //拖动图片的方向
typedef NS_ENUM(NSUInteger, scrollDirection) {
    right,
    left
};




@interface TCDSCarouselFigure : UIView


    //代理
@property(nonatomic, strong)id<TCDSCarouselFigureDelegate>delegate;
    //存放图片的URL的数组，数据源为 TCDSCarouselFigureSourceTypeURLS 时起作用，图片会通过开辟多线程下载，保存在 NSUserDefault
@property(nonatomic, strong)NSMutableArray <NSString *> *urls;
    //存放图片的数组，数据源为 TCDSCarouselFigureSourceTypeIMGS 时起作用
@property(nonatomic, strong)NSMutableArray <UIImage *> *imgs;
    //自动滚动的时间间隔，默认为 1s，需要在开始滚动之前赋值，开始滚动后再设置无效。
@property(nonatomic, assign)NSInteger timeInterval;
    //轮播图上的PageControl，可设置其颜色，隐藏， CurrentPage 为当前图片在数组的位置   请不要设置 numberOfPages
@property(nonatomic, strong)UIPageControl *pageControl;


    //初始化方法，使用这种方式，数据源为图片网络链接，需要事先创建一个数组存放图片的 URL
-(instancetype)initWithImageURLs:(NSMutableArray <NSString *> *)urls frame:(CGRect )frame;
    //初始化方法，使用这种方式，数据源为 UIImage，需要事先创建一个数组存放 UIImage
-(instancetype)initWithImages:(NSMutableArray <UIImage *> *)imgs frame:(CGRect)frame;


    //开始滚动
-(void)startLoop;
    //结束滚动
-(void)stopLoop;

@end









