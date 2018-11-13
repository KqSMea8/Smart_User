//
//  TVWallInfo.h
//  Pods
//
//  Created by 28404 on 2017/8/22.
//
//

#import "DSSBaseInfo.h"

//屏幕模式
typedef NS_ENUM(NSInteger, TVWallScreenMode)
{
    TVWallScreenModeUnkown = 0,    //未知模式
    TVWallScreenModeSplit,         //分割模式
    TVWallScreenModeOpenWnd,       //开窗模式
};

//屏访问模式
typedef NS_ENUM(NSInteger, TVWallScreenVisitorMode)
{
    TVWallScreenVisitorModeUnkown = 0,    //未知模式
    TVWallScreenVisitorModeDirectConnect, //直连模式
    TVWallScreenVisitorModeForward,       //转发模式
};

//解码器类型
typedef NS_ENUM(NSInteger, TVWallDevType_e)
{
    TVWallDevTypeTVWallBegin   = 100,
    BASELINE_BIGSCREEN      = TVWallDevTypeTVWallBegin + 1,    //大屏
    TVWallDevTypeTVWallEnd,
    
    TVWallDevTypeDecBegin      = 200,
    BASELINE_DEC_NVD        = TVWallDevTypeDecBegin + 1,
    BASELINE_DEC_SNVD       = TVWallDevTypeDecBegin + 2,
    BASELINE_DEC_UDS        = TVWallDevTypeDecBegin + 3,
    TVWallDevTypeDecEnd,
    
    TVWallDevTypeMatrixBegin   = 300,
    BASELINE_MATRIX_M60     = TVWallDevTypeMatrixBegin + 1,
    BASELINE_MATRIX_NVR6000 = TVWallDevTypeMatrixBegin + 2,
    TVWallDevTypeMatrixEnd,
};

typedef NS_ENUM(NSInteger, TVWallScreenSplitCap) {
    TVWallScreenSplitCap_1 = 0,
    TVWallScreenSplitCap_4,
    TVWallScreenSplitCap_6,
    TVWallScreenSplitCap_8,
    TVWallScreenSplitCap_9,
    TVWallScreenSplitCap_16,
    TVWallScreenSplitCap_36,
    TVWallScreenSplitCap_64,
    ScreenSplitModeSplit_nm,
};

@interface TVWallOperResult : NSObject<NSCopying>
@property (nonatomic, assign)int  iSeq;
@property (nonatomic, assign)int  iRet;
@property (nonatomic, assign)BOOL bFlag;    //阻塞标记
@end

//tvwall begin
//电视墙基本信息
@interface TVWallInfo : NSObject
@property (nonatomic,assign) NSInteger iTVWallId;        //电视墙ID
@property (nonatomic,copy) NSString* strTVwallName;    //电视墙名称
@property (nonatomic,copy) NSString* strCode;          //code
@property (nonatomic,assign) NSInteger iState;           //电视墙启用状态
@property (nonatomic,assign) NSInteger iRight;           //权限
@property (nonatomic,assign) NSInteger iVersion;         //电视墙版本
@end


//电视墙任务基本信息
@interface TVWallTaskBaseInfo : NSObject <NSCopying>
@property (nonatomic,assign) NSInteger iTVWallId;       //电视墙ID
@property (nonatomic,assign) NSInteger iTaskId;         //任务ID
@property (nonatomic,copy) NSString* strTaskName;       //任务名称
@property (nonatomic,copy) NSString* strDesc;           //任务描述
@property (nonatomic,assign) BOOL bOnline;              //是否是即时上墙
@end

// 电视墙屏父类信息
@interface TVWallScreenBaseInfo : NSObject
@property (nonatomic, assign)NSInteger          iScreenId;                  // 屏ID（Web端配置的ID）
@property (nonatomic, copy)NSString*            strScreenName;              // 屏的名称
@property (nonatomic, assign)CGFloat            fLeft;                      // 屏幕左边距，百分比
@property (nonatomic, assign)CGFloat            fTop;                       // 屏幕上边距，百分比
@property (nonatomic, assign)CGFloat            fWidth;                     // 屏幕宽度，百分比
@property (nonatomic, assign)CGFloat            fHeigh;                     // 屏幕高度，百分比
@property (nonatomic, assign)BOOL               bIsScreenAlarmWall;         // 是否是报警联动屏
@property (nonatomic, copy)NSString*            strDecoderId;               // 解码器Id（融合屏的子屏只能绑定相同解码器的通道）
@property (nonatomic, assign)NSInteger          iUnit;                      // 解码器单元号
@property (nonatomic, assign)NSInteger          iSeq;                       // 解码器通道号
@end

