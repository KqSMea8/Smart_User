//
//  EMapUIDataModel.h
//  Pods
//
//  Created by zf's on 2017/3/28.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

//地图类型 map type
typedef NS_ENUM(NSInteger,MapSDKType){
    MapSDKTypeBaidu = 1,  ///< baidu
    MapSDKTypeGoogle, ///< google
    MapSDKTypeGaode, ///< gaode
    MapSDKTypeRaster, ///< raster
};

//坐标系类型，由平台决定 Map Coordinate System
typedef NS_ENUM(NSInteger,MapCoordinateSystemType){
    MapCoordinateSystemTypeSuperMap = 1,  ///<SuperMap
    MapCoordinateSystemTypeGoogle, ///<Google
    MapCoordinateSystemTypeRaster, ///<Raster
    MapCoordinateSystemTypeBaidu  ///<Baidu
};
//Channel State Type
typedef NS_ENUM(NSInteger,ChannelStateType){
    CHANNEL_STATE_OFFLINE = 0,  					///< offline
    CHANNEL_STATE_ONLINE,                           ///< online
    CHANNEL_STATE_UNKNOW                            ///< unknow
};

//MapData Type
typedef NS_ENUM(NSInteger,MapDataType){
    MAPDATA_COMMON = 0,  					///< Common
    MAPDATA_GPS                             ///< GPS
};

/// 设备详情模型 EMap Detail Model
@interface DSSEMapDetailModel :NSObject
/// 资产编号 property Number
@property (nonatomic, copy) NSString *propertyNum;
/// 资产厂商 property Manufacturer
@property (nonatomic, copy) NSString *propertyManufacturer;
/// 资产类型 property Type
@property (nonatomic, assign) NSString *propertyType;
/// 资产型号 property Model
@property (nonatomic, copy) NSString *propertyModel;
/// 所属组织 belonging
@property (nonatomic, copy) NSString *belonging;
/// 监控类别 monitor Category
@property (nonatomic, copy) NSString *monitorCategory;

@end

/// EMap DataModel
@interface DSSEMapUIDataModel : NSObject

/// 通道id channelId
@property (nonatomic, copy) NSString *channelId;
/// 设备详情模型 EMap Detail Model
@property (nonatomic, strong) DSSEMapDetailModel *detail;
/// 地理位置 location
@property (nonatomic, assign) CLLocationCoordinate2D location;
/// 通道名称 channel Name
@property (nonatomic, copy) NSString *channelName;
/// 通道名称 device Name
@property (nonatomic, copy) NSString *deviceName;
/// 地址 channel Address
@property (nonatomic, copy) NSString *channelAddress;
/// 状态（是否在线) channel Status
@property (nonatomic, assign) ChannelStateType channelState;
/// 是否有地理信息 has location Info
@property (nonatomic, assign) BOOL hasLocation;
/// 所属光栅图ID raster id
@property (nonatomic, strong) NSNumber *mapId;
/// 状态（是否在线） mapdata Type
@property (nonatomic, assign) MapDataType mapdataType;

@end

/// EMap Raster DataModel
@interface DSSEMapUIRasterDataModel : NSObject
@property (nonatomic,copy) NSString     *name;
@property (nonatomic,strong) NSNumber   *markerID;
@property (nonatomic,strong) NSNumber   *parentID;
@property (nonatomic,copy) NSString     *imagePath;
@property (nonatomic,assign) CGFloat    mapX;
@property (nonatomic,assign) CGFloat    mapY;
@property (nonatomic,strong) NSMutableArray<DSSEMapUIRasterDataModel *> *childHotZones;

///+ (EMapUIRasterDataModel *)getRootRasterDataModelWithArray:(NSArray *)array;
//////返回值表示当前Raster节点是否依然存在
///- (BOOL)loadChildRasterWithArray:(NSArray *)array;
///- (EMapUIRasterDataModel *)getFatherRasterWithArray:(NSArray *)array;
@end

///@interface EMapUIGPSDeviceModel : NSObject
///@property (nonatomic,copy) NSString     *deviceName;
///@property (nonatomic,strong) NSNumber   *markerID;
///@property (nonatomic,strong) NSNumber   *parentID;
///@property (nonatomic,copy) NSString     *imagePath;
////// 地理位置
///@property (nonatomic, assign) CLLocationCoordinate2D location;
///
///@end


