//
//  MapViewController.h
//  KES
//
//  Created by matata on 2/23/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "WebServices.h"
#import "MyAnnotation.h"
#import "AppDelegate.h"

@interface MapViewController : UIViewController<MKMapViewDelegate, CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    float m_latitude;
    float m_langitude;
}
@property (nonatomic, strong) NSString *locationId;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UITextView *dirctionsToBuildingTxt;
@property (weak, nonatomic) IBOutlet UITextView *directionsToRoomTxt;
@property (weak, nonatomic) IBOutlet UILabel *directionsToRoomLbl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)OnCloseClicked:(id)sender;
@end
