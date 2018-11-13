//
//  CameraViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2018/4/24.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "CameraViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface CameraViewController ()<AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate,CAAnimationDelegate>
//捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入）
@property(nonatomic)AVCaptureDevice *device;
//AVCaptureDeviceInput 代表输入设备，他使用AVCaptureDevice 来初始化
@property(nonatomic)AVCaptureDeviceInput *input;
//当启动摄像头开始捕获输入
@property(nonatomic)AVCaptureMetadataOutput *output;
//输出
@property (nonatomic)AVCaptureStillImageOutput *ImageOutPut;
//session：由他把输入输出结合在一起，并开始启动捕获设备（摄像头）
@property(nonatomic)AVCaptureSession *session;
//图像预览层，实时显示捕获的图像
@property(nonatomic)AVCaptureVideoPreviewLayer *previewLayer;
//设备
@property (nonatomic, strong)AVCaptureDevice *deveice;
//拍照
@property (nonatomic, strong) UIButton *PhotoButton;
//取消
@property (nonatomic, strong) UIButton *cancleButton;
//确定选择当前照片
@property (nonatomic, strong) UIButton *selectButton;
//重新拍照
@property (nonatomic, strong) UIButton *reCamButton;
//照片加载视图
@property (nonatomic, strong) UIImageView *imageView;
//对焦区域
@property (nonatomic, strong) UIImageView *focusView;
//上方功能区
@property (nonatomic, strong) UIView *topView;
//下方功能区
@property (nonatomic, strong) UIView *bottomView;
//拍到的照片
@property (nonatomic, strong) UIImage *image;
//照片的信息
@property (nonatomic, strong) NSDictionary *imageDict;
//是否可以拍照
@property (nonatomic, assign) BOOL canCa;
//闪光灯模式
@property (nonatomic, assign) AVCaptureFlashMode flahMode;
//前后摄像头
@property (nonatomic, assign) AVCaptureDevicePosition cameraPosition;

@end

@implementation CameraViewController

#pragma mark - 取消
-(UIButton *)cancleButton{
    if (_cancleButton == nil) {
        _cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancleButton.frame = CGRectMake(20, 25, 60, 30);
        [_cancleButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancleButton addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
    }
    return  _cancleButton ;
}

#pragma mark - 下方功能区
-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight-80, KScreenWidth, 80)];
        _bottomView.backgroundColor = [UIColor blackColor];
        [_bottomView addSubview:self.cancleButton];
        [_bottomView addSubview:self.reCamButton];
        [_bottomView addSubview:self.PhotoButton];
        [_bottomView addSubview:self.selectButton];
    }
    return _bottomView;
}

-(UIButton *)reCamButton{
    if (_reCamButton == nil) {
        _reCamButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _reCamButton.frame = CGRectMake(40, 25, 80, 30);
        [_reCamButton addTarget:self action:@selector(reCam) forControlEvents:UIControlEventTouchUpInside];
        [_reCamButton setTitle:_leftBtnTitle forState:UIControlStateNormal];
        [_reCamButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _reCamButton.alpha = 0;
    }
    return _reCamButton;
}

-(UIButton *)PhotoButton{
    if (_PhotoButton == nil) {
        _PhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _PhotoButton.frame = CGRectMake(KScreenWidth/2.0-30, 10, 60, 60);
        [_PhotoButton setImage:[UIImage imageNamed:@"photograph"] forState: UIControlStateNormal];
        [_PhotoButton setImage:[UIImage imageNamed:@"photograph_Select"] forState:UIControlStateNormal];
        [_PhotoButton addTarget:self action:@selector(shutterCamera) forControlEvents:UIControlEventTouchUpInside];
    }
    return _PhotoButton;
}

-(UIButton *)selectButton{
    if (_selectButton == nil) {
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectButton.frame = CGRectMake(KScreenWidth-120, 25, 80, 30);
        [_selectButton addTarget:self action:@selector(selectImage) forControlEvents:UIControlEventTouchUpInside];
        [_selectButton setTitle:_rightBtnTitle forState:UIControlStateNormal];
        [_selectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _selectButton.alpha = 0;
    }
    return _selectButton;
}

#pragma mark - 加载照片的视图
-(UIImageView *)imageView{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc]initWithFrame:self.previewLayer.frame];
        _imageView.layer.masksToBounds = YES;
        _imageView.image = _image;
    }
    return _imageView;
}

#pragma mark - 对焦区域
-(UIImageView *)focusView{
    if (_focusView == nil) {
        _focusView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
        _focusView.backgroundColor = [UIColor clearColor];
        _focusView.image = [UIImage imageNamed:@"foucs80pt"];
    }
    return _focusView;
}

