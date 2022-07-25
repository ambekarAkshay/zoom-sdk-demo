# Zoom iOS Software Development Kit (SDK)
<div align="center">
<img src="https://camo.githubusercontent.com/f819328f236e10c1a0bb7a157f34c2e141150285adbd38757ffc3af4ec824158/68747470733a2f2f73332e616d617a6f6e6177732e636f6d2f757365722d636f6e74656e742e73746f706c696768742e696f2f383938372f31353431303133303633363838" width="400px" max-height="400px" style="margin:auto;"/>
</div>

## Index
1. [Zoom SDK integration in your app](#zoom-sdk-integration-in-your-app)
   - [Prerequisites](#prerequisites)
   - [SDK integration in your app](#sdk-integration-in-your-app)
   - [To join a Meeting](#to-join-a-meeting)
   - [To start a new Meeting](#to-start-a-new-meeting)
   - [Customized In-Meeting UI](#customized-in-meeting-ui)
2. [Zoom SDK integration in your **Healthcare app using EPIC**](#zoom-sdk-integration-in-your-healthcare-app-by-using-epic)
   - [Prerequisites for the Epic integration](#prerequisites-for-the-epic-integration)
   - [Adding Epic from the Zoom Marketplace](#adding-epic-from-the-zoom-marketplace)
   - [Configure Epic](#configure-epic)
---

# **Zoom SDK integration in your app**

## **Prerequisites**

### •	Download zoom SDK 
1. Login to the  **[Zoom App Marketplace](https://marketplace.zoom.us/)** using your Zoom account
2. Click the **Develop** option in the dropdown on the top-right corner and select **Build App**. 
3. Next, click the **Create** button and provide the required details if you haven't already created an SDK app. If you previously created an SDK app on theMarketplace, click the **View here** option and navigate to the Download page. Click iOS to download the iOS SDK.

<img width="500px" max-height="500px" alt="68747470733a2f2f73332d75732d776573742d312e616d617a6f6e6177732e636f6d2f73646b2e7a6f6f6d2e75732f6d6b742d30322e706e67" src="https://user-images.githubusercontent.com/108523446/180263815-1d0bcab5-3e6b-4b7a-93c6-7af9d468973b.png">

 
### •	SDK key & Secret

After downloading SDK, go to App Credentials [(SDK key & Secret)](https://marketplace.zoom.us/docs/sdk/native-sdks/auth/#get-sdk-key-and-secret) where you will find your SDK Key and Secret.


## **SDK integration in your app**

Refer [here](https://marketplace.zoom.us/docs/sdk/native-sdks/iOS/build-an-app "Build a Zoom meeting app") to Integrate Zoom SDK in your app

 Handles the initialization and authentication of the Zoom SDK in **AppDelegate.swift**

    let context = MobileRTCSDKInitContext()

    // The domain we will use is zoom.us
    context.domain = "zoom.us"

    // Turns on SDK logging. This is optional.
    context.enableLog = true

    // Call initialize(_ context: MobileRTCSDKInitContext) to create an instance of the Zoom SDK. Without initialization, the SDK will not be operational. This call will return true if the SDK was initialized successfully.        
    let sdkInitializedSuccessfully = MobileRTC.shared().initialize(context)

    // Check if initialization was successful. Obtain a MobileRTCAuthService, this is for supplying credentials to the SDK for authorization
    if sdkInitializedSuccessfully == true, let authorizationService = MobileRTC.shared().getAuthService() {
    
        // Supply the SDK with SDK Key and SDK Secret.
        // To use a JWT instead, replace these lines with authorizationService.jwtToken = yourJWTToken.
        'authorizationService.clientKey = sdkKey
        authorizationService.clientSecret = sdkSecret
        
        // Assign AppDelegate to be a MobileRTCAuthDelegate to listen for authorization callbacks.
        authorizationService.delegate = self
        
        // Call sdkAuth to perform authorization.
        authorizationService.sdkAuth()
    }


### **To join a Meeting**

    /// - Parameters:
    ///   - meetingNumber: The meeting number of the desired meeting.
    ///   - meetingPassword: The meeting password of the desired meeting.
    /// - Precondition:
    ///   - Zoom SDK must be initialized and authorized.
    ///   - MobileRTC.shared().setMobileRTCRootController() has been called.
    
    func joinMeeting(meetingNumber: String, meetingPassword: String) {
        // Obtain the MobileRTCMeetingService from the Zoom SDK, this service can start meetings, join meetings, leave meetings, etc.

        if let meetingService = MobileRTC.shared().getMeetingService() {
            // Set the ViewController to be the MobileRTCMeetingServiceDelegate
            meetingService.delegate = self
            
            // Create a MobileRTCMeetingJoinParam to provide the MobileRTCMeetingService with the necessary info to join a meeting.
            // In this case, we will only need to provide a meeting number and password.
            let joinMeetingParameters = MobileRTCMeetingJoinParam()
            joinMeetingParameters.meetingNumber = meetingNumber
            joinMeetingParameters.password = meetingPassword
            
            // Call the joinMeeting function in MobileRTCMeetingService. The Zoom SDK will handle the UI for you, unless told otherwise.
            // If the meeting number and meeting password are valid, the user will be put into the meeting. A waiting room UI will be presented or the meeting UI will be presented.
            meetingService.joinMeeting(with: joinMeetingParameters)
        }
    }
    
   **Note:** To join meeting using meeting URL we have fetch meeting number and password by parsing meeting URL and then we can use above method to join meeting.



### **To start a new Meeting**

Zoom meetings and webinars can be started with your [SDK JWT](https://marketplace.zoom.us/docs/sdk/native-sdks/auth/#generate-the-sdk-jwt) and a [User Zoom Access Key (ZAK) token](https://marketplace.zoom.us/docs/sdk/native-sdks/auth/#get-a-users-zak-token).

    func startMeetingZak() {
            if let meetingService = MobileRTC.shared().getMeetingService() {
                meetingService.delegate = self
                let startMeetingParams = MobileRTCMeetingStartParam4WithoutLoginUser()
                startMeetingParams.zak = // TODO: Enter ZAK
                startMeetingParams.userID = // TODO: Enter userID
                startMeetingParams.userName = // TODO: Enter your name
                meetingService.startMeeting(with: startMeetingParams)
            }
        }



### **MobileRTCMeetingService Delegate Methods**
MobileRTCMeetingServiceDelegate listens to updates about meetings, such as meeting state changes, join attempt status, meeting errors, etc.
      
      // Is called upon in-meeting errors, join meeting errors, start meeting errors, meeting connection errors, etc.
      func onMeetingError(_ error: MobileRTCMeetError, message: String?) {
        print("Meeting error: (error), message: (String(describing: message))")
      }
      
      // Is called when the user joins a meeting.
      func onJoinMeetingConfirmed() {
        print("Join meeting confirmed.")
      }
      
      // Is called upon meeting state changes.
      func onMeetingStateChange(_ state: MobileRTCMeetingState) {
        print("Current meeting state: (state)")
      }

### **Customized In-Meeting UI**
### •	Enable Custom Meeting UI
To use your custom meeting UI, firstly you need to enable it before you want to start or join a meeting using the following:

      [[MobileRTC sharedRTC] getMeetingSettings].enableCustomMeeting = YES
      
Once the custom meeting UI feature is enabled, then starting or joining a meeting is the same as [To join a Meeting](#to-join-a-meeting), [To start a new Meeting](#to-start-a-new-meeting)

### •	Create Custom Meeting UI
### Assign Customized UI Meeting Delegate
   To implement custom meeting UI, firstly, you need to assign MobileRTCCustomizedUIMeetingDelegate to your StartJoinMeetingPresenter(Meeting View)
   
      #import "SDKStartJoinMeetingPresenter.h"
      
      @interface SDKStartJoinMeetingPresenter (CustomizedUIMeetingDelegate)<MobileRTCCustomizedUIMeetingDelegate>
      
      @end
      
   Then, in your StartJoinMeetingPresenter.m file, implements the following two functions:

      @implementation SDKStartJoinMeetingPresenter (CustomizedUIMeetingDelegate)

      - (void)onInitMeetingView
      {
        // Create & Present View Controller
        NSLog(@"onInitMeetingView....");

        CustomMeetingViewController *vc = [[CustomMeetingViewController alloc] init];
        self.customMeetingVC = vc;
        [vc release];

        [self.rootVC addChildViewController:self.customMeetingVC];
        [self.rootVC.view addSubview:self.customMeetingVC.view];
        [self.customMeetingVC didMoveToParentViewController:self.rootVC];

        self.customMeetingVC.view.frame = self.rootVC.view.bounds;
        ...
      }

      - (void)onDestroyMeetingView
      {
        // Remove & Dismiss View Controller
        NSLog(@"onDestroyMeetingView....");

        NSLog(@"onDestroyMeetingView....");

        [self.customMeetingVC willMoveToParentViewController:nil];
        [self.customMeetingVC.view removeFromSuperview];
        [self.customMeetingVC removeFromParentViewController];
        self.customMeetingVC = nil;
        ...
      }

**Note:** See [UI Legal Notices](https://marketplace.zoom.us/docs/sdk/native-sdks/ui-notices) for Zoom legal notices and how to display them in your app.

# **Zoom SDK integration in your Healthcare app by using EPIC**

## Prerequisites for the Epic integration
- A paid Zoom account
- A Zoom user with a Pro license that will be used as the “Default Host” for telehealth meetings
- Pro licenses available for each provider that will make telehealth calls
- The **[Join Before Host](https://support.zoom.us/hc/en-us/articles/202828525)** and **[Waiting Room](https://support.zoom.us/hc/en-us/articles/115000332726)** features can't be locked at the account level
- Account owner or admin privileges to add and configure, plus contact with your Epic technical representative


## How to add and configure the Epic integration

### Adding Epic from the Zoom Marketplace
1. Sign in to the **[Zoom App Marketplace](https://marketplace.zoom.us/)** with your Zoom account.
2. In the top-right corner, search for **Epic** and click the app.
**Note:** If the app is not pre-approved, contact your Zoom admin to approve this app for your account.
3. Click **Add**.
4. Confirm the permissions the app requires, then click **Allow**.
An admin on your Epic account will need to complete the following steps for configuration.

### Configure Epic
**Note:** In order to obtain some of the configuration information, you will need to be in contact with your Epic technical representative for help on building the FDR links and workflow.

1. Sign in to the Zoom App Marketplace with your Zoom developer account.
2. In the top-right corner, click **Manage**.
3. In the navigation menu, click **Created Apps**.
4. Click your developer.zoom.us API (JWT).
5. Click **App credentials**.
6. Copy your **API Key** and **API Secret** for use in a later step.
7. Once you have added the Epic app, configure the required fields. Refer [here](https://support.zoom.us/hc/en-us/articles/115002222603-Epic-Integration)

