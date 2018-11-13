//
//  IFLYPopView.m
//  XTF_SmartPart_UserTerminal
//
//  Created by coder on 2018/9/10.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "IFLYPopView.h"
#import <iflyMSC/iflyMSC.h>
#import "ISRDataHelper.h"
#import "IFLYPopTableViewCell.h"
#import "RippleAnimationView.h"
#import "YSCNewVoiceWaveView.h"
#import <AVFoundation/AVFoundation.h>
#import "TTSConfig.h"

@interface IFLYPopView()<IFlySpeechRecognizerDelegate,IFlySpeechSynthesizerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UIView *viewFooter;
    CGFloat footerHeight;
    CGFloat index;
}

@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) NSTimer *updateVolumeTimer;
@property (nonatomic,assign) IFLYPopType type;
@property (nonatomic,strong) UIView *contentView;
//不带界面的识别对象
@property (nonatomic, strong) IFlySpeechRecognizer *iFlySpeechRecognizer;
//语音合成对象
@property (nonatomic, strong) IFlySpeechSynthesizer *iFlySpeechSynthesizer;

@property (nonatomic,copy) NSString *resultStringFromJson;

@property (nonatomic,retain) UITableView *tableView;
@property (nonatomic,retain) NSMutableArray *dataArr;
@property (nonatomic,strong) NSMutableArray *indesPaths;
@property (nonatomic,assign) int DatNum;

@property (nonatomic,retain) UIImageView *centerView;
@property (nonatomic,retain) RippleAnimationView *viewA;
//波纹
@property (nonatomic, strong) YSCNewVoiceWaveView *voiceWaveViewNew;
@property (nonatomic, strong) UIView *voiceWaveParentViewNew;

//左上view
@property (nonatomic,retain) UIImageView *leftTopView;
//右下view
@property (nonatomic,retain) UIImageView *rightBottomView;
//结果
@property (nonatomic,retain) UILabel *resultLab;
//结果的父视图
@property (nonatomic,retain) UIView *resultParentView;

@end

@implementation IFLYPopView

-(instancetype)initWithType:(IFLYPopType)type
{
    if (self = [super init]) {
        self.type = type;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tap];
        
        [self setupRecorder];
        
        [self configUI];
        
        index = 1;
        
    }
    return self;
}

-(void)setupRecorder
{
    NSURL *url = [NSURL fileURLWithPath:@"/dev/null"];
    NSDictionary *settings = @{AVSampleRateKey:          [NSNumber numberWithFloat: 44100.0],
                               AVFormatIDKey:            [NSNumber numberWithInt: kAudioFormatAppleLossless],
                               AVNumberOfChannelsKey:    [NSNumber numberWithInt: 2],
                               AVEncoderAudioQualityKey: [NSNumber numberWithInt: AVAudioQualityMin]};
    
    NSError *error;
    self.recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
    if(error) {
        NSLog(@"Ups, could not create recorder %@", error);
        return;
    }
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    if (error) {
        NSLog(@"Error setting category: %@", [error description]);
    }
    [self.recorder prepareToRecord];
    [self.recorder setMeteringEnabled:YES];
    [self.recorder record];
}

