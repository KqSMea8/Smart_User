//
//  IFLYViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by coder on 2018/9/25.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "IFLYViewController.h"
#import "RippleAnimationView.h"
#import "YSCNewVoiceWaveView.h"
#import <iflyMSC/iflyMSC.h>
#import "ISRDataHelper.h"
#import <AVFoundation/AVFoundation.h>
#import "TTSConfig.h"

@interface IFLYViewController ()<IFlySpeechRecognizerDelegate,IFlySpeechSynthesizerDelegate>
{
    UILabel *remindTitleLab;
    UILabel *remindLab;
}

@property (nonatomic,retain) UIImageView *bgView;
//结果
@property (nonatomic,retain) UILabel *resultLab;
//话筒
@property (nonatomic,retain) UIImageView *centerView;
//@property (nonatomic,retain) RippleAnimationView *viewA;
//状态
@property (nonatomic,retain) UILabel *statusLab;
//波纹
@property (nonatomic, retain) YSCNewVoiceWaveView *voiceWaveViewNew;
@property (nonatomic, retain) UIView *voiceWaveParentViewNew;
//
@property (nonatomic, retain) AVAudioRecorder *recorder;
@property (nonatomic, retain) NSTimer *updateVolumeTimer;
//不带界面的识别对象
@property (nonatomic, strong) IFlySpeechRecognizer *iFlySpeechRecognizer;
//识别结果
@property (nonatomic,copy) NSString *resultStringFromJson;
//语音合成对象
@property (nonatomic, strong) IFlySpeechSynthesizer *iFlySpeechSynthesizer;

@end

@implementation IFLYViewController

//进入时隐藏
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //隐藏=YES,显示=NO; Animation:动画效果
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}

//退出时显示
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //隐藏=YES,显示=NO; Animation:动画效果
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    [_updateVolumeTimer invalidate];
    _updateVolumeTimer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [self setupRecorder];
    
    //创建语音识别对象
    [self configIFLY];
    
    //创建语音合成对象
    [self configIFLYSynthesis];
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

-(void)setupRecorder
{
    [[NSRunLoop currentRunLoop] addTimer:self.updateVolumeTimer forMode:NSRunLoopCommonModes];
    
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

-(void)initView
{
    _bgView = [[UIImageView alloc] init];
    _bgView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    _bgView.image = [UIImage imageNamed:@"ifly_bg"];
    _bgView.userInteractionEnabled = YES;
    [self.view addSubview:_bgView];
    
    UIButton *closeBtn = [[UIButton alloc] init];
    closeBtn.frame = CGRectMake(KScreenWidth-32, 22, 13, 13);
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"ifly_close"] forState:UIControlStateNormal];
    [self.view addSubview:closeBtn];
    
    UIView *tapView = [[UIView alloc] init];
    tapView.frame = CGRectMake(0, 0, 40, 30);
    tapView.center = closeBtn.center;
    [self.view addSubview:tapView];
    
    UITapGestureRecognizer *closeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeView)];
    [tapView addGestureRecognizer:closeTap];
    
    remindTitleLab = [[UILabel alloc] init];
    remindTitleLab.frame = CGRectMake(20, closeBtn.bottom + 20, KScreenWidth-40, 20);
    remindTitleLab.font = [UIFont systemFontOfSize:22];
    remindTitleLab.textAlignment = NSTextAlignmentCenter;
    remindTitleLab.textColor = [UIColor blackColor];
    remindTitleLab.text = @"你可以这样说";
    [self.view addSubview:remindTitleLab];
    
    remindLab = [[UILabel alloc] init];
    NSString *remindStr = @"考勤打卡\n我要开门\n预约车位\n智能停车\n我要寻车";
    remindLab.top = remindTitleLab.bottom + 32;
    remindLab.font = [UIFont systemFontOfSize:19];
    remindLab.textColor = [UIColor colorWithHexString:@"#727272"];
    remindLab.textAlignment = NSTextAlignmentCenter;
    remindLab.numberOfLines = 0;
    [self.view addSubview:remindLab];
    [self setLineSpace:18 withText:remindStr inLabel:remindLab];
    [remindLab sizeToFit];
    remindLab.centerX = KScreenWidth/2;
    
    _resultLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 204*hScale, KScreenWidth-40, 34)];
    _resultLab.textColor = [UIColor colorWithHexString:@"#1B82D1"];
    _resultLab.textAlignment = NSTextAlignmentCenter;
    _resultLab.numberOfLines = 3;
    _resultLab.font = [UIFont systemFontOfSize:26];
    [self.view addSubview:_resultLab];
    _resultLab.hidden = YES;
    
    _centerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.height-100, 70, 70)];
    _centerView.image = [UIImage imageNamed:@"IFLYPopView_microphone"];
    _centerView.centerX = self.view.centerX;