#pragma mark - 使用self.session，初始化预览层，self.session负责驱动input进行信息的采集，layer负责把图像渲染显示
-(AVCaptureVideoPreviewLayer *)previewLayer{
    if (_previewLayer == nil) {
        _previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
        _previewLayer.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight-80);
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }
    return  _previewLayer;
}

-(AVCaptureStillImageOutput *)ImageOutPut{
    if (_ImageOutPut == nil) {
        _ImageOutPut = [[AVCaptureStillImageOutput alloc] init];
    }
    return _ImageOutPut;
}

#pragma mark - 初始化输入
-(AVCaptureDeviceInput *)input{
    if (_input == nil) {
        _input = [[AVCaptureDeviceInput alloc]initWithDevice:self.device error:nil];
    }
    return _input;
}

#pragma mark - 初始化输出
-(AVCaptureMetadataOutput *)output{
    if (_output == nil) {
        _output = [[AVCaptureMetadataOutput alloc]init];
    }
    return  _output;
}

#pragma mark - 使用AVMediaTypeVideo 指明self.device代表视频，默认使用后置摄像头进行初始化
-(AVCaptureDevice *)device{
    if (_device == nil) {
        _device = [self getCameraDeviceWithPosition:AVCaptureDevicePositionFront];
    }
    return _device;
}

#pragma mark -  取得指定位置的摄像头
-(AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition )position{
    NSArray *cameras= [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras) {
        if ([camera position]==position) {
            return camera;
        }
    }
    return nil;
}

#pragma mark - 当前视图控制器的初始化
- (instancetype)init
{
    self = [super init];
    if (self) {
        _canCa = [self canUserCamear];
    }
    return self;
}

-(void)setLeftBtnTitle:(NSString *)leftBtnTitle
{
    _leftBtnTitle = leftBtnTitle;
}

-(void)setRightBtnTitle:(NSString *)rightBtnTitle
{
    _rightBtnTitle = rightBtnTitle;
}
//-(void)setImageblock:(void (^)(UIImage *))imageblock{
//    _imageblock = imageblock;
//}

#pragma mark - 检查相机权限
- (BOOL)canUserCamear{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请打开相机权限" message:@"设置-隐私-相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        alertView.tag = 100;
        [alertView show];
        return NO;
    }
    else{
        return YES;
    }
    return YES;
}

#pragma mark - 视图加载
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if (_canCa) {
        [self customCamera];
        [self customUI];
    }else{
        return;
    }
    if (self.session) {
        [self.session startRunning];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    if (self.session) {
        [self.session stopRunning];
    }
}

#pragma mark - 自定义视图
- (void)customUI{
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.focusView];
    
    UIView *backGroundView = [[UIView alloc] initWithFrame:self.previewLayer.frame];
    backGroundView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backGroundView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(focusGesture:)];
    [backGroundView addGestureRecognizer:tapGesture];
}

#pragma mark - 自定义相机
- (void)customCamera{
    //生成会话，用来结合输入输出
    self.session = [[AVCaptureSession alloc]init];
    if ([self.session canSetSessionPreset:AVCaptureSessionPresetPhoto]) {
        self.session.sessionPreset = AVCaptureSessionPresetPhoto;
    }
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    
    if ([self.session canAddOutput:self.ImageOutPut]) {
        [self.session addOutput:self.ImageOutPut];
    }
    
    [self.view.layer addSublayer:self.previewLayer];
    
    //开始启动
    [self.session startRunning];
    if ([self.device lockForConfiguration:nil]) {
        if ([self.device isFlashModeSupported:AVCaptureFlashModeAuto]) {
            [self.device setFlashMode:AVCaptureFlashModeAuto];
        }
        //自动白平衡
        if ([self.device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
            [self.device setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
        }
        
        [self.device unlockForConfiguration];
    }
    [self focusAtPoint:self.view.center];
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices )
        if ( device.position == position ) return device;
    return nil;
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [self.imageView removeFromSuperview];
    if (self.cameraPosition == AVCaptureDevicePositionFront) {
        //        self.flashButton.alpha = 0;
    }else if (self.cameraPosition == AVCaptureDevicePositionBack){
        //        self.flashButton.alpha = 1;
    }
    [self.session startRunning];
}

#pragma mark - 开始高斯模糊
- (void)cutoff{
    AVCaptureConnection * videoConnection = [self.ImageOutPut connectionWithMediaType:AVMediaTypeVideo];
    if (!videoConnection) {
        NSLog(@"take photo failed!");
        return;
    }
    NSLog(@"%lf",[[NSDate date] timeIntervalSince1970]);
    [self.session stopRunning];
    [self.ImageOutPut captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer == NULL) {
            return;
        }
    }];
}

