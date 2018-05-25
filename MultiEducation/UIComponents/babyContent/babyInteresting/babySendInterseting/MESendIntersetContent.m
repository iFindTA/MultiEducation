//
//  MESendIntersetContent.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/5/18.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MESendIntersetContent.h"
#import "UITextView+Placeholder.h"
#import "MESelectPhotoCell.h"
#import <TZImagePickerController.h>
#import <SVProgressHUD.h>
#import "MEBabyIntersetingSelectView.h"
#import "MEStuInterestModel.h"
#import "UIView+Utils.h"
#import <YYKit.h>

#define CELL_IDEF @"cell_idef"
#define CELL_SIZE CGSizeMake(110.f, 110.f)
#define LEFT_SPACE 25.f
#define TEXT_INPUT_HEIGHT 125.f
 
@interface MESendIntersetContent() <UITextFieldDelegate, UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray <NSDictionary *> *dataArr;  //数据源

@property (nonatomic, strong) UITextField *titleTF;
@property (nonatomic, strong) UITextView *contentTV;
@property (nonatomic, strong) UICollectionView *photoView;
@property (nonatomic, strong) MEBaseScene *sepView; //sep between contentTV & titleTF
@property (nonatomic, strong) MEBabyIntersetingSelectView *selectView;

@property (nonatomic, strong) MEStuInterestModel *stuModel;

@end

@implementation MESendIntersetContent

/**
 初始化StuInterestModel
 */
- (void)initializeStudentModel {
    _stuModel = [MEStuInterestModel fetchStudentInterestModel];
    if (!_stuModel) {
        _stuModel = [[MEStuInterestModel alloc] init];
    }
}

/**
 判断是否有本地缓存数据，仅在页面init时调用一次，如果有，将model数据放到view上
 */
- (BOOL)whetherHaveLocalizationDataOfMEStudentModel {
    if ([MEStuInterestModel fetchStudentInterestModel]) {
        return true;
    } else {
        return false;
    }
}

- (void)showAlert2UserWhetherFetchStuInterestModel {
    [self initializeStudentModel];
    if ([self whetherHaveLocalizationDataOfMEStudentModel]) {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"提示" message: @"检测到上次有未提交的数据，是否继续编辑？" preferredStyle: UIAlertControllerStyleAlert];
        
        weakify(self);
        UIAlertAction *certain = [UIAlertAction actionWithTitle: @"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            strongify(self);
            [self fetchLocalizationData2UIComponent];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler: nil];
        [controller addAction: certain];
        [controller addAction: cancel];
        
        [[self viewController].navigationController presentViewController: controller animated: true completion: nil];
    }
}

//将本地缓存数据放到view上
- (void)fetchLocalizationData2UIComponent {
    if (self.didFetchlocalizationDataHandler) {
        self.didFetchlocalizationDataHandler(_stuModel);
    }
    self.titleTF.text = _stuModel.title;
    self.contentTV.text = _stuModel.context;
    [self.dataArr removeAllObjects];
    [self.dataArr addObjectsFromArray: _stuModel.images];
    [self.photoView reloadData];
    
    [self.selectView.dataArr removeAllObjects];
    self.selectView.dataArr = [NSMutableArray arrayWithArray: _stuModel.stuArr];
}

- (void)customSubviews {
    [self addSubview: self.titleTF];
    [self addSubview: self.contentTV];
    [self addSubview: self.photoView];
    [self addSubview: self.sepView];
    
    //layout
    [self.titleTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.left.mas_equalTo(self).mas_offset(LEFT_SPACE);
        make.width.mas_equalTo(MESCREEN_WIDTH - 2 * LEFT_SPACE);
        make.height.mas_equalTo(52.f);
    }];
    
    [self.sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(LEFT_SPACE);
        make.top.mas_equalTo(self.titleTF.mas_bottom);
        make.height.mas_equalTo(ME_LAYOUT_LINE_HEIGHT);
        make.width.mas_equalTo(MESCREEN_WIDTH - LEFT_SPACE * 2);
    }];
    
    [self.contentTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(LEFT_SPACE - 5);
        make.top.mas_equalTo(self.sepView.mas_bottom);
        make.width.mas_equalTo(MESCREEN_WIDTH - LEFT_SPACE * 2 + 10);
        make.height.mas_equalTo(TEXT_INPUT_HEIGHT);
    }];
    
    [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(LEFT_SPACE);
        make.top.mas_equalTo(self.contentTV.mas_bottom).mas_offset(10.f);
        make.width.mas_equalTo(MESCREEN_WIDTH - LEFT_SPACE);
        make.height.mas_equalTo(CELL_SIZE.height);
    }];
    self.bottomView = self.photoView;
    
    if (self.currentUser.userType == MEPBUserRole_Teacher || self.currentUser.userType == MEPBUserRole_Gardener) {
        [self addSubview: self.selectView];
        [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self);
            make.height.mas_equalTo(52.f);
            make.top.mas_equalTo(self.photoView.mas_bottom).mas_offset(54.f);
        }];
        self.bottomView = self.selectView;
    }
}

- (BOOL)whetherCanPickImage {
    if (self.dataArr.count == 0) {
        return true;
    } else {
        NSDictionary *dic = self.dataArr.firstObject;
        NSString *filePath = [dic objectForKey: @"filePath"];
        if ([filePath hasSuffix: @".mp4"]) {
            [MEKits makeToast: @"视频最多可上传1部"];
            return false;
        } else {
            if (self.dataArr.count >= 9) {
                [MEKits makeToast: @"照片最多可上传9张"];
                return false;
            }
            return true;
        }
    }
}