-(void)configUI
{
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.45];
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 1;
    }];
    
    footerHeight = 120;
    
    //------- 弹窗主内容 -------//
    self.contentView = [[UIView alloc]init];
    [self addSubview:self.contentView];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.contentView.frame = CGRectMake(0, self.height-350, self.width, 350);
    
    [self.contentView addSubview:self.tableView];
    self.DatNum = -1;
    NSMutableArray *indexPaths = @[].mutableCopy;
    self.indesPaths = indexPaths;
    [self charusell];
    
    _centerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.contentView.height-80, 70, 70)];
    _centerView.image = [UIImage imageNamed:@"IFLYPopView_microphone"];
    _centerView.centerX = self.contentView.centerX;
    
    _viewA = [[RippleAnimationView alloc] initWithFrame:CGRectMake(0, 0, 70, 70) animationType:AnimationTypeWithoutBackground];
    _viewA.center = _centerView.center;
    
    [self.contentView addSubview:_viewA];
    [self.contentView addSubview:_centerView];
    
    _resultParentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
    [self.contentView addSubview:_resultParentView];
    
    _leftTopView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    _leftTopView.image = [UIImage imageNamed:@"IFLYPopView_leftTop"];
    [_resultParentView addSubview:_leftTopView];
    
    _resultLab = [[UILabel alloc] initWithFrame:CGRectMake(_leftTopView.right, 8, 60, 34)];
    _resultLab.textColor = [UIColor colorWithHexString:@"#1B82D1"];
    _resultLab.textAlignment = NSTextAlignmentCenter;
    _resultLab.numberOfLines = 2;
    _resultLab.font = [UIFont systemFontOfSize:30];
    [_resultParentView addSubview:_resultLab];
    
    _rightBottomView = [[UIImageView alloc] initWithFrame:CGRectMake(_resultParentView.width-10, _resultParentView.height - 8, 10, 10)];
    _rightBottomView.image = [UIImage imageNamed:@"IFLYPopView_rightbottom"];
    [_resultParentView addSubview:_rightBottomView];
    
    _resultParentView.hidden = YES;
    
//    [self performSelector:@selector(removeAnimationView) withObject:nil afterDelay:3];
}

-(void)removeAnimationView
{
    [_viewA removeFromSuperview];
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, 180) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorColor = [UIColor clearColor];
        [_tableView registerClass:[IFLYPopTableViewCell class] forCellReuseIdentifier:@"IFLYPopTableViewCell"];
    }
    return _tableView;
}

-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        IFLYPopModel *model = [[IFLYPopModel alloc] init];
        model.isRight = 0;
        model.msg = @"试试这样说 :“停车”";
        _dataArr = @[model].mutableCopy;
    }
    return _dataArr;
}

-(void)charusell{
    self.DatNum = self.DatNum +1;
    NSMutableArray *arr = self.dataArr;
    if (self.DatNum < arr.count) {
        [self.indesPaths addObject:[NSIndexPath indexPathForItem:self.DatNum inSection:0]];
        [self.tableView insertRowsAtIndexPaths:self.indesPaths withRowAnimation:UITableViewRowAnimationLeft];
        [self.indesPaths removeAllObjects];
    }else{
        
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.DatNum+1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IFLYPopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IFLYPopTableViewCell" forIndexPath:indexPath];
    [cell refreshCell:self.dataArr[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IFLYPopModel *model = self.dataArr[indexPath.row];
    CGRect rec =  [model.msg boundingRectWithSize:CGSizeMake(280, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]} context:nil];
    return rec.size.height + 45;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    viewFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 120)];
    viewFooter.backgroundColor = [UIColor whiteColor];
    
    [viewFooter addSubview:self.voiceWaveParentViewNew];
    [self.voiceWaveViewNew showInParentView:self.voiceWaveParentViewNew];
    [self.voiceWaveViewNew startVoiceWave];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, viewFooter.height-20, 120, 20)];
    lab.text = @"正在聆听,请说话";
    lab.textColor = [UIColor lightGrayColor];
    lab.font = [UIFont systemFontOfSize:14];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.centerX = viewFooter.centerX;
    [viewFooter addSubview:lab];
    
    [[NSRunLoop currentRunLoop] addTimer:self.updateVolumeTimer forMode:NSRunLoopCommonModes];
    
    return viewFooter;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return footerHeight;
}

- (YSCNewVoiceWaveView *)voiceWaveViewNew
{
    if (!_voiceWaveViewNew) {
        self.voiceWaveViewNew = [[YSCNewVoiceWaveView alloc] init];
        [_voiceWaveViewNew setVoiceWaveNumber:6];
    }
    
    return _voiceWaveViewNew;
}

- (UIView *)voiceWaveParentViewNew
{
    if (!_voiceWaveParentViewNew) {
        self.voiceWaveParentViewNew = [[UIView alloc] init];
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        _voiceWaveParentViewNew.frame = CGRectMake(40, 0, screenSize.width-80, footerHeight);
    }
    
    return _voiceWaveParentViewNew;
}

