//
//  LocationViewController.m
//  TestTask
//
//  Created by Roman on 5/26/15.
//  Copyright (c) 2015 Roman. All rights reserved.
//

#define METERS_PER_MILE 1609.344

#import "LocationViewController.h"
#import <MapKit/MapKit.h>

@interface LocationViewController ()<MKMapViewDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (nonatomic) MKPointAnnotation *annotation ;
@end

@implementation LocationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    HUDSHOW
    NSArray *users = [[DataManager manager] getAllUsersInfo];
    UserInfo *userInfo = [users objectAtIndex:self.indexCell];
    [self getDescriptionLocation:[userInfo.latitude doubleValue] :[userInfo.longitude doubleValue]];
}

- (void)zoomLocationMap:(double)latitudes :(double)longitudes
{
    
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = latitudes;
    zoomLocation.longitude= longitudes;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 500*METERS_PER_MILE, 500*METERS_PER_MILE);
    
    [_map setRegion:viewRegion animated:YES];
}

-(void) getDescriptionLocation :(double)latitudes : (double)longitudes
{
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:latitudes longitude:longitudes];
    [ceo reverseGeocodeLocation: loc completionHandler:
     ^(NSArray *placemarks, NSError *error) {
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         
         NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
         
         [self zoomLocationMap:latitudes :longitudes];
         CLLocationCoordinate2D zoomLocation;
         zoomLocation.latitude = latitudes;
         zoomLocation.longitude = longitudes;
         [self addPinToMap:locatedAt :latitudes :longitudes];
     }];
}

-(void) addPinToMap :(NSString*)title :(double)latitudes : (double)longitudes
{
    if(self.annotation)
        [_map removeAnnotation:self.annotation];
    
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = latitudes;
    zoomLocation.longitude = longitudes;
    
    self.annotation = [MKPointAnnotation new];
    self.annotation.title = title;
    self.annotation.coordinate = zoomLocation;
    [self.map addAnnotation:self.annotation];
    HUDHIDE
}

@end