#pragma mark - public func
- (void)didSelectImagesOrVideo:(NSArray<NSDictionary *> *)images {
    
    _stuModel.images = images;
    [MEStuInterestModel saveOrUpdateStudentInterestModel: _stuModel];
    
    [self.dataArr removeAllObjects];
    [self.dataArr addObjectsFromArray: images];
    [self.photoView reloadData];
}

- (BOOL)whetherCanPickPhotoFromImagePickerProfile {
    if ([[self.dataArr.firstObject objectForKey: @"extension"] isEqualToString: @"mp4"]) {
        if (self.dataArr.count  >= 1) {
            [MEKits makeToast: @"视频最多可上传1部，请删除后重新选择上传"];
            return false;
        } else {
            return true;
        }
    } else {
        if (self.dataArr.count  >= 9) {
            [MEKits makeToast: @"照片最多可上传9张，请删除后重新选择上传"];
            return false;
        } else {
            return true;
        }
    }
}

- (NSString *)getInterestTitle {
    return self.titleTF.text;
}

- (NSString *)getInterestContext {
    return self.contentTV.text;
}

- (NSArray<MEStudentModel *> *)getInterestingStuArr {
    return [self.selectView getInterestingStuArr];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return true;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    _stuModel.title = textField.text;
    [MEStuInterestModel saveOrUpdateStudentInterestModel: _stuModel];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString: @"\n"]) {
        [textView resignFirstResponder];
    }
    return true;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    _stuModel.context = textView.text;
    [MEStuInterestModel saveOrUpdateStudentInterestModel: _stuModel];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MESelectPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: CELL_IDEF forIndexPath: indexPath];
    if (indexPath.row != self.dataArr.count) {
        [cell setPhotoCell: self.dataArr[indexPath.row]];
        weakify(self);
        cell.DidDeleteCallback = ^(NSDictionary *dic) {
            strongify(self);
            [self.dataArr removeObject: dic];
            [self.photoView reloadData];
        };
    } else {
        [cell setSelectCell];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_SIZE;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.dataArr.count) {
        if ([self whetherCanPickPhotoFromImagePickerProfile]) {
            //上传图片
            if ([self whetherCanPickImage]) {
                if (self.DidPickerButtonTouchCallback) {
                    self.DidPickerButtonTouchCallback();
                }
            }
        }
    }
}

#pragma mark - lazyloading
- (UITextField *)titleTF {
    if (!_titleTF) {
        _titleTF = [[UITextField alloc] init];
        _titleTF.borderStyle = UITextBorderStyleNone;
        _titleTF.placeholder = @"请输入标题";
        _titleTF.textColor = UIColorFromRGB(0x333333);
        _titleTF.font = UIFontPingFangSC(15);
        _titleTF.delegate = self;
    }
    return _titleTF;
}

- (UITextView *)contentTV {
    if (!_contentTV) {
        _contentTV = [[UITextView alloc] init];
        _contentTV.font = UIFontPingFangSC(15);
        [_contentTV setPlaceholder: @"请输入文字" placeholdColor: UIColorFromRGB(0xCCCCCC)];
        _contentTV.textColor = UIColorFromRGB(0x333333);
        _contentTV.delegate = self;
    }
    return _contentTV;
}

- (UICollectionView *)photoView {
    if (!_photoView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 8.f;
        
        _photoView = [[UICollectionView alloc] initWithFrame: CGRectZero collectionViewLayout: layout];
        _photoView.showsHorizontalScrollIndicator = false;
        _photoView.backgroundColor = [UIColor whiteColor];
        _photoView.delegate = self;
        _photoView.dataSource = self;
        [_photoView registerNib: [UINib nibWithNibName: @"MESelectPhotoCell" bundle: nil] forCellWithReuseIdentifier: CELL_IDEF];
    }
    return _photoView;
}

- (MEBaseScene *)sepView {
    if (!_sepView) {
        _sepView = [[MEBaseScene alloc] init];
        _sepView.backgroundColor = UIColorFromRGB(0xF8F8F8);
    }
    return _sepView;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (MEBabyIntersetingSelectView *)selectView {
    if (!_selectView) {
        _selectView = [[MEBabyIntersetingSelectView alloc] init];
        _selectView.semester = _semester;
        _selectView.classId = _classId;
        _selectView.gradeId = _gradeId;
        [_selectView customSubviews];
        _selectView.userInteractionEnabled = true;
        weakify(self);
        _selectView.DidRemakeMasonry = ^(UIView *bottomView) {
            strongify(self);
            [self.selectView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(self);
                make.top.mas_equalTo(self.photoView.mas_bottom).mas_offset(54.f);
                make.bottom.mas_equalTo(bottomView.mas_bottom);
            }];
        };
        _selectView.didSelectStuCallback = ^(NSArray *stuArr) {
            strongify(self);
            _stuModel.stuArr = stuArr;
            [MEStuInterestModel saveOrUpdateStudentInterestModel: _stuModel];
        };
    }
    return _selectView;
}

- (NSMutableArray *)selectedImages {
    if (!_selectedImages) {
        _selectedImages = [NSMutableArray array];
    }
    return _selectedImages;
}

@end
