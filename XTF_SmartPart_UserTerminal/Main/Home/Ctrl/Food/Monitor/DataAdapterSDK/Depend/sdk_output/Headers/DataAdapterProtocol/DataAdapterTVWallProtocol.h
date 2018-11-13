//
//  DataAdapterTVWallProtocol.h
//  Pods
//
//  Created by 28404 on 2017/8/22.
//
//

#import <Foundation/Foundation.h>
#import "TVWallInfo.h"
#import "DataAdapterRemoteNotifyProtocol.h"

typedef void (^remoteNotifyBlock)(ADAPTER_NOTIFY_ACTION, id);

@protocol DataAdapterTVWallProtocol <NSObject>
/**
 设置远程消息通知block

 @return remoteNotifyBlock
 */
#pragma mark--register function to IDHModuleProtocol
- (void)setRemoteNotifyBlock:(void (^)(ADAPTER_NOTIFY_ACTION, id))remoteNotifyBlock;

/**
 获取电视墙列表

 @return NSArray<TVWallInfo *>
 */
#pragma mark--register function to IDHModuleProtocol
- (NSArray<TVWallInfo *> *)getTVWallList:(NSError **)error;


/**
 查询电视墙详细信息(XML字符串)
 
 @param tvWallId 电视墙id
 @param error 错误
 @return 电视墙详细信息(XML字符串)
 */
#pragma mark--register function to IDHModuleProtocol
- (NSString *)getTvWallInfo:(NSInteger)tvWallId error:(NSError **)error;


/**
 获取电视墙任务列表

 @param tvWallId 电视墙Id
 @param error 错误
 @return NSArray<TVWallTaskBaseInfo *>
 */
#pragma mark--register function to IDHModuleProtocol
- (NSArray<TVWallTaskBaseInfo *> *)getTVWallTaskList:(NSInteger)tvWallId error:(NSError **)error;


/**
 获取电视墙任务信息(XML字符串)

 @param taskId 任务id
 @param tvWallId 电视墙id
 @param error 错误
 @return 电视墙任务详细信息(XML字符串)
 */
#pragma mark--register function to IDHModuleProtocol
- (NSString *)getTvWallTaskInfo:(NSInteger)taskId tvWallId:(NSInteger)tvWallId error:(NSError **)error;


/**
 修改电视墙任务

 @param taskId 任务id
 @param tvWallId 电视墙id
 @param taskName 任务名
 @param taskDesciption 任务描述
 @param error 错误
 @return BOOl
 */
#pragma mark--register function to IDHModuleProtocol
- (BOOL)modifyTVWallTaskWithId:(NSInteger)taskId tvWallId:(NSInteger)tvWallId taskName:(NSString *)taskName taskDesciption:(NSString *)taskDesciption error:(NSError **)error;


/**
 删除电视墙任务

 @param taskId 任务id
 @param tvWallId 电视墙id
 @param error 错误
 @return BOOl
 */
#pragma mark--register function to IDHModuleProtocol
- (BOOL)deleteTVWallTaskWithId:(NSInteger)taskId tvWallId:(NSInteger)tvWallId error:(NSError **)error;


/**
 新增任务
 
 @param baseInfo 基本任务信息
 @param taskXmlString 任务xml字符串
 @param error 错误
 @return BOOL
 */
#pragma mark--register function to IDHModuleProtocol
- (BOOL)addTVWallTaskWithBaseInfo:(TVWallTaskBaseInfo *)baseInfo taskXmlString:(NSString *)taskXmlString error:(NSError **)error;


/**
 保存任务
 
 @param taskInfo 任务基本信息
 @param taskXmlString 任务xml字符串
 @param error 错误
 @return BOOL
 */
#pragma mark--register function to IDHModuleProtocol
- (BOOL)saveTask:(TVWallTaskBaseInfo *)taskInfo taskXmlString:(NSString *)taskXmlString error:(NSError **)error;

/**
 单屏上墙

 @param matirxInfo 上墙信息
 @param error 错误
 @return BOOL
 */
#pragma mark--register function to IDHModuleProtocol
- (BOOL)sendTaskToMatrix:(TVWallMatirxInfo *)matirxInfo error:(NSError **)error;

/**
 任务上墙

 @param matirxInfo 上墙信息
 @param taskXmlString 任务xml字符串
 @param error 错误
 @return BOOL
 */
#pragma mark--register function to IDHModuleProtocol
- (BOOL)taskMapToWall:(TVWallMatirxInfo *)matirxInfo taskXmlString:(NSString *)taskXmlString error:(NSError **)error;

/**
 任务上墙
 
 @param taskId 任务Id
 @param tvWallId 电视墙Id
 @param error 错误
 @return BOOL
 */
#pragma mark--register function to IDHModuleProtocol
- (BOOL)taskMapToWallWithTaskId:(NSInteger)taskId tvWallId:(NSInteger)tvWallId error:(NSError **)error;

/**
 绑定视频源

 @param matirxInfo 上墙信息
 @param taskXmlString 任务xml字符串
 @param error 错误
 @return BOOL
 */
#pragma mark--register function to IDHModuleProtocol
- (BOOL)bandVideoSource:(TVWallMatirxInfo *)matirxInfo taskXmlString:(NSString *)taskXmlString error:(NSError **)error;

/**
 屏幕电源控制

 @param switchInfo 电视墙电源控制信息
 @param error 错误
 @return BOOL
 */
#pragma mark--register function to IDHModuleProtocol
- (BOOL)powerControl:(TWScreenSwitchInfo *)switchInfo error:(NSError **)error;

/**
 根据电视墙Id获取电视墙计划列表xml字符串
 
 @param tvWallId 电视墙id
 @param error 错误
 @return 电视墙计划列表xml字符串
 */
#pragma mark--register function to IDHModuleProtocol
- (NSString *)getProjectListWithTVWallId:(NSInteger)tvWallId error:(NSError **)error;

/**
 修改轮巡计划

 @param projectInfo 轮巡计划信息
 @param projectXmlString 轮巡计划xml信息
 @return BOOL
 */
#pragma mark--register function to IDHModuleProtocol
- (BOOL)modifyCurrentWorkWithProjectInfo:(TVWallProjectInfo *)projectInfo projectXmlString:(NSString *)projectXmlString error:(NSError **)error;

/**
 删除轮巡计划
 
 @param projectInfo 轮巡计划信息
 @param projectXmlString 轮巡计划xml信息
 @param error 错误
 @return BOOL
 */
#pragma mark--register function to IDHModuleProtocol 
- (BOOL)deleteProjectWithProjectInfo:(TVWallProjectInfo *)projectInfo projectXmlString:(NSString *)projectXmlString error:(NSError **)error;

/**
 根据电视墙ID获取各个屏的能力集
 
 @param tvWallId 电视墙Id
 @param error 错误
 @return NSArray<TVWallScreenCaps>
 */
#pragma mark--register function to IDHModuleProtocol
- (NSArray<TVWallScreenCaps *> *)getScreenCapsWithTVWallID:(NSInteger)tvWallId error:(NSError **)error;

/**
 获取正在执行的计划
 
 @param error 错误
 @return NSMutableArray<TVWAllCurrentWorkInfo *> *
 */
#pragma mark--register function to IDHModuleProtocol
- (NSArray<TVWAllCurrentWorkInfo *> *)getCurrentWork:(NSError **)error;
@end
