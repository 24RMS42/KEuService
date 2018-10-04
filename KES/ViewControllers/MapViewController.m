//
//  MapViewController.m
//  KES
//
//  Created by matata on 2/23/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setMap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setMap {
    
    self.mapView.showsUserLocation = YES;
    CGFloat lat = 53.472517;
    CGFloat lng = -8.268276;
    
    for (LocationModel *roomObj in appDelegate.locationArray) {
        if ([roomObj.location_id isEqualToString:_locationId]) {
            lat = roomObj.lat;
            lng = roomObj.lng;
            
            for (LocationModel *buildingObj in appDelegate.locationArray) {
                if ([buildingObj.location_id isEqualToString:roomObj.parent_id]) {
                    _titleLbl.text = [NSString stringWithFormat:@"Directions to %@ %@", buildingObj.name, roomObj.name];
                    
                    NSAttributedString *roomAttributedString = [[NSAttributedString alloc]
                                                                   initWithData: [roomObj.directions dataUsingEncoding:NSUnicodeStringEncoding]
                                                                   options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                                   documentAttributes: nil
                                                                   error: nil
                                                                   ];
                    NSAttributedString *buildingAttributedString = [[NSAttributedString alloc]
                                                                  initWithData: [buildingObj.directions dataUsingEncoding:NSUnicodeStringEncoding]
                                                                  options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                                  documentAttributes: nil
                                                                  error: nil
                                                                  ];
                    
                    _directionsToRoomTxt.attributedText = roomAttributedString;
                    _dirctionsToBuildingTxt.attributedText = buildingAttributedString;
                    [_directionsToRoomTxt setFont:[UIFont fontWithName:@"Roboto-Light" size:16]];
                    [_dirctionsToBuildingTxt setFont:[UIFont fontWithName:@"Roboto-Light" size:16]];
                    [_directionsToRoomTxt sizeToFit];
                    [_dirctionsToBuildingTxt sizeToFit];
                    _directionsToRoomTxt.scrollEnabled = NO;
                    _dirctionsToBuildingTxt.scrollEnabled = NO;
                    
                    CGRect detailLblFrame = _directionsToRoomLbl.frame;
                    detailLblFrame.origin.y = _dirctionsToBuildingTxt.frame.origin.y + _dirctionsToBuildingTxt.frame.size.height + 10;
                    _directionsToRoomLbl.frame = detailLblFrame;
                    
                    CGRect detailTxtFrame = _directionsToRoomTxt.frame;
                    detailTxtFrame.origin.y = _directionsToRoomLbl.frame.origin.y + _directionsToRoomLbl.frame.size.height + 1;
                    _directionsToRoomTxt.frame = detailTxtFrame;
                    
                    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, _directionsToRoomTxt.frame.origin.y + _directionsToRoomTxt.frame.size.height + 64);
                    
                    break;
                }
            }
        }
    }
    
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude =   lat;
    zoomLocation.longitude =  lng;
    
//    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 1.5*METERS_PER_MILE, 1.5*METERS_PER_MILE);
//    [_mapView setRegion:viewRegion animated:YES];
    
    //for make marker
    MyAnnotation *annotation = [[MyAnnotation alloc] init];
    [annotation setCoordinate:lat longitude:lng];
    [annotation setTitle:@"Kilmartin Education Services"];
    [_mapView addAnnotation:annotation];
    
    [self setLocationPreference];
    [locationManager startUpdatingLocation];
}

-(void)setLocationPreference
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = 10; //kCLDistanceFilterNone; // whenever we move
    
    if (![CLLocationManager locationServicesEnabled])
    {
        UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled" message:@"You currently have all location services for this device disabled. If you proceed, you will be asked to confirm whether location services should be reenabled." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [servicesDisabledAlert show];
    }
    
    if(IS_OS_8_OR_LATER) {
        NSUInteger code = [CLLocationManager authorizationStatus];
        if (code == kCLAuthorizationStatusNotDetermined && ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)] || [locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])) {
            // choose one request according to your business.
            if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"]){
                [locationManager requestAlwaysAuthorization];
            } else if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]) {
                [locationManager  requestWhenInUseAuthorization];
            } else {
                NSLog(@"Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription");
            }
        }
    }
}

-(void)showUserLocation {
    CLLocationCoordinate2D Location;
    
    Location.latitude = m_latitude;
    Location.longitude = m_langitude;
    
    MKCoordinateRegion viewRegion ;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.051160989179241;
    span.longitudeDelta= 0.051613839235492;
    viewRegion.center = Location;
    viewRegion.span = span;
    
    [self.mapView setRegion:viewRegion animated:YES];
}

#pragma mark - MapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    NSLog(@"name:%@", annotation.title);
    MKAnnotationView * pinView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotation.title];
    if ([annotation.title isEqualToString:@"My Location"]) {
        return pinView;
    }
    
    if (!pinView) {
        pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                               reuseIdentifier:annotation.title];
        UIImage *image = [UIImage imageNamed:@"map_pin.png"];
        
        pinView.image = image;
        pinView.canShowCallout = YES;
    }
    else {
        pinView.annotation = annotation;
    }
    return pinView;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    currentLocation = [locations objectAtIndex:0];
    [locationManager stopUpdatingLocation];
    
    NSLog(@"my latitude :%f",currentLocation.coordinate.latitude);
    NSLog(@"my longitude :%f",currentLocation.coordinate.longitude);
    
    m_langitude = currentLocation.coordinate.longitude;
    m_latitude =  currentLocation.coordinate.latitude;
    
    [self showUserLocation];
}

- (IBAction)OnCloseClicked:(id)sender {
    //[self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
