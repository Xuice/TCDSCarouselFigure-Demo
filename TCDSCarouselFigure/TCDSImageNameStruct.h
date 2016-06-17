

#import <UIKit/UIKit.h>

@interface TCDSImageNameStruct : NSObject

@property(nonatomic, strong)NSString *before;
@property(nonatomic, strong)NSString *next;
@property(nonatomic, strong)NSString *current;


-(instancetype)initWithImageURL:(NSString *)image Before:(NSString *)imageBef next:(NSString *)imageNex;

@end
