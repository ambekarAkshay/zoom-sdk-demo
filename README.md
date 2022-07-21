# **Initialize the SDK**


## **Prerequisites**

### •	Download zoom SDK 
Login to the  **[Zoom App Marketplace](https://marketplace.zoom.us/)** using your Zoom account, click the Develop option in the dropdown on the top-right corner and select Build App. Next,   click the Create button and provide the required details if you haven't already created an SDK app. If you previously created an SDK app on theMarketplace, click the View here option and navigate to the Download page. Click iOS to download the iOS SDK.

<img width="1024" height="500" alt="68747470733a2f2f73332d75732d776573742d312e616d617a6f6e6177732e636f6d2f73646b2e7a6f6f6d2e75732f6d6b742d30322e706e67" src="https://user-images.githubusercontent.com/108523446/180263815-1d0bcab5-3e6b-4b7a-93c6-7af9d468973b.png">

 
### •	SDK key & Secret 

Generate access credentials **[(SDK key & Secret)](https://marketplace.zoom.us/docs/sdk/native-sdks/auth/#get-sdk-key-and-secret)**
After completing the SDK App setup, go to App Credentials where you will find your SDK Key and Secret.

Refer [here](https://marketplace.zoom.us/docs/sdk/native-sdks/iOS/build-an-app "Build a Zoom meeting app") to Integrate Zoom SDK in your app


AppDelegate.swift

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
    authorizationService.clientKey = sdkKey
    authorizationService.clientSecret = sdkSecret
    // Assign AppDelegate to be a MobileRTCAuthDelegate to listen for authorization callbacks.
    authorizationService.delegate = self
    // Call sdkAuth to perform authorization.
    authorizationService.sdkAuth()
    }


Join a Meeting

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


Start a Meeting

    func startMeetingZak() {
            if let meetingService = MobileRTC.shared().getMeetingService() {
                meetingService.delegate = self
                let startMeetingParams = MobileRTCMeetingStartParam4WithoutLoginUser()
                startMeetingParams.zak = "" // TODO: Enter ZAK
                startMeetingParams.userID = "" // TODO: Enter userID
                startMeetingParams.userName = "" // TODO: Enter your name
                meetingService.startMeeting(with: startMeetingParams)
            }
        }


Delegate Methods

      // MobileRTCMeetingServiceDelegate listens to updates about meetings, such as meeting state changes, join attempt status, meeting errors, etc.
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