// 电视墙屏信息（基本）
@interface TVWallScreenInfo : TVWallScreenBaseInfo
@property (nonatomic, assign)BOOL				bDecoderRight;				// 该通道是否有解码权限
@property (nonatomic, assign)BOOL               bDecoderOnline;             // 解码器是否在线
@property (nonatomic, assign)BOOL				bIsCombinedScreen;			// 是否是融合屏（xml中的type为1或3则为组合屏）
@property (nonatomic, assign)NSInteger			iBigScreenOut;				// 大屏控制器的输出端口号
@property (nonatomic, assign)BOOL               bScreenSwitchOn;            // 屏开关是否关闭YES:-开启 NO:-关闭
@property (nonatomic, strong)NSMutableArray<TVWallScreenBaseInfo *>* arrayCombinedScreenInfos; // 融合屏下的子屏
@end

// 窗体信息
@interface TVWallWindowInfo : NSObject
@property (nonatomic, assign)NSInteger			iId;						// 窗体ID，即1,2,3⋯⋯
@property (nonatomic, assign)CGFloat			fLeft;						// 窗口位置 左
@property (nonatomic, assign)CGFloat			fTop;						// 上
@property (nonatomic, assign)CGFloat			fWidth;						// 宽
@property (nonatomic, assign)CGFloat			fHeight;					// 高
@property (nonatomic, assign)NSInteger			iZorder;					// z序（画面分割可忽略此参数）
@property (nonatomic, copy)NSString*			strName;					// 窗标题（画面分割为""）
@property (nonatomic, assign)NSInteger			isAlarm;					// 报警上墙=1；客户端上墙=0
@property (nonatomic, assign)NSInteger			isHighLight;				// 高亮=1；非高亮=0；不处理=-1
@property (nonatomic, assign)NSInteger			isOpenAudio;				// 音频打开=1；0音频关闭；不处理=-1
@property (nonatomic, assign)BOOL               bIsTourOn;                  // 轮询是否开启：YES:开启 NO:关闭
@property (nonatomic, assign)BOOL               bIsTourEnable;              // 轮询使能：YES:可以使用 NO:不可使用
@end

// 窗口绑定视频信息
@interface TWWindowBandInfo : NSObject <NSCopying>
@property (nonatomic, copy)NSString     *strChannelId;  // 通道编号
@property (nonatomic, copy)NSString     *strChnlName;   // 通道名称
@property (nonatomic, copy)NSString     *strDeviceId;   // 设备ID
@property (nonatomic, assign)NSInteger	iChnlNo;        // 通道序号
@property (nonatomic, assign)NSInteger	iSubStream;     // 码流类型 主码流=1；辅码流=2；辅码流3=3；辅码流3=4；预览方式=5
@property (nonatomic, assign)NSInteger	iTimeSpan;      // 停留时间
@property (nonatomic, assign)NSInteger	iPrePoint;      // 预置点序号
@property (nonatomic, assign)NSInteger	iProvider;      // 设备厂商
@property (nonatomic, copy)NSString     *strOsdText;    // OSD信息
@property (nonatomic, assign)BOOL		bEnableOsd;     // OSD使能
@property (nonatomic, assign)NSInteger	iPatrolMode;    // 轮巡模式 轮巡=0；非轮巡上墙=1；轮巡预览=2；
@property (nonatomic, copy)NSString     *strDepartmentId;   // 通道所属组织结构的组织ID
@property (nonatomic, assign)NSInteger iFishFitMode;
@property (nonatomic, assign)NSInteger iFishShowMode;
@property (nonatomic, assign)NSInteger iTrackID;        // 取流方式501-PS包，601-原始帧，701-大华帧，801-大华标准帧，901-TS包，101(300以下)-RTP标准流
@end

