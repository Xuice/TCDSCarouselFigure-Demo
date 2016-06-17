

#import "TCDSCarouselFigure.h"
#import "TCDSImageNameStruct.h"
#import "TCDSImageStruct.h"

@interface TCDSCarouselFigure ()<UIScrollViewDelegate> {
    TCDSCarouselFigureSourceType _sourceType;       //图片的来源方式
    
    UIScrollView *_scrollView;                      //轮播图主要的ScrollView
    UIImageView *_leftIV;                           //左边的ImageView
    UIImageView *_centerIV;                         //中间的ImageView
    UIImageView *_rightIV;                          //右边的ImageView
    
    TCDSImageNameStruct *_centerImageURL;           //并不是结构体，里面三个变量用来指向当前，前面一张以及后面一张图片的URL下载链接
    TCDSImageStruct *_centerImage;                  //并不是结构体，里面三个变量用来指向当前，前面一张以及后面一张图片UIImage
    
    enum scrollDirection _direction;                //ScrollVIew滑动的方向
    CGFloat _flag;                                  //用来判断ScrollView滑动方向
    NSTimer *_timer;                                //用来循环的Timer
    BOOL _repeat;
}

@property(nonatomic, strong)void(^pageControlValueChanged)(void);

@end

@implementation TCDSCarouselFigure


#pragma mark 提供两种初始化方法
-(instancetype)initWithImageURLs:(NSMutableArray *)urls frame:(CGRect)frame {
    self = [super init];
    if (self) {
        self.frame = frame;
        self.urls = urls;
        self.timeInterval = 1;
        __weak typeof(self)weekSelf = self;
        self.pageControlValueChanged = ^ {
            if (weekSelf.delegate != nil && [weekSelf.delegate respondsToSelector:@selector(carouseFigurePageValueDidChanged:)]) {
                [weekSelf.delegate performSelector:@selector(carouseFigurePageValueDidChanged:)withObject:weekSelf];
            }
        };
        _sourceType = TCDSCarouselFigureSourceTypeURLS;
        
        [self loadScrollView];
        [self loadPageControl];
    }
    return self;
}
-(instancetype)initWithImages:(NSMutableArray *)imgs frame:(CGRect)frame {
    self = [super init];
    if (self) {
        self.frame = frame;
        self.imgs = imgs;
        self.timeInterval = 1;
        __weak typeof(self)weekSelf = self;
        self.pageControlValueChanged = ^ {
            if (weekSelf.delegate != nil && [weekSelf.delegate respondsToSelector:@selector(carouseFigurePageValueDidChanged:)]) {
                [weekSelf.delegate performSelector:@selector(carouseFigurePageValueDidChanged:)withObject:weekSelf];
            }
        };
        _sourceType = TCDSCarouselFigureSourceTypeIMGS;
        
        [self loadScrollView];
        [self loadPageControl];
    }
    return self;
}



