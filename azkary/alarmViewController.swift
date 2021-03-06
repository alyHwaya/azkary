//
//  alarmViewController.swift
//  azkary
//
//  Created by aly hassan on 14/09/2021.
//

import UIKit
import UserNotifications
import GoogleMobileAds

class alarmViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var bannerDown: GADBannerView!
    @IBOutlet weak var bannerUp: GADBannerView!
    @IBOutlet weak var logo: UIImageView!
    let timePicker = UIDatePicker()
    var currentTxtFld = UITextField()
    var selectedMorningDef = String()
    var selectedNightDef = String()
    var selectedMorningAlarm = Date()
    var selectedNightAlarm = Date()
    @IBOutlet weak var morningTxtV: UITextField!
    @IBOutlet weak var nightTxtV: UITextField!
    @IBAction func morningSwitchAct(_ sender: Any) {
        if morningSwitchOut.isOn{
            defaults.setValue(morningTxtV.text!, forKey: "morningAlarm")
            defaults.setValue(true, forKey: "morningAlarmOn")
            setNotification(id: "morning", time: stringToDate(str: morningTxtV.text!))
        }else{
            defaults.setValue(false, forKey: "morningAlarmOn")
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: ["morning"])
            center.removeDeliveredNotifications(withIdentifiers: ["morning"])
        }
    }
    @IBAction func nightSwitchAct(_ sender: Any) {
        if nightSwitchOut.isOn{
            defaults.setValue(nightTxtV.text!, forKey: "nightAlarm")
            defaults.setValue(true, forKey: "nightAlarmOn")
            setNotification(id: "night", time: stringToDate(str: nightTxtV.text!))
        }else{
            defaults.setValue(false, forKey: "nightAlarmOn")
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: ["night"])
            center.removeDeliveredNotifications(withIdentifiers: ["night"])
        }
    }
    @IBOutlet weak var morningSwitchOut: UISwitch!
    @IBOutlet weak var nightSwitchOut: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        bannerUp.adUnitID = "ca-app-pub-9037650239384734/5363519737"
        bannerUp.rootViewController = self
        bannerUp.load(GADRequest())
        
        bannerDown.adUnitID = "ca-app-pub-9037650239384734/1145073121"
        bannerDown.rootViewController = self
        bannerDown.load(GADRequest())
        hideKeyboardWhenTappedAround()
        prepareDatePicker()
        prepareTxtFlds()
        prepareSwitches()
        checkForNotificationAuth()
        selectedNightAlarm = stringToDate(str: nightTxtV.text ?? "00:00")
        selectedMorningAlarm = stringToDate(str: morningTxtV.text ?? "00:00")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let move = UtilFun.makeTransform(vw: logo, scaleX: 4, scaleY: 4, translationX: 0, translationY: 0)
        UIView.animate(withDuration: 0.7, animations: {
            self.logo.transform = move
            
        })
        let move2 = UtilFun.makeTransform(vw: logo, scaleX: 0.25, scaleY: 0.25, translationX: 0, translationY: 0)
        UIView.animate(withDuration: 0.7, animations: {
            self.logo.transform = move2
            
        })
        
        
    }
    
    
    func checkForNotificationAuth(){
        UNUserNotificationCenter.current().getNotificationSettings(){ (settings) in

                switch settings.alertSetting{
                case .enabled:
                    print("enabled")
                    //Permissions are granted

                case .disabled:
                    print("disabled")
                    DispatchQueue.main.async {
                        self.mySimpleAlert()
                    }

                case .notSupported:
                    print("notSupported")
                    self.requestNotificationAuth()
                    

                    //The application does not support this notification type
                @unknown default:
                    print("Un known error")
                }
            }
    }
    
    func requestNotificationAuth(){
        UNUserNotificationCenter.current().requestAuthorization(options:
                  [[.alert, .sound, .badge]],
                      completionHandler: { (granted, error) in
                  // Handle Error
              })
    }
    
      
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentTxtFld = textField
        timePicker.date = Date(timeIntervalSinceNow: 0)
        print("-------------------------------")
    }
    
    func prepareDatePicker(){
        timePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
        timePicker.datePickerMode = .time
    }
    
    func prepareTxtFlds(){
        morningTxtV.delegate = self
        nightTxtV.delegate = self
        morningTxtV.inputView = timePicker
        nightTxtV.inputView = timePicker
        morningTxtV.tag = 1
        nightTxtV.tag = 2
        let strDate = dateToStr(myDate: Date(timeIntervalSinceNow: 0))
        if let morningTimeDef = defaults.value(forKey: "morningAlarm"){
            morningTxtV.text = morningTimeDef as? String
        }else{
            morningTxtV.text = strDate
        }
        if let nightTimeDef = defaults.value(forKey: "nightAlarm"){
            nightTxtV.text = nightTimeDef as? String
        }else{
            nightTxtV.text = strDate
        }
    }
    
    func prepareSwitches(){
        if let morningOn = defaults.value(forKey: "morningAlarmOn"){
            if morningOn as! Bool {
                morningSwitchOut.setOn(true, animated: true)
            }else{
                morningSwitchOut.setOn(false, animated: true)
            }
        }else{
            morningSwitchOut.setOn(false, animated: true)
            defaults.setValue(false, forKey: "morningAlarmOn")
        }
        
        if let nightOn = defaults.value(forKey: "nightAlarmOn"){
            if nightOn as! Bool {
                nightSwitchOut.setOn(true, animated: true)
            }else{
                nightSwitchOut.setOn(false, animated: true)
            }
        }else{
            nightSwitchOut.setOn(false, animated: true)
            defaults.setValue(false, forKey: "nightAlarmOn")
        }
        
        
    }
    @objc func datePickerChanged(sender:UIDatePicker) {
        currentTxtFld.text = dateToStr(myDate: sender.date)
        if (currentTxtFld.tag == 1 && morningSwitchOut.isOn){
            defaults.setValue(dateToStr(myDate: sender.date), forKey: "morningAlarm")
            selectedMorningAlarm = sender.date
            morningSwitchOut.setOn(false, animated: true)
        }else if (currentTxtFld.tag == 2 && nightSwitchOut.isOn){
            defaults.setValue(dateToStr(myDate: sender.date), forKey: "nightAlarm")
            selectedNightAlarm = sender.date
            nightSwitchOut.setOn(false, animated: true)
        }
        print(currentTxtFld)
      }
    
    func dateToStr(myDate: Date) -> String{
        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .full
        dateFormatter.dateFormat = "HH:mm"
        let stringDate = dateFormatter.string(from: myDate)
        print(stringDate)
        return stringDate
    }
    
    func stringToDate(str: String) -> Date{
        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "HH:mm"
        let tempDate : Date = Date(timeIntervalSinceNow: 0)
        let date = dateFormatter.date(from:str) ?? tempDate
        return date
    }
    
    func mySimpleAlert(){
        let alert = UIAlertController(title: "?????? ??????????", message: "?????????????????? ?????? ??????????. ?????????? ?????????????? ???? ?????????????? ????????????????", preferredStyle: .alert)
        let cancelBtn = UIAlertAction(title: "??????????", style: .cancel, handler: nil)
        let okBtn = UIAlertAction(title: "??????????", style: .default, handler: {
        _ in
            DispatchQueue.main.async {
                if let bundleIdentifier = Bundle.main.bundleIdentifier, let appSettings = URL(string: UIApplication.openSettingsURLString + bundleIdentifier) {
                    if UIApplication.shared.canOpenURL(appSettings) {
                        UIApplication.shared.open(appSettings)
                    }
                }
            }
        })
        alert.addAction(okBtn)
        alert.addAction(cancelBtn)
        self.present(alert, animated: true, completion: {
          print("do anything after completion")
            //
        })
    }
    
    func setNotification(id: String, time: Date) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [id])
        center.removeDeliveredNotifications(withIdentifiers: [id])
        
        let content = UNMutableNotificationContent()
        content.title = "Meeting Reminder"
        content.subtitle = dateToStr(myDate: time)
        content.body = id
        content.sound = .default
        content.badge = 2
        
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: time)
        let minute = calendar.component(.minute, from: time)
        print("hour------------ \(hour)")
        print("minute------------ \(minute)")
        var datComp = DateComponents()
        datComp.hour = hour
        datComp.minute = minute
        let trigger = UNCalendarNotificationTrigger(dateMatching: datComp, repeats: true)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
                        UNUserNotificationCenter.current().add(request) { (error : Error?) in
                            if let theError = error {
                                print(theError.localizedDescription)
                            }
                        }

//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 15,
//                repeats: false)
//
//        let requestIdentifier = "demoNotification"
//        let request = UNNotificationRequest(identifier: requestIdentifier,
//            content: content, trigger: trigger)
//
//        UNUserNotificationCenter.current().add(request,
//            withCompletionHandler: { (error) in
//                // Handle error
//        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