// 上墙任务中屏详细信息，含屏的分割/开窗信息
@interface TVWallScreenDetailInfo : TVWallScreenBaseInfo
@property (nonatomic, assign)NSInteger                  iSplitNum;          // 屏分割/开窗数目
@property (nonatomic, assign)TVWallScreenMode           enumScreenMode;     // 分割=1；开窗=2
@property (nonatomic, assign)NSInteger                  iTvIndex;           // 解码通道

@property (nonatomic, strong)NSMutableDictionary<NSNumber*, TVWallWindowInfo*>* dictWindowInfo;            // 子屏信息<窗体ID，窗体信息>
@property (nonatomic, strong)NSMutableDictionary<NSNumber*, NSMutableArray<TWWindowBandInfo*>*>* dictWindowBandInfo;        // 窗口绑定视频信息
@end


//屏的能力集
@interface TVWallScreenCaps : NSObject
@property (nonatomic, assign)NSInteger			iScreenId;					//屏ID
@property (nonatomic, strong)NSMutableArray<NSNumber*>*    arraySplitCaps;				//分割能力集
@property (nonatomic, assign)NSInteger			iMaxSplitCaps;				//分割能力上限
@property (nonatomic, assign)NSInteger			iMaxWndCaps;				//开窗能力上限
@property (nonatomic, assign)TVWallScreenMode   enumScreenMode;				// 分割=1；开窗=2
@end


//电视墙计划中单个任务的信息
@interface TVWallProjectTaskInfo : NSObject
@property (nonatomic, assign)NSInteger			uTaskId;					// 任务ID
@property (nonatomic, assign)NSInteger			uBeginTime;					// 开始时间
@property (nonatomic, assign)NSInteger			uEndTime;					// 结束时间
@property (nonatomic, assign)NSInteger			uSpan;						// 停留时间
@end

typedef NS_ENUM(NSInteger, TVWallProjectType)
{
    TVWallProjectTypeTiming          = 0,		//定时计划
    TVWallProjectTypeRelativeTime    = 1,		//轮巡计划
};

//电视墙指定计划(包含的任务信息)
@interface TVWallProjectInfo : NSObject
@property (nonatomic,assign)    NSInteger           iTVWallId;      //电视墙ID
@property (nonatomic, copy)     NSString*			strProjName;	//计划名称
@property (nonatomic, assign)   TVWallProjectType	uType;			//计划类型
@property (nonatomic, strong)   NSMutableArray<TVWallProjectTaskInfo*>*     arrayTaskInfo;	//任务信息
@property (nonatomic, copy)     NSString            *strDecoderId;  // 解码器Id
@end

// 电视墙控制命令
typedef NS_ENUM(NSInteger, TVWallMatrixType)
{
    TVWallMatrixTypePlanTask					= 0,	// 任务上墙/任务切换
    TVWallMatrixTypeOneScreenShow				= 1,	// 绑定视频源
    TVWallMatrixTypeOneScreenClose              = 2,	// 取消视频源
    TVWallMatrixTypeScreenSplit                 = 3,	// 画面分割
    TVWallMatrixTypeWindowOpen                  = 4,	// 开窗
    TVWallMatrixTypeWindowClose                 = 5,	// 关窗
    TVWallMatrixTypeWindowMoving				= 6,	// 窗口移动
    TVWallMatrixTypeWindowTopShow               = 7,    // 置顶
    TVWallMatrixTypePowerCtrl                   = 8,    // 屏幕开关
    TVWallMatrixTypeOneScreenCloseAll			= 9,	// smartpss使用：关闭单屏(单屏的所有窗口)
    TVWallMatrixTypeProjectClosed               = 10,	// 关闭计划
    //9,  // 开启计划任务
    //10,  // 报警任务
    //11,  // 关闭计划任务
    TVWallMatrixTypeOneScreenCleared			= 12,	// 清理单屏,此时只需要对应的_tvIndex、_screenId、_tvType以及_tvWallDBId
    TVWallMatrixTypeWindowEnlarged              = 14,	// 分割单屏放大
    TVWallMatrixTypeTourPause					= 15,	// 上墙通道轮巡暂停，此时_screenId若为-1则对整个墙有效；_subTvIndex为-1则对整个屏有效（但_screenId必须是一个有效值）
    TVWallMatrixTypeTourResume                  = 16,	// 上墙通道轮巡恢复，同15
    TVWallMatrixTypeSingleWindowChangeSource	= 17,	// 单窗口切换视频源到前一个上墙，_screenId、_subTvIndex都必须有效
    TVWallMatrixTypeSingleWindowSoundSwitch     = 18,	// 单窗口音频开关控制, 此时只需要对应的_tvIndex、_screenId、_subTvIndex、_tvType以及_tvWallDBId，这里用splitNum表示开启（1）或者关闭（0）
};

