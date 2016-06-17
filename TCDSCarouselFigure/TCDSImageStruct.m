

#import "TCDSImageStruct.h"

@implementation TCDSImageStruct

-(instancetype)initWithImage:(UIImage *)image Before:(UIImage *)imageBef next:(UIImage *)imageNex {
    self = [super init];
    if (self) {
        self.before = imageBef;
        self.next = imageNex;
        self.current = image;
    }
    return self;
}


@end
