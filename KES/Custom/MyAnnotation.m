//
//  MyAnnotation.m


#import "MyAnnotation.h"

@implementation MyAnnotation

- (void)setTitle:(NSString *)title{
    _title = title;
}

- (void)setCoordinate:(float)latitude longitude:(float)longitude
{
    _coordinate.latitude = latitude;
    _coordinate.longitude = longitude;
}

@end