//电视墙窗口上墙参数
@interface TVWallParam : NSObject
@property (nonatomic, assign)NSInteger   iWindowId;
@property (nonatomic, assign)NSInteger   iSplitNum;
@property (nonatomic, assign)NSInteger   iZOrder;
@property (nonatomic, assign)CGFloat     fLeft;
@property (nonatomic, assign)CGFloat     fTop;
@property (nonatomic, assign)CGFloat     fWidth;
@property (nonatomic, assign)CGFloat     fHeight;
@end

@interface TVWallMatirxInfo : NSObject
@property (nonatomic, assign)TVWallMatrixType eWallType;    //上墙类型，具体见TVWallMatrixType
@property (nonatomic, assign)NSInteger iTvWallId;			//电视墙ID
@property (nonatomic, copy)NSString*  strProjName;          //计划名称，dpsdk_tvwall_control_e为TVWALL_PLAN_TASK时有效
@property (nonatomic, assign)NSInteger iTaskId;				//任务ID，dpsdk_tvwall_control_e为TVWALL_PLAN_TASK时有效
@property (nonatomic, assign)NSInteger iTvWallVersion;      //电视墙版本号
@property (nonatomic, assign)NSInteger iScreenId;			//屏ID
@property (nonatomic, assign)NSInteger iTvType;             //屏类型：0-非融合屏，1-融合屏
@property (nonatomic, copy)NSString *strMatrixId;           //解码器id
@property (nonatomic, assign)NSInteger iSplitNum;           //画面分割数
@property (nonatomic, assign)NSInteger iTvIndex;            //如果是融合屏 和screenId一致,	非融合屏 传的是通道号
@property (nonatomic, assign)NSInteger iSubTvIndex;         //子屏号（融合屏有效）
@property (nonatomic, strong)NSMutableArray<TVWallParam*>*  arrayWindowParam;
@end

// 电视墙电源控制信息
@interface TWScreenSwitchInfo : NSObject
@property (nonatomic, copy)NSString* strDecoderId;          //解码器ID,解码器、矩阵等解码设备ID
@property (nonatomic, assign)NSInteger iScreenId;			//屏ID
@property (nonatomic, assign)BOOL bState;					//屏幕开关状态 true：开屏  false：关屏
@property (nonatomic, assign)NSInteger iTvWallId;            //电视墙ID
@end

@interface TWScreenAddFrame : NSObject
@property (nonatomic, copy)NSString* strDevID;				// 设备Id
@property (nonatomic, assign)NSInteger iTvWallId; 			// 电视墙Id
@property (nonatomic, assign)NSInteger iScreenId;			// 屏幕Id
@property (nonatomic, assign)NSInteger iSubWinId;			// 窗口Id
@property (nonatomic, assign)NSInteger iTvIndex;            // 如果是融合屏 和screenId一致,	非融合屏 传的是通道号
@property (nonatomic, assign)NSInteger iTvType;				// 0 非融合屏， 1 融合屏
@property (nonatomic, assign)BOOL bAddFrame;                // 是否加框使用false：不加，true：加
@end

//当前正在运行的类型
typedef NS_ENUM(NSInteger, TVWallCurWorkType){
    TWCurWorkTypeRunUnknown = -1,
    TWCurWorkTypeRunTask,
    TWCurWorkTypeRunProj
};

@interface TVWAllCurrentWorkInfo : NSObject
@property (nonatomic, assign)TVWallCurWorkType  workType;   // 运行的类型，任务or计划
@property (nonatomic, assign)NSInteger          iTvWallID;  // 电视墙ID
@property (nonatomic, assign)NSInteger          iTaskId;    // 任务ID workType为TWCurWorkTypeRunTask有效
@property (nonatomic, copy)  NSString*          strProjName;// 计划名 workType为TWCurWorkTypeRunProj有效
@property (nonatomic, assign)NSInteger          iProjectId; // 计划ID workType为TWCurWorkTypeRunProj有效
@end

