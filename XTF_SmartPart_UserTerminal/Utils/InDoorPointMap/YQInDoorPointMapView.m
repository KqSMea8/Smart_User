//
//  YQInDoorPointMapView.m
//  ZHYQ
//
//  Created by 焦平 on 2017/11/15.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "YQInDoorPointMapView.h"
//#import "InDoorWifiModel.h"
//#import "InDoorMonitorMapModel.h"
//#import "InDoorBgMusicMapModel.h"
//#import "ParkLightModel.h"
//#import "AirConditionModel.h"
#import "DownParkMdel.h"
#import "OpenDoorModel.h"

#define scal 0.2

@interface YQInDoorPointMapView ()
{
    
}
@end

@implementation YQInDoorPointMapView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(id)initWithIndoorMapImageName:(NSString*)indoorMap Frame:(CGRect)frame;
{
    if (self=[super init]) {
        
        self.bounces = NO;
        self.delegate = self;
        self.backgroundColor = [UIColor whiteColor];
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.frame = frame;
        
        UIImage *map = [UIImage imageNamed:indoorMap];
        _mapView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, map.size.width, map.size.height)];
        _mapView.contentMode = UIViewContentModeScaleAspectFit;
        _mapView.backgroundColor = [UIColor clearColor];
        _mapView.image = map;
        _mapView.userInteractionEnabled = YES;
        [self addSubview:_mapView];
        
        //双击
        UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDoubleTap:)];
        [doubleTapGesture setNumberOfTapsRequired:2];
        [_mapView addGestureRecognizer:doubleTapGesture];
        
        CGFloat minScale = self.frame.size.width/_mapView.frame.size.width;
        [self setMinimumZoomScale:minScale];
        [self setZoomScale:minScale];
        
        CGFloat newScale = self.zoomScale*2.5;
        CGRect zoonRect = [self zoomRectForScale:newScale withCenter:CGPointMake(map.size.width/2, map.size.height/2)];
        [self zoomToRect:zoonRect animated:NO];
        
    }
    return self;
}

- (SmallMapView *)smallMapView {
    if(_smallMapView == nil){
        // 小地图视图
        _smallMapView = [SmallMapView new];
        _smallMapView.backgroundColor = [UIColor redColor];
        //        _smallMapView.touchMoveDelegate = self;
        _smallMapView = [_smallMapView initWithUIScrollView:self frame:CGRectMake(0, self.bottom - self.height * scal, self.width * scal, self.height * scal)];
    }
    return _smallMapView;
}

- (void)setIsMinScaleWithHeight:(BOOL)isMinScaleWithHeight {
    _isMinScaleWithHeight = isMinScaleWithHeight;
    
    if(isMinScaleWithHeight){
        CGFloat minScale = self.frame.size.height/_mapView.image.size.height;
        [self setMinimumZoomScale:minScale];
        [self setZoomScale:minScale];
    }
}

#pragma ScrollView 协议
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(!_smallMapView.isTouchMove){
        [_smallMapView scrollViewDidScroll:scrollView];
    }
}

- (void)setGraphData:(NSArray *)graphData {
    _graphData = graphData;
    
    [graphData enumerateObjectsUsingBlock:^(NSString *graphStr, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *pointAry = [graphStr componentsSeparatedByString:@","];
        if(pointAry == nil || pointAry.count < 2){
            return ;
        }
        NSString *x = pointAry[0];
        NSString *y = pointAry[1];
        
        UIImageView *videoImgView;
        if(_isLayCoord){
            videoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(x.floatValue, y.floatValue, 50, 50)];
        }else {
            // 楼层图高度
            if(_mapView.image != nil){
                CGFloat imgHeight = _mapView.image.size.height;
                videoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(x.floatValue, imgHeight - y.floatValue, 50, 50)];
            }
        }
        
        //        UIImageView *videoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(x.floatValue/2.4f, y.floatValue/2.4f, 20, 20)];
        //        videoImgView.image = [UIImage imageNamed:@"wifi_normal"];
        videoImgView.tag = 100+idx;
        videoImgView.userInteractionEnabled = YES;
        [_mapView addSubview:videoImgView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [videoImgView addGestureRecognizer:tap];
    }];
}