-(void)configIFLY
{
    //创建语音识别对象
    _iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];
    _iFlySpeechRecognizer.delegate = self;
    //设置识别参数
    //设置是否返回标点符号
    [_iFlySpeechRecognizer setParameter:@"0" forKey:[IFlySpeechConstant ASR_PTT]];
    //设置为听写模式
    [_iFlySpeechRecognizer setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    //用户多长时间不说话则当做超时处理
    [_iFlySpeechRecognizer setParameter:@"3000" forKey:[IFlySpeechConstant VAD_BOS]];
    //用户停止说话多长时间内即认为不再输入,自动停止录音；单位:ms
    [_iFlySpeechRecognizer setParameter:@"1500" forKey:[IFlySpeechConstant VAD_EOS]];
    //启动识别服务
    BOOL result = [_iFlySpeechRecognizer startListening];
    
    self.resultStringFromJson = @"";
}

-(void)configIFLYSynthesis
{
    TTSConfig *instance = [TTSConfig sharedInstance];
    if (instance == nil) {
        return;
    }
    //合成服务单例
    if (_iFlySpeechSynthesizer == nil) {
        _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
    }
    
    _iFlySpeechSynthesizer.delegate = self;
    
    //设置语速1-100
    [_iFlySpeechSynthesizer setParameter:instance.speed forKey:[IFlySpeechConstant SPEED]];
    
    //设置音量1-100
    [_iFlySpeechSynthesizer setParameter:instance.volume forKey:[IFlySpeechConstant VOLUME]];
    
    //设置音调1-100
    [_iFlySpeechSynthesizer setParameter:instance.pitch forKey:[IFlySpeechConstant PITCH]];
    
    //设置采样率
    [_iFlySpeechSynthesizer setParameter:instance.sampleRate forKey:[IFlySpeechConstant SAMPLE_RATE]];
    
    //设置发音人
    [_iFlySpeechSynthesizer setParameter:instance.vcnName forKey:[IFlySpeechConstant VOICE_NAME]];
}

- (void) onResults:(NSArray *) results isLast:(BOOL)isLast
{
    NSMutableString *resultString = [[NSMutableString alloc] init];
    NSDictionary *dic = results[0];
    for (NSString *key in dic) {
        [resultString appendFormat:@"%@",key];
    }
    
    //持续拼接语音内容
    self.resultStringFromJson = [self.resultStringFromJson stringByAppendingString:[ISRDataHelper stringFromJson:resultString]];
    
    if(isLast){
        if (_resultStringFromJson == nil||_resultStringFromJson.length == 0) {
            
            if (index<2) {
                [_iFlySpeechSynthesizer startSpeaking:@"抱歉，没有听清"];
                
                [self performSelector:@selector(refreshCell1) withObject:nil afterDelay:1.4];
                
                [self performSelector:@selector(refreshTableview) withObject:nil afterDelay:4.5];
            }else{
                [_iFlySpeechSynthesizer startSpeaking:@"抱歉，即将结束识别"];
                
                [self performSelector:@selector(refreshCell2) withObject:nil afterDelay:1.4];
                
                [self performSelector:@selector(dismiss) withObject:nil afterDelay:5.5];
            }
            index++;
        
            return;
        }
        
        CGRect rec =  [_resultStringFromJson boundingRectWithSize:CGSizeMake(240, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:30]} context:nil];
        
        _resultLab.size = rec.size;
        _resultParentView.frame = CGRectMake(0, 90 - (16+rec.size.height)/2, 20+rec.size.width, 16+rec.size.height);
        _resultParentView.centerX = self.contentView.centerX;
        _rightBottomView.frame = CGRectMake(_resultParentView.width-10, _resultParentView.height - 8, 10, 10);
        _resultLab.text = [NSString stringWithFormat:@"%@",_resultStringFromJson];
        self.tableView.hidden = YES;
        self.resultParentView.hidden = NO;
        
        [self performSelector:@selector(complete) withObject:nil afterDelay:2];
    }
}

