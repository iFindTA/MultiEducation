# MultiEducation
new multicast education !

first of all, welcom to join in our team ! and you should follow options below:

### 1, please install homebrew on your mac by sudo gem!

### 2，install cocoaPods-1.5.0 by homebrew

### 3, please install protobuf-3.5.1 on your mac by homebrew

### 4, at last install Xunique with python3(pip3)
	4.1, create git hooks:pre-commit for xunique.sh
	4.2, chmod 775 permission

##### git ignore recommand:
step1: git rm -rf --cached MultiEducation.xcodeproj/userdata/
step2: git rm -rf --cached MultiEducation.xcworkspace/userdata/
step3: git rm -rf --cached Pods/Pods.xcodeproj/userdata/
step4: add 
```
.DS_Store
.idea/
.xcworkspace
.xcuserdata
.xcuserstate
Pods/Pods.xcodeproj/xcuserdata/
MultiEducation.xcodeproj/xcuserdata/
MultiEducation.xcworkspace/xcuserdata/
```
to .gitignore