#pragma mark - 聚焦
- (void)focusGesture:(UITapGestureRecognizer*)gesture{
    CGPoint point = [gesture locationInView:gesture.view];
    [self focusAtPoint:point];
}

- (void)focusAtPoint:(CGPoint)point{
    CGSize size = self.view.bounds.size;
    CGPoint focusPoint = CGPointMake( point.y /size.height ,1-point.x/size.width );
    NSError *error;
    if ([self.device lockForConfiguration:&error]) {
        
        if ([self.device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            [self.device setFocusPointOfInterest:focusPoint];
            [self.device setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        
        if ([self.device isExposureModeSupported:AVCaptureExposureModeAutoExpose ]) {
            [self.device setExposurePointOfInterest:focusPoint];
            [self.device setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        
        [self.device unlockForConfiguration];
        self.focusView.center = point;
        
        //[self startFocusAnimation];
        self.focusView.alpha = 1;
        [UIView animateWithDuration:0.2 animations:^{
            self.focusView.transform = CGAffineTransformMakeScale(1.25f, 1.25f);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{
                self.focusView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
            } completion:^(BOOL finished) {
                [self hiddenFocusAnimation];
            }];
        }];
    }
}

#pragma mark - 拍照
- (void)shutterCamera
{
    AVCaptureConnection * videoConnection = [self.ImageOutPut connectionWithMediaType:AVMediaTypeVideo];
    if (!videoConnection) {
        NSLog(@"take photo failed!");
        return;
    }
    
    [self.ImageOutPut captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer == NULL) {
            return;
        }
        NSData * imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        self.image = [UIImage imageWithData:imageData];
        self.imageDict = @{@"image":self.image,@"info":@{@"PHImageFileUTIKey":@".jpeg"}};
        [self.session stopRunning];
        //[self.view insertSubview:self.imageView belowSubview:self.PhotoButton];
        [self.view insertSubview:self.imageView aboveSubview:self.topView];
        //        NSLog(@"image size = %@",NSStringFromCGSize(self.image.size));
        self.topView.alpha = 0;
        self.PhotoButton.alpha = 0;
        self.cancleButton.alpha = 0;
        self.reCamButton.alpha = 1;
        self.selectButton.alpha = 1;
    }];
}

#pragma mark - 取消 返回上级
-(void)cancle{
    [self.imageView removeFromSuperview];
    [self.session stopRunning];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0 && alertView.tag == 100) {
        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

#pragma mark - 重新拍照
- (void)reCam{
    self.imageView.image = nil;
    [self.imageView removeFromSuperview];
    [self.session startRunning];
    self.topView.alpha = 1;
    self.PhotoButton.alpha = 1;
    self.cancleButton.alpha = 1;
    self.reCamButton.alpha = 0;
    self.selectButton.alpha = 0;
}

#pragma mark - 选择照片 返回上级
- (void)selectImage{
    //    if (self.imageblock != nil) {
    //        self.imageblock(self.image);
    //    }
    if (self.delegate != nil&&[self.delegate respondsToSelector:@selector(imagePicker:didFinishPickingImage:)]) {
        [self.delegate imagePicker:self didFinishPickingImage:self.image];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)focusDidFinsh{
    self.focusView.hidden = YES;
    self.focusView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    //self.focusView.transform=CGAffineTransformMakeScale(0.7f, 0.7f);
}

- (void)startFocusAnimation{
    self.focusView.hidden = NO;
    self.focusView.transform = CGAffineTransformMakeScale(1.25f, 1.25f);//将要显示的view按照正常比例显示出来
    [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
    //[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];  //InOut 表示进入和出去时都启动动画
    //[UIView setAnimationWillStartSelector:@selector(hiddenFoucsView)];
    [UIView setAnimationDidStopSelector:@selector(hiddenFocusAnimation)];
    [UIView setAnimationDuration:0.5f];//动画时间
    self.focusView.transform = CGAffineTransformIdentity;//先让要显示的view最小直至消失
    [UIView commitAnimations]; //启动动画
    //相反如果想要从小到大的显示效果，则将比例调换
}

- (void)hiddenFocusAnimation{
    [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
    //NSDate *DATE = [NSDate date];
    //[UIView setAnimationStartDate:[NSDate date]];
    [UIView setAnimationDelay:1];
    self.focusView.alpha = 0;
    [UIView setAnimationDuration:0.5f];//动画时间
    [UIView commitAnimations];
}

- (void)hiddenFoucsView{
    self.focusView.alpha = !self.focusView.alpha;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