-(void)refreshCell1
{
    CGRect newFrame = viewFooter.frame;
    newFrame.size.height = 0;
    footerHeight = 0;
    viewFooter.frame = newFrame;
    [self.tableView beginUpdates];
    [self.tableView setTableFooterView:viewFooter];
    [self.tableView endUpdates];
    
    [_voiceWaveViewNew removeFromParent];
    _voiceWaveViewNew = nil;
    
    IFLYPopModel *model = [[IFLYPopModel alloc] init];
    model.msg = @"抱歉，没有听清您说什么 请靠近话筒说话，声音尽量清晰";
    model.isRight = 0;
    [self.dataArr addObject:model];
    [self charusell];
}

-(void)refreshCell2
{
    CGRect newFrame = viewFooter.frame;
    newFrame.size.height = 0;
    footerHeight = 0;
    viewFooter.frame = newFrame;
    [self.tableView beginUpdates];
    [self.tableView setTableFooterView:viewFooter];
    [self.tableView endUpdates];
    
    [_voiceWaveViewNew removeFromParent];
    _voiceWaveViewNew = nil;
    
    IFLYPopModel *model = [[IFLYPopModel alloc] init];
    model.msg = @"抱歉，未获取到语音信息,即将结束识别";
    model.isRight = 0;
    [self.dataArr addObject:model];
    [self charusell];
}

-(void)refreshTableview
{
    [self.dataArr removeAllObjects];
    self.dataArr = nil;
    [self.indesPaths removeAllObjects];
    [self.tableView removeFromSuperview];

    footerHeight = 120;
    [self.contentView addSubview:self.tableView];
    self.DatNum = self.dataArr.count-1;
    
    [self.tableView reloadData];

    [self setupRecorder];
    
    [_iFlySpeechRecognizer startListening];
    self.resultStringFromJson = @"";
}

//识别完成，处理结果
-(void)complete
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(IFLYOviceComplete:)]) {
        [self.delegate IFLYOviceComplete:_resultStringFromJson];
        [self dismiss];
    }
}

- (void) onCompleted:(IFlySpeechError *) errorCode{
    NSLog(@"%d",errorCode.errorCode);
    NSLog(@"%@",errorCode.errorDesc);
    if (errorCode.errorCode != 0) {
        
    }
}

//识别会话错误返回
- (void)onError: (IFlySpeechError *) error
{
    //error.errorCode =0 听写正确  other 听写出错
    NSLog(@"code=%d",error.errorCode);
    if(error.errorCode!=0){
        //出错
        
    }
}

-(void)tapAction
{
    [self dismiss];
}

#pragma mark - 弹出此弹窗
/** 弹出此弹窗 */
- (void)show{
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    
    //创建语音识别对象
    [self configIFLY];
    //创建语音合成对象
    [self configIFLYSynthesis];
}

#pragma mark - 移除此弹窗
/** 移除此弹窗 */
- (void)dismiss{
    if ([_iFlySpeechRecognizer isListening]) {
        [_iFlySpeechRecognizer cancel];
    }
    
    if ([_iFlySpeechSynthesizer isSpeaking]) {
        [_iFlySpeechSynthesizer stopSpeaking];
    }
    _iFlySpeechRecognizer.delegate = nil;
    _iFlySpeechSynthesizer.delegate = nil;
    
    if (_updateVolumeTimer) {
        [_updateVolumeTimer invalidate];
        _updateVolumeTimer = nil;
    }
    
    [self.recorder stop];
    [self removeAllSubviews];
    [self removeFromSuperview];
}

- (void)updateVolume:(NSTimer *)timer
{
    [self.recorder updateMeters];
    CGFloat normalizedValue = pow (10, [self.recorder averagePowerForChannel:0] / 15);
    
    NSLog(@"%lf",normalizedValue);
    
    [_voiceWaveViewNew changeVolume:normalizedValue];
}

- (NSTimer *)updateVolumeTimer
{
    if (!_updateVolumeTimer) {
        self.updateVolumeTimer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(updateVolume:) userInfo:nil repeats:YES];
    }
    
    return _updateVolumeTimer;
}

@end
