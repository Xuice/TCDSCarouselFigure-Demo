

#import "TCDSImageNameStruct.h"

@implementation TCDSImageNameStruct

-(instancetype)initWithImageURL:(NSString *)image Before:(NSString *)imageBef next:(NSString *)imageNex {
    self = [super init];
    if (self) {
        self.before = imageBef;
        self.next = imageNex;
        self.current = image;
    }
    return self;
}

@end