/*
-(void)setWifiModelArr:(NSMutableArray *)wifiModelArr
{
    _wifiModelArr = wifiModelArr;
    [wifiModelArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imageView = [_mapView viewWithTag:100+idx];
        imageView.contentMode = UIViewContentModeScaleToFill;
        InDoorWifiModel *model = (InDoorWifiModel *)obj;
        if ([model.WIFI_STATUS isEqualToString:@"1"]||[model.WIFI_STATUS isEqualToString:@"2"]) {
            imageView.image = [UIImage imageNamed:@"wifi_normal"];
        }else{
            imageView.image = [UIImage imageNamed:@"wifi_error"];
        }
    }];
}

-(void)setCameraModelArr:(NSMutableArray *)cameraModelArr
{
    _cameraModelArr = cameraModelArr;
    [cameraModelArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imageView = [_mapView viewWithTag:100+idx];
        imageView.contentMode = UIViewContentModeScaleToFill;
        InDoorMonitorMapModel *model = (InDoorMonitorMapModel *)obj;
        if ([model.CAMERA_STATUS isEqualToString:@"1"]||[model.CAMERA_STATUS isEqualToString:@"2"]) {
            if ([model.DEVICE_TYPE isEqualToString:@"1-1"]) {
                imageView.image = [UIImage imageNamed:@"map_gunshot_icon_normal"];
            }else if ([model.DEVICE_TYPE isEqualToString:@"1-2"])
            {
                imageView.image = [UIImage imageNamed:@"map_ball_icon_normal"];
            }else{
                imageView.image = [UIImage imageNamed:@"map_halfball_icon_normal"];
            }
        }else{
            if ([model.DEVICE_TYPE isEqualToString:@"1-1"]) {
                imageView.image = [UIImage imageNamed:@"map_gunshot_icon_error"];
            }else if ([model.DEVICE_TYPE isEqualToString:@"1-2"])
            {
                imageView.image = [UIImage imageNamed:@"map_ball_icon_error"];
            }else{
                imageView.image = [UIImage imageNamed:@"map_halfball_icon_error"];
            }
        }
    }];
}

-(void)setBgMusicArr:(NSMutableArray *)bgMusicArr
{
    _bgMusicArr = bgMusicArr;
    [bgMusicArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imageView = [_mapView viewWithTag:100+idx];
        imageView.contentMode = UIViewContentModeScaleToFill;
        InDoorBgMusicMapModel *model = (InDoorBgMusicMapModel *)obj;
        if ([model.MUSIC_STATUS isEqualToString:@"1"]||[model.MUSIC_STATUS isEqualToString:@"2"]) {
            imageView.image = [UIImage imageNamed:@"map_music_icon_normal"];
        }else{
            imageView.image = [UIImage imageNamed:@"map_music_icon_error"];
        }
    }];
}

-(void)setParkLightArr:(NSMutableArray *)parkLightArr
{
    _parkLightArr = parkLightArr;
    [parkLightArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imageView = [_mapView viewWithTag:100+idx];
        imageView.contentMode = UIViewContentModeScaleToFill;
        ParkLightModel *model = (ParkLightModel *)obj;
        if ([model.EQUIP_STATUS isEqualToString:@"1"]) {
            imageView.image = [UIImage imageNamed:@"park_light_normal"];
        }else{
            imageView.image = [UIImage imageNamed:@"park_light_error"];
        }

    }];
}

-(void)setAirConArr:(NSMutableArray *)airConArr
{
    _airConArr = airConArr;
    
    [airConArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imageView = [_mapView viewWithTag:100+idx];
        imageView.contentMode = UIViewContentModeScaleToFill;
        AirConditionModel *model = (AirConditionModel *)obj;
        if ([model.EQUIP_STATUS isEqualToString:@"1"]) {
            imageView.image = [UIImage imageNamed:@"mapairconditionnormal"];
        }else{
            imageView.image = [UIImage imageNamed:@"mapairconditionerror"];
        }
        
    }];
}
 */

-(void)setDoorArr:(NSMutableArray *)doorArr{
    _doorArr = doorArr;
    [_doorArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imageView = [_mapView viewWithTag:100+idx];
        imageView.contentMode = UIViewContentModeScaleToFill;
        OpenDoorModel *model = (OpenDoorModel *)obj;
        if ([[model.hasAuth stringValue] isEqualToString:@"1"]) {
            if ([model.DEVICE_TYPE isEqualToString:@"4-1"]) {
                imageView.image = [UIImage imageNamed:@""];
            }else{
                imageView.image = [UIImage imageNamed:@"door_normal"];
            }
        }else{
            if ([model.DEVICE_TYPE isEqualToString:@"4-1"]) {
                imageView.image = [UIImage imageNamed:@""];
            }else{
                imageView.image = [UIImage imageNamed:@"door_unable"];
            }
        }
    }];
}

