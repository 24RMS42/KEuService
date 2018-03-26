//
//  MyAnnotation.h


#import <Foundation/Foundation.h>

#import <MapKit/MapKit.h>

@interface MyAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *title;

- (void)setTitle:(NSString *)title;
- (void)setCoordinate:(float)latitude longitude:(float)longitude;
@end