#pragma mark 加载ScrollView和PageControl
-(void)loadScrollView {
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _scrollView.contentSize = CGSizeMake(self.frame.size.width * 3, self.frame.size.height);
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
    _flag = self.frame.size.width;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
    _leftIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [_scrollView addSubview:_leftIV];
    _centerIV = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
    [_scrollView addSubview:_centerIV];
    _rightIV = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width * 2, 0, self.frame.size.width, self.frame.size.height)];
    [_scrollView addSubview:_rightIV];
    
    if (_sourceType == TCDSCarouselFigureSourceTypeURLS) {
        if (_urls.count == 1) {
            _centerImageURL = [[TCDSImageNameStruct alloc]initWithImageURL:_urls[0] Before:_urls[0] next:_urls[0]];
        }
        else {
            _centerImageURL = [[TCDSImageNameStruct alloc]initWithImageURL:_urls[0] Before:_urls[_urls.count - 1] next:_urls[1]];
        }
    }
    else if (_sourceType == TCDSCarouselFigureSourceTypeIMGS) {
        if (_imgs.count == 1) {
            _centerImage = [[TCDSImageStruct alloc]initWithImage:_imgs[0] Before:_imgs[0] next:_imgs[0]];
        }
        else {
            _centerImage = [[TCDSImageStruct alloc]initWithImage:_imgs[0] Before:_imgs[_imgs.count - 1] next:_imgs[1]];
        }
    }
    [self loadImageWithCenterIndex:0];
}
-(void)loadPageControl {
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 30, self.frame.size.width, 40)];
    _pageControl.numberOfPages = _sourceType == TCDSCarouselFigureSourceTypeURLS ? _urls.count : _imgs.count;
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    [_pageControl addTarget:self action:@selector(pageControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    _pageControl.hidesForSinglePage = YES;
    [self addSubview:_pageControl];
}



#pragma mark 加载当前index的图片
-(void)loadImageWithCenterIndex:(NSInteger )index {
    if (_sourceType == TCDSCarouselFigureSourceTypeURLS) {
        _leftIV.image = [[UIImage alloc]init];
        _centerIV.image = [[UIImage alloc]init];
        _rightIV.image = [[UIImage alloc]init];
        //如果数据源是图片的URL
        if (_urls.count == 1) {
            [self setImageWithURL:_centerImageURL.before imageView:_leftIV];
            [self setImageWithURL:_centerImageURL.current imageView:_centerIV];
            [self setImageWithURL:_centerImageURL.next imageView:_rightIV];
            return;
        }
        if (index == 0) {
            _centerImageURL.before = self.urls[self.urls.count - 1];
            _centerImageURL.next = self.urls[index + 1];
            _centerImageURL.current = self.urls[index];
        }
        else if (index == self.urls.count - 1) {
            _centerImageURL.before = self.urls[index - 1];
            _centerImageURL.next = self.urls[0];
            _centerImageURL.current = self.urls[index];
        }
        else {
            _centerImageURL.before = self.urls[index - 1];
            _centerImageURL.next = self.urls[index + 1];
            _centerImageURL.current = self.urls[index];
        }
        [self setImageWithURL:_centerImageURL.before imageView:_leftIV];
        [self setImageWithURL:_centerImageURL.current imageView:_centerIV];
        [self setImageWithURL:_centerImageURL.next imageView:_rightIV];
    }
    else if (_sourceType == TCDSCarouselFigureSourceTypeIMGS) {
        //如果数据源是图片
        if (_urls.count == 1) {
            _leftIV.image = _centerImage.before;
            _centerIV.image = _centerImage.current;
            _rightIV.image = _centerImage.next;
            return;
        }
        if (index == 0) {
            _centerImage.before = self.imgs[self.imgs.count - 1];
            _centerImage.next = self.imgs[index + 1];
            _centerImage.current = self.imgs[index];
        }
        else if (index == self.imgs.count - 1) {
            _centerImage.before = self.imgs[index - 1];
            _centerImage.next = self.imgs[0];
            _centerImage.current = self.imgs[index];
        }
        else {
            _centerImage.before = self.imgs[index - 1];
            _centerImage.next = self.imgs[index + 1];
            _centerImage.current = self.imgs[index];
        }
        _leftIV.image = _centerImage.before;
        _centerIV.image = _centerImage.current;
        _rightIV.image = _centerImage.next;
    }
}



#pragma mark 滑动ScrollView以及点击PageControl小圆点
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x > _flag) {
        _direction = right;
    }
    else if (scrollView.contentOffset.y < _flag) {
        _direction = left;
    }
}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (_repeat) {
        [_timer invalidate];
        _timer = nil;
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (_repeat) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(loop) userInfo:nil repeats:YES];
    }
    if (scrollView.contentOffset.x == self.frame.size.width) {
        return;
    }
    if (_direction == right) {
        if (_pageControl.currentPage == (_sourceType == TCDSCarouselFigureSourceTypeURLS ? _urls.count - 1 : _imgs.count - 1)) {
            _pageControl.currentPage = 0;
        }
        else {
            _pageControl.currentPage += 1;
        }
    }
    else if (_direction == left) {
        if (_pageControl.currentPage == 0) {
            _pageControl.currentPage = (_sourceType == TCDSCarouselFigureSourceTypeURLS ? _urls.count - 1 : _imgs.count - 1);
        }
        else {
            _pageControl.currentPage -= 1;
        }
    }
    [self loadImageWithCenterIndex:_pageControl.currentPage];
    self.pageControlValueChanged();
    [_scrollView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
}
-(void)pageControlValueChanged:(UIPageControl *)pageControl {
    [self loadImageWithCenterIndex:_pageControl.currentPage];
    self.pageControlValueChanged();
}


#pragma mark 轮播图滚动和停止
-(void)startLoop {
    if (self.timeInterval > 0) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(loop) userInfo:nil repeats:YES];
        _repeat = YES;
    }
}
-(void)stopLoop {
    [_timer invalidate];
    _repeat = NO;
    _timer = nil;
}
-(void)loop {
    [self loadImageWithCenterIndex:_pageControl.currentPage < _pageControl.numberOfPages - 1 ? _pageControl.currentPage + 1 : 0];
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    if (_pageControl.currentPage == (_sourceType == TCDSCarouselFigureSourceTypeURLS ? _urls.count - 1 : _imgs.count - 1)) {
        _pageControl.currentPage = 0;
    }
    else {
        _pageControl.currentPage += 1;
    }
    
    [_scrollView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:YES];
    self.pageControlValueChanged();
}



#pragma mark 给ImageView设置图片 多线程 缓存
-(void)setImageWithURL:(NSString *)url imageView:(UIImageView *)imageView {
    __block NSData *data = [[NSUserDefaults standardUserDefaults]valueForKey:[NSString stringWithFormat:@"%@", url]];
    __block UIImage *image = [UIImage imageWithData:data];
    if (image) {
        imageView.image = image;
        return;
    }
    
    dispatch_queue_t queue = dispatch_queue_create("com.TCDS.image", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", url]]];
        image = [UIImage imageWithData:data];
        if (image == nil) {
            image = [UIImage imageNamed:@"bad.png"];
        }
        else {
            image = [UIImage imageWithData:data];
            [[NSUserDefaults standardUserDefaults]setObject:data forKey:[NSString stringWithFormat:@"%@", url]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            imageView.image = image;
        });
    });
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
