//
//  HumanFaceViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2018/4/8.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "HumanFaceViewController.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import "PersonMsgModel.h"
#import "Utils.h"
#import <AVFoundation/AVCaptureDevice.h>
#import "CameraViewController.h"
#import "UIImage+Zip.h"

@interface HumanFaceViewController ()<imagePickerDelegate,UIAlertViewDelegate>
{
    UIImage *_humanFaceImage;
    BOOL isSuccess;
}

@property (weak, nonatomic) IBOutlet UIImageView *humanFaceImageView;
@property (weak, nonatomic) IBOutlet UIButton *uploadHumanFacaeBtn;
@property (weak, nonatomic) IBOutlet UILabel *remindLab;

@end

@implementation HumanFaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isSuccess = NO;
    
    [self cheakCarame];
    
    [self _initNavItems];
    
    [self _initView];
    
    [self loadHumanfaceData];
}

-(void)setType:(NSString *)type
{
    _type = type;
}

-(void)cheakCarame
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
    {
        //无权限 弹框提示是否去开启相应权限
        
        NSString *msg = [NSString stringWithFormat:@"相机访问权限被禁用,是否去设置开启访问相机权限？"];
        UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *remove = [UIAlertAction actionWithTitle:@"去开启" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            
            [self performSelector:@selector(popView) withObject:nil afterDelay:0.5];
        }];
        
        [alertCon addAction:cancel];
        [alertCon addAction:remove];
        [self presentViewController:alertCon animated:YES completion:nil];
    }
}

-(void)popView{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)_initNavItems
{
    self.title = @"我的信息";
    
    UIButton *leftBtn = [[UIButton alloc] init];
    leftBtn.frame = CGRectMake(0, 0, 40, 40);
    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    [leftBtn setImage:[UIImage imageNamed:@"login_back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(_leftBarBtnItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)_leftBarBtnItemClick {
    if (isSuccess) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void)_initView
{
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    
    _uploadHumanFacaeBtn.layer.cornerRadius = 4;
    _uploadHumanFacaeBtn.clipsToBounds = YES;
    
    _humanFaceImageView.contentMode = UIViewContentModeScaleAspectFill;
    _humanFaceImageView.clipsToBounds = YES;
    
    if ([_type isEqualToString:@"1"]) {
        // 禁止左滑
        id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
        UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
        [self.view addGestureRecognizer:pan];
    }
}

#pragma mark 加载人像信息
-(void)loadHumanfaceData
{
    NSString *custId = [[NSUserDefaults standardUserDefaults] objectForKey:kCustId];
    NSString *urlStr = [NSString stringWithFormat:@"%@/public/getCustInfo", MainUrl];
    NSMutableDictionary *param = @{}.mutableCopy;
    if(![custId isKindOfClass:[NSNull class]]&&custId != nil){
        [param setObject:custId forKey:@"custId"];
    }
    [self showHudInView:self.view hint:nil];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:param progressFloat:nil succeed:^(id responseObject) {
        
        if([responseObject[@"code"] isEqualToString:@"1"]){
            PersonMsgModel *model = [[PersonMsgModel alloc] initWithDataDic:responseObject[@"responseData"]];
            if ([model.FACE_IMAGE_ID isKindOfClass:[NSNull class]]||model.FACE_IMAGE_ID == nil) {
                [self hideHud];
                _humanFaceImageView.image = [UIImage imageNamed:@"humanface_placeholder"];
                [_uploadHumanFacaeBtn setTitle:@"上传人像信息" forState:UIControlStateNormal];
            }else{
                [_uploadHumanFacaeBtn setTitle:@"修改人像信息" forState:UIControlStateNormal];
                [self getHumanFaceData:model.FACE_IMAGE_ID];
            }
        }
    } failure:^(NSError *error) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"人像信息获取失败,请返回重试!" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
//        [alertView show];
        [self showHint:@"人像信息获取失败,请返回重试!"];
        [self hideHud];
    }];
}

-(void)getHumanFaceData:(NSString *)faceid
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/public/getUserFaceImage",MainUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:faceid forKey:@"faceImageId"];
    
    NSString *jsonStr = [self convertToJsonData:params];

    NSMutableDictionary *jsonParam = @{}.mutableCopy;
    [jsonParam setObject:jsonStr forKey:@"param"];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:jsonParam progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        if([responseObject[@"code"] isEqualToString:@"1"]){
            NSDictionary *dic = responseObject[@"responseData"];
            NSString *base64Str1 = dic[@"imgBase64"];
            NSString *base64Str = [base64Str1 componentsSeparatedByString:@"base64,"].lastObject;
            NSData *decodedImageData = [[NSData alloc] initWithBase64EncodedString:base64Str options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *decodedImage = [UIImage imageWithData:decodedImageData];
            if (decodedImage == nil) {
                _humanFaceImageView.image = [UIImage imageNamed:@"humanface_placeholder"];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"人像信息获取失败,请返回重试!" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
                [alertView show];
            }else{
                _humanFaceImageView.image = decodedImage;
            }
            
        }else{
            [self showHint:responseObject[@"message"] yOffset:-120];
        }
    } failure:^(NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"人像信息获取失败,请返回重试!" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
        [alertView show];
        [self hideHud];
    }];
}