//    _viewA = [[RippleAnimationView alloc] initWithFrame:CGRectMake(0, 0, 70, 70) animationType:AnimationTypeWithoutBackground];
//    _viewA.center = _centerView.center;
//    [self.view addSubview:_viewA];
    _centerView.userInteractionEnabled = YES;
    [self.view addSubview:_centerView];
    _centerView.hidden = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reStart)];
    [_centerView addGestureRecognizer:tap];
    
    [self.view addSubview:self.voiceWaveParentViewNew];
    [self.voiceWaveViewNew showInParentView:self.voiceWaveParentViewNew];
    [self.voiceWaveViewNew startVoiceWave];
    
    _statusLab = [[UILabel alloc] init];
    _statusLab.font = [UIFont systemFontOfSize:20];
    _statusLab.text = @"正在聆听...";
    _statusLab.textAlignment = NSTextAlignmentCenter;
    _statusLab.textColor = [UIColor blackColor];
    _statusLab.frame = CGRectMake(20, self.voiceWaveParentViewNew.top - 20, KScreenWidth-40, 18);
    [self.view addSubview:_statusLab];
}

- (YSCNewVoiceWaveView *)voiceWaveViewNew
{
    if (!_voiceWaveViewNew) {
        self.voiceWaveViewNew = [[YSCNewVoiceWaveView alloc] init];
        _voiceWaveViewNew.backgroundColor = [UIColor clearColor];
        [_voiceWaveViewNew setVoiceWaveNumber:10];
    }
    
    return _voiceWaveViewNew;
}

- (UIView *)voiceWaveParentViewNew
{
    if (!_voiceWaveParentViewNew) {
        self.voiceWaveParentViewNew = [[UIView alloc] init];
        _voiceWaveParentViewNew.backgroundColor = [UIColor clearColor];
        _voiceWaveParentViewNew.frame = CGRectMake(0, KScreenHeight - 140, KScreenWidth, 120);
    }
    
    return _voiceWaveParentViewNew;
}

- (void)updateVolume:(NSTimer *)timer
{
    [self.recorder updateMeters];
    CGFloat normalizedValue = pow (10, [self.recorder averagePowerForChannel:0] / 15);
    
    [_voiceWaveViewNew changeVolume:normalizedValue];
}

- (NSTimer *)updateVolumeTimer
{
    if (!_updateVolumeTimer) {
        self.updateVolumeTimer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(updateVolume:) userInfo:nil repeats:YES];
    }
    
    return _updateVolumeTimer;
}

#pragma mark IFlySpeechRecognizerDelegate

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
            [_iFlySpeechSynthesizer startSpeaking:@"抱歉，没有听清"];
            [self performSelector:@selector(refreshUI) withObject:nil afterDelay:1];
            return;
        }
        
        remindTitleLab.hidden = YES;
        remindLab.hidden = YES;
        _statusLab.text = @"";
        CGRect rec =  [_resultStringFromJson boundingRectWithSize:CGSizeMake(240, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:26]} context:nil];
        _resultLab.size = rec.size;
        _resultLab.text = [NSString stringWithFormat:@"%@",_resultStringFromJson];
        _resultLab.centerX = KScreenWidth/2;
        _resultLab.hidden = NO;
        
        [self performSelector:@selector(complete) withObject:nil afterDelay:2];
    }
}

-(void)refreshUI{
    _statusLab.text = @"未检测到语音，请点击话筒重试";
    _voiceWaveParentViewNew.hidden = YES;
    _centerView.hidden = NO;
}

#pragma mark IFlySpeechSynthesizerDelegate
//合成完成
- (void) onCompleted:(IFlySpeechError*) error
{
    
}

#pragma mark 重新开始语音识别
-(void)reStart
{
    _statusLab.text = @"正在聆听...";
    remindTitleLab.hidden = NO;
    remindLab.hidden = NO;
    _voiceWaveParentViewNew.hidden = NO;
    _centerView.hidden = YES;
    
    if (_iFlySpeechSynthesizer.isSpeaking) {
        [_iFlySpeechSynthesizer stopSpeaking];
    }
    
    [self setupRecorder];
    [_iFlySpeechRecognizer startListening];
    self.resultStringFromJson = @"";
}

//识别完成，处理结果
-(void)complete
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(IFLYRecComplete:)]) {
        [self.delegate IFLYRecComplete:_resultStringFromJson];
        [self closeView];
    }
}

-(void)closeView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setLineSpace:(CGFloat)lineSpace withText:(NSString *)text inLabel:(UILabel *)label{
    if (!text || !label) {
        return;
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace;  //设置行间距
    paragraphStyle.lineBreakMode = label.lineBreakMode;
    paragraphStyle.alignment = label.textAlignment;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    label.attributedText = attributedString;
}

-(void)dealloc
{
    if ([_iFlySpeechRecognizer isListening]) {
        [_iFlySpeechRecognizer cancel];
    }
    
    if ([_iFlySpeechSynthesizer isSpeaking]) {
        [_iFlySpeechSynthesizer stopSpeaking];
    }
    _iFlySpeechRecognizer.delegate = nil;
    _iFlySpeechSynthesizer.delegate = nil;
    
    [self.voiceWaveViewNew removeFromParent];
    _voiceWaveViewNew = nil;
    
    [self.recorder stop];
}

@end
