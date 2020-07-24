# Huawei Analytics Kit Tutorial with Flutter

This project was developed to inform how to use Huawei Analytics Kit on Flutter. 


## Before you run the project

1. Create an app in AppGallery Connect and obtain the project configuration file **agconnect-services.json**. Before obtaining the agconnect-services.json file, ensure that HUAWEI Analytics Kit has been enabled. In Android Studio, move the agconnect-services.json file to the root directory of the app.

2. Change the value of **applicationId** in the **build.gradle** file of the app to the name of the app package applied for in the preceding step.

3. Create key.properties file in '**android/app**' folder and add your signing configs in it.
```
storeFile file('<keystore_file>.jks')
storePassword '<keystore_password>'
keyAlias '<key_alias>'
keyPassword '<key_password>'
```