-(void)setParkDownArr:(NSMutableArray *)parkDownArr
{
    _parkDownArr = parkDownArr;
    
    [parkDownArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imageView = [_mapView viewWithTag:100+idx];
        imageView.contentMode = UIViewContentModeScaleToFill;
        DownParkMdel *model = (DownParkMdel *)obj;
        if([model.seatFx isEqualToString:@"1"]){
            imageView.image = [UIImage imageNamed:@"red_hor"];
            imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, 40, 100);
        }else if([model.seatFx isEqualToString:@"2"]) {
            imageView.image = [UIImage imageNamed:@"red_ver"];
            imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, 100, 40);
        }
    }];
}
// 修改车库点位图图标
- (void)updateCarIcon:(DownParkMdel *)downParkMdel withIndex:(NSInteger)index {
    UIImageView *imageView = [_mapView viewWithTag:100+index];
    if([downParkMdel.seatFx isEqualToString:@"1"]){
        imageView.image = [UIImage imageNamed:@"sel_red_hor"];   // 搜索后的图标
        imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, 40, 100);
    }else if([downParkMdel.seatFx isEqualToString:@"2"]) {
        imageView.image = [UIImage imageNamed:@"sel_red_ver"];   // 搜索后的图标
        imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, 100, 40);
    }
}
- (void)normalCarIcon:(DownParkMdel *)downParkMdel withIndex:(NSInteger)index {
    UIImageView *imageView = [_mapView viewWithTag:100+index];
    if([downParkMdel.seatFx isEqualToString:@"1"]){
        imageView.image = [UIImage imageNamed:@"red_hor"];
        imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, 40, 100);
    }else if([downParkMdel.seatFx isEqualToString:@"2"]) {
        imageView.image = [UIImage imageNamed:@"red_ver"];
        imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, 100, 40);
    }
}

-(void)tapAction:(id)sender
{
    if (self.selInMapDelegate) {
        UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
        [self.selInMapDelegate selInMapWithId:[NSString stringWithFormat:@"%ld",tap.view.tag]];
    }
}

#pragma mark - Zoom methods
-(void)handleDoubleTap:(UIGestureRecognizer*)gesture
{
    CGFloat newScale = self.zoomScale*1.5;
    CGRect zoonRect = [self zoomRectForScale:newScale withCenter:[gesture locationInView:gesture.view]];
    [self zoomToRect:zoonRect animated:YES];
}

-(CGRect)zoomRectForScale:(CGFloat)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height = self.frame.size.height / scale;
    zoomRect.size.width = self.frame.size.width /scale;
    zoomRect.origin.x = center.x -(zoomRect.size.width/2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height/2.0);
    return zoomRect;
}

#pragma mark - UIScrollViewDelegate

-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    
    return _mapView;
}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    [scrollView setZoomScale:scale animated:NO];
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    _mapView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                  scrollView.contentSize.height * 0.5 + offsetY);
    
}

#pragma mark -UITouch
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    CGPoint touchPoint  = [[touches anyObject] locationInView:_mapView];
    NSValue *touchValue = [NSValue valueWithCGPoint:touchPoint];
    [self performSelector:@selector(performTouchTestArea:)
               withObject:touchValue
               afterDelay:0.1];
}