#pragma mark 人像上传
- (IBAction)uploadHumanFaceAction:(id)sender {
    
    [self humanFaceTapAction];
}

#pragma mark 图片压缩至2M以内
- (void)imageData:(UIImage *)image {
//    NSData *data = UIImageJPEGRepresentation(image, 0.8f);
//
//    if(data.length/1024 < 1024*2){
//        // 小于2M 结束
//        [self uploadFaceImage:data];
//    }else {
//        UIImage *dataImage = [UIImage imageWithData:data];
//        [self imageData:dataImage];
//    }
    
    NSData *data = [UIImage compressWithOrgImg:image];
    [self uploadFaceImage:data];
}
-(void)uploadFaceImage:(NSData *)data
{
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    encodedImageStr = [NSString stringWithFormat:@"data:image/jpeg;base64,%@", encodedImageStr];
    encodedImageStr = [encodedImageStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    encodedImageStr = [encodedImageStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSString *kcustid = [kUserDefaults objectForKey:kCustId];
    NSString *cerdid = [kUserDefaults objectForKey:KUserCertId];
    NSString *custmobile = [kUserDefaults objectForKey:KUserPhoneNum];
    NSString *custname = [kUserDefaults objectForKey:KUserCustName];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/public/updateUserFaceImage",MainUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:encodedImageStr forKey:@"base64EncodeImage"];
    if (![kcustid isKindOfClass:[NSNull class]]&&kcustid != nil&&kcustid.length != 0) {
        [params setObject:kcustid forKey:@"custId"];
    }
    if (![cerdid isKindOfClass:[NSNull class]]&&cerdid != nil&&cerdid.length != 0) {
        [params setObject:cerdid forKey:@"certId"];
    }
    if (![custmobile isKindOfClass:[NSNull class]]&&custmobile != nil&&custmobile.length != 0) {
        [params setObject:custmobile forKey:@"custMobile"];
    }
    if (![custname isKindOfClass:[NSNull class]]&&custname != nil&&custname.length != 0) {
        [params setObject:custname forKey:@"custName"];
    }
    
    NSString *jsonStr = [self convertToJsonData:params];

    NSMutableDictionary *jsonParam = @{}.mutableCopy;
    [jsonParam setObject:jsonStr forKey:@"param"];
    
    [self showHudInView:self.view hint:@"人像信息上传中..."];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:jsonParam progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        if([responseObject[@"code"] isEqualToString:@"1"]){
            NSDictionary *dic = responseObject[@"responseData"];
            NSString *humanfaceid = dic[@"faceImageId"];
            if ([humanfaceid isKindOfClass:[NSNull class]]||humanfaceid == nil||humanfaceid.length == 0) {
                [kUserDefaults setObject:@"" forKey:KFACE_IMAGE_ID];
            }else{
                [kUserDefaults setObject:humanfaceid forKey:KFACE_IMAGE_ID];
            }
            [kUserDefaults synchronize];
            isSuccess = YES;
            [self showHint:@"上传人像信息成功!" yOffset:-120];
            [self performSelector:@selector(popView) withObject:nil afterDelay:0.5];
        }else{
            isSuccess = NO;
            [self showHint:responseObject[@"message"] yOffset:-120];
        }
    } failure:^(NSError *error) {
        [self hideHud];
        isSuccess = NO;
        [self showHint:@"上传人像信息失败,请重试!" yOffset:-120];
    }];
}

#pragma mark 选择人像照片
-(void)humanFaceTapAction
{
    [self openCamera];
}

#pragma mark 调用相机
-(void)openCamera
{
    CameraViewController *camVC = [[CameraViewController alloc] init];
    camVC.leftBtnTitle = @"重拍";
    camVC.rightBtnTitle = @"保存人像";
    camVC.delegate = self;
    [self presentViewController:camVC animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

// 拍照完成回调
-(void)imagePicker:(UIViewController *)picker didFinishPickingImage:(UIImage *)image
{
    //人像图片上传
    UIImage *fixImage = [Utils fixOrientation:image];
    _humanFaceImage = fixImage;
    //图片上传
    _humanFaceImageView.image = _humanFaceImage;
    
    if (_humanFaceImage == nil) {
        [self showHint:@"请先选择人像照片!" yOffset:-120];
        return;
    }
    
    [self imageData:_humanFaceImageView.image];
}

- (NSString *)convertToJsonData:(NSDictionary *)dict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];

    return mutStr;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self popView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
