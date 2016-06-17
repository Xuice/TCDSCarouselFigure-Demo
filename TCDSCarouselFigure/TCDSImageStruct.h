

#import <UIKit/UIKit.h>

@interface TCDSImageStruct : NSObject

@property(nonatomic, strong)UIImage *before;
@property(nonatomic, strong)UIImage *next;
@property(nonatomic, strong)UIImage *current;


-(instancetype)initWithImage:(UIImage *)image Before:(UIImage *)imageBef next:(UIImage *)imageNex;


@end