- (void)performTouchTestArea:(NSValue *)inTouchPoint
{
    CGPoint aTouchPoint = [inTouchPoint CGPointValue];
    
    if(_graphData != nil && _graphData.count > 0){
        [_graphData enumerateObjectsUsingBlock:^(NSString *graphStr, NSUInteger idx, BOOL * _Nonnull stop) {
            [YQIndoorMapTransfer initWithCoordinate:graphStr InPoint:aTouchPoint Inview:_mapView WithIdentity:[NSString stringWithFormat:@"%ld",idx] delegate:self];
        }];
    }
    /*
     [SKIndoorMapTransfer initWithCoordinate:@"173,451,173,559,299,563,300,590,316,592,321,628,687,632,689,334,581,335,580,447,536,448,535,465,333,464,330,448" InPoint:aTouchPoint Inview:_mapView WithTitle:@"GAP" delegate:self];
     
     [SKIndoorMapTransfer initWithCoordinate:@"922,445,921,629,1013,628,1051,598,1049,448" InPoint:aTouchPoint Inview:_mapView WithTitle:@"优视一品" delegate:self];
     [SKIndoorMapTransfer initWithCoordinate:@"1081,444,1078,598,1177,597,1215,532,1276,485,1275,444" InPoint:aTouchPoint Inview:_mapView WithTitle:@"Samanth a Thavasa" delegate:self];
     
     [SKIndoorMapTransfer initWithCoordinate:@"1289,444,1290,484,1371,466,1451,485,1455,444,1369,421" InPoint:aTouchPoint Inview:_mapView WithTitle:@"SWATCH" delegate:self];
     
     [SKIndoorMapTransfer initWithCoordinate:@"1466,446,1467,485,1513,525,1562,595,1822,593,1818,573,1855,573,1854,443" InPoint:aTouchPoint Inview:_mapView WithTitle:@"Izzue" delegate:self];
     
     [SKIndoorMapTransfer initWithCoordinate:@"1823,632,1823,751,1866,746,1867,630" InPoint:aTouchPoint Inview:_mapView WithTitle:@"西城旅游局" delegate:self];
     
     [SKIndoorMapTransfer initWithCoordinate:@"231,810,229,917,420,915,420,801" InPoint:aTouchPoint Inview:_mapView WithTitle:@"Fred Perry" delegate:self];
     
     [SKIndoorMapTransfer initWithCoordinate:@"420,915,420,801,580,795,580,917" InPoint:aTouchPoint Inview:_mapView WithTitle:@"CAMPER" delegate:self];
     
     [SKIndoorMapTransfer initWithCoordinate:@"64,1051,61,1652,333,1648,331,1421,451,1420,451,1500,577,1500,521,1437,498,1375,489,1292,497,1219,526,1147,580,1078,578,1048" InPoint:aTouchPoint Inview:_mapView WithTitle:@"ZARA" delegate:self];
     
     
     [SKIndoorMapTransfer initWithCoordinate:@"680,792,813,786,813,975,680,973" InPoint:aTouchPoint Inview:_mapView WithTitle:@"MAX&CO." delegate:self];
     [SKIndoorMapTransfer initWithCoordinate:@"917,981,680,973,679,1076,749,1173,916,1173" InPoint:aTouchPoint Inview:_mapView WithTitle:@"LOVE MOSCHINO" delegate:self];
     
     [SKIndoorMapTransfer initWithCoordinate:@"917,981,916,1173,995,1126,1052,1126,1050,982" InPoint:aTouchPoint Inview:_mapView WithTitle:@"Tissot" delegate:self];
     
     [SKIndoorMapTransfer initWithCoordinate:@"815,786,815,919,919,923,918,783" InPoint:aTouchPoint Inview:_mapView WithTitle:@"Minnetonk" delegate:self];
     
     [SKIndoorMapTransfer initWithCoordinate:@"918,783,919,877,1036,776,1037,876" InPoint:aTouchPoint Inview:_mapView WithTitle:@"TENDENCE" delegate:self];
     [SKIndoorMapTransfer initWithCoordinate:@"1036,776,1179,769,1210,819,1202,1102,1185,1130,1052,1127,1037,876" InPoint:aTouchPoint Inview:_mapView WithTitle:@"SEPHORA" delegate:self];
     
     [SKIndoorMapTransfer initWithCoordinate:@"1293,808,1438,808,1437,849,1294,850" InPoint:aTouchPoint Inview:_mapView WithTitle:@"手表维修 " delegate:self];
     
     
     [SKIndoorMapTransfer initWithCoordinate:@"1554,799,1585,779,1807,780,1806,932,1559,933" InPoint:aTouchPoint Inview:_mapView WithTitle:@"SWAROVSKI" delegate:self];
     
     
     [SKIndoorMapTransfer initWithCoordinate:@"1559,933,1806,932,1805,1047,1560,1043" InPoint:aTouchPoint Inview:_mapView WithTitle:@"Juicy Couture" delegate:self];
     
     
     [SKIndoorMapTransfer initWithCoordinate:@"1560,1043,1805,1047,1804,1163,1559,1160" InPoint:aTouchPoint Inview:_mapView WithTitle:@"DKNY" delegate:self];
     [SKIndoorMapTransfer initWithCoordinate:@"1574,1199,1572,1406,1454,1412,1458,1582,1540,1590,1544,1701,1964,1705,1955,1287,1950,1197" InPoint:aTouchPoint Inview:_mapView WithTitle:@"H&M" delegate:self];
     
     [SKIndoorMapTransfer initWithCoordinate:@"1068,1308,1066,1430,932,1426" InPoint:aTouchPoint Inview:_mapView WithTitle:@"JurLique" delegate:self];
     
     [SKIndoorMapTransfer initWithCoordinate:@"764,1285,906,1284,906,1425,922,1429,924,1544,795,1544,795,1479,728,1474,726,1444" InPoint:aTouchPoint Inview:_mapView WithTitle:@"GUESS" delegate:self];
     
     [SKIndoorMapTransfer initWithCoordinate:@"229,917,580,914,579,1046,232,1047" InPoint:aTouchPoint Inview:_mapView WithTitle:@"CK" delegate:self];
     */
    
}

- (void)selPopWithIdentity:(NSString *)identity {
//    NSLog(@"%@", identity);
    if(self.selInMapDelegate){
        [self.selInMapDelegate selInMapWithId:identity];
    }
}

@end
