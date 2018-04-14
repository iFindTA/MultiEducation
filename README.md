# MultiEducation
new multicast education !

first of all, welcom to join in our team ! and you should follow options below:

### 1, please install homebrew on your mac by sudo gem!

### 2，install cocoaPods-1.5.0 by homebrew

### 3, please install protobuf-3.5.1 on your mac by homebrew

### 4, install Xunique with python3(pip3)

	4.1, create git hooks:pre-commit for xunique.sh
	4.2, chmod 775 permission

### 5，install sketch and sourcetree softwares

### 6，setup git pre-commit and gitignore option:

	6.1 setup pre-commit:

		6.1.1 $ cd $SRCROOT/.git/hooks

		6.1.2 $ vim pre-commit

		6.1.3 $ copy code below:

			```
			PATH=$PATH:/usr/local/bin:/usr/local/sbin
			#!/usr/bin/env sh

			xunique $HOME/Documents/Gitee/MultiEducation/MultiEducation.xcodeproj
			xunique $HOME/Documents/Gitee/MultiEducation/MultiEducation/Pods/Pods.xcodeproj
			```
		6.1.4 $ :wq 
		
	6.2 setup gitignore option:

		6.2.1 step1: git rm -rf --cached MultiEducation.xcodeproj/userdata/

		6.2.2 step2: git rm -rf --cached MultiEducation.xcworkspace/userdata/

		6.2.3 step3: git rm -rf --cached Pods/Pods.xcodeproj/userdata/

		6.2.4 step4: add 

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

### 7, when you submit you change-codes to gitee, follow steps below:

		7.1, commit your changes on your local master
		
		7.2, pull remote codes and push your local to remote repo !

