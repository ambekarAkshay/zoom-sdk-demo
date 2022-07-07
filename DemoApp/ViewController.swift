//
//  ViewController.swift
//  DemoApp
//
//  Created by Ambekar, Akshay on 7/4/22.
//

import UIKit
import MobileRTC

class ViewController: UIViewController {
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MobileRTC.shared().setMobileRTCRootController(self.navigationController)
        NotificationCenter.default.addObserver(self, selector: #selector(userLoggedIn), name: NSNotification.Name(rawValue: "userLoggedIn"), object: nil)
    }

    // MARK: - IBOutlets

    @IBAction func joinAMeetingButtonPressed(_ sender: Any) {
        presentJoinMeetingAlert()
    }

    @IBAction func startAnInstantMeetingButtonPressed(_ sender: Any) {
        if let authorizationService = MobileRTC.shared().getAuthService(), authorizationService.isLoggedIn() {
            startMeeting()
        } else {
            presentLogInAlert()
        }
    }

    // MARK: - Zoom SDK Examples
    func joinMeeting(meetingNumber: String, meetingPassword: String) {
        if let meetingService = MobileRTC.shared().getMeetingService() {

            meetingService.delegate = self
            let joinMeetingParameters = MobileRTCMeetingJoinParam()
            joinMeetingParameters.meetingNumber = meetingNumber
            joinMeetingParameters.password = meetingPassword
            
            meetingService.joinMeeting(with: joinMeetingParameters)
        }
    }

    func logIn(email: String, password: String) {
        if let authorizationService = MobileRTC.shared().getAuthService() {
            // Call the login function in MobileRTCAuthService. This will attempt to log in the user.
            //authorizationService.login(withEmail: email, password: password, rememberMe: false)
        }
    }

    func startMeeting() {
        if let meetingService = MobileRTC.shared().getMeetingService() {
            meetingService.delegate = self
            let startMeetingParameters = MobileRTCMeetingStartParam4LoginlUser()
            meetingService.startMeeting(with: startMeetingParameters)
        }
    }

    // MARK: - Convenience Alerts

    func presentJoinMeetingAlert() {
        let alertController = UIAlertController(title: "Join meeting", message: "", preferredStyle: .alert)

        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Meeting number"
            textField.keyboardType = .phonePad
        }
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Meeting password"
            textField.keyboardType = .asciiCapable
            textField.isSecureTextEntry = true
        }

        let joinMeetingAction = UIAlertAction(title: "Join meeting", style: .default, handler: { alert -> Void in
            let numberTextField = alertController.textFields![0] as UITextField
            let passwordTextField = alertController.textFields![1] as UITextField

            if let meetingNumber = numberTextField.text, let password = passwordTextField.text {
                self.joinMeeting(meetingNumber: meetingNumber, meetingPassword: password)
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action : UIAlertAction!) -> Void in })

        alertController.addAction(joinMeetingAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }

    func presentLogInAlert() {
        let alertController = UIAlertController(title: "Log in", message: "", preferredStyle: .alert)

        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Email"
            textField.keyboardType = .emailAddress
        }
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Password"
            textField.keyboardType = .asciiCapable
            textField.isSecureTextEntry = true
        }

        let logInAction = UIAlertAction(title: "Log in", style: .default, handler: { alert -> Void in
            let emailTextField = alertController.textFields![0] as UITextField
            let passwordTextField = alertController.textFields![1] as UITextField

            if let email = emailTextField.text, let password = passwordTextField.text {
                self.logIn(email: email, password: password)
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action : UIAlertAction!) -> Void in })

        alertController.addAction(logInAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }

    // MARK: - Internal
    @objc func userLoggedIn() {
        startMeeting()
    }
}


// MARK: - MobileRTCMeetingServiceDelegate
extension ViewController: MobileRTCMeetingServiceDelegate {

    func onMeetingError(_ error: MobileRTCMeetError, message: String?) {
        switch error {
        case .success:
            print("Successful meeting operation.")
        case .passwordError:
            print("Could not join or start meeting because the meeting password was incorrect.")
        default:
            print("MobileRTCMeetError: \(error) \(message ?? "")")
        }
    }

    func onJoinMeetingConfirmed() {
        print("Join meeting confirmed.")
    }

    func onMeetingStateChange(_ state: MobileRTCMeetingState) {
        print("Current meeting state: \(state)")
    }
}
