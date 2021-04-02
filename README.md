# 前情提示(升级 flutter 版本的方法)

1.去官网下载指定版本,比如我这个 bilibiliapp 选择 2.0 stable 版本
https://flutter.dev/docs/development/tools/sdk/releases

2.将下载好的 flutter 放在自己电脑的目录下
比如我的
C:\flutter

3.在 android studio 里分别设置自己的 flutter-sdk 和 dart-sdk(在这里它会自动显示版本号)
比如我的
flutter:C:\flutter
dart:C:\flutter\bin\cache\dart-sdk

4.为避免特别慢,特别建议两个地方更改阿里链接(但最新版的 gradle4.1.0 下面映像没有,所以到了这里下面都不用设置,直接运行即可.)
第一个地方:自己电脑里,比如我:C:\flutter\packages\flutter_tools\gradle\flutter.gradle

```js
   //jcenter()
        // maven {
        //     url 'https://dl.google.com/dl/android/maven2'
        // }
        maven{
            url 'https://maven.aliyun.com/repository/jcenter'
        }
        maven{
            url 'http://maven.aliyun.com/nexus/content/groups/public'
        }
```

第二个地方:项目里,在 android\build.gradle

```js
buildscript {
    repositories {
        //  google()
        //  jcenter()
        maven { url 'https://maven.aliyun.com/repository/google' }
        maven { url 'https://maven.aliyun.com/repository/jcenter' }
        maven { url 'http://maven.aliyun.com/nexus/content/groups/public'}
        }
        dependencies {
        classpath 'com.android.tools.build:gradle:3.1.2'
    }
}

allprojects {
    repositories {
        // google()
        // jcenter()
        maven { url 'https://maven.aliyun.com/repository/google' }
        maven { url 'https://maven.aliyun.com/repository/jcenter' }
        maven { url 'http://maven.aliyun.com/nexus/content/groups/public' }
    }
}
```

遇到的坑,最新版的 gradle4.1.0 上面映像没有,所以不适用.

5.运行如果有 gradle 错误的解决办法
找到 C:\Users\91583\Downloads\fa-net-master (2)\fa-net\android\gradle\wrapper\

去官网下载上面版本的 gradle,地址:https://gradle.org/releases/
然后找到自己电脑文件里的 gradle 解压替换即可,比如我的:C:\Users\91583\.gradle\wrapper\dists\gradle-6.7-all
