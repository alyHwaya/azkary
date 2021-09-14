//
//  alarmViewController.swift
//  azkary
//
//  Created by aly hassan on 14/09/2021.
//

import UIKit

class alarmViewController: UIViewController, UITextFieldDelegate {

    let timePicker = UIDatePicker()
    var currentTxtFld = UITextField()
    var selectedMorningDef = String()
    var selectedNightDef = String()
    @IBOutlet weak var morningTxtV: UITextField!
    @IBOutlet weak var nightTxtV: UITextField!
    @IBAction func morningSwitchAct(_ sender: Any) {
        if morningSwitchOut.isOn{
            defaults.setValue(morningTxtV.text!, forKey: "morningAlarm")
            defaults.setValue(true, forKey: "morningAlarmOn")
        }else{
            defaults.setValue(false, forKey: "morningAlarmOn")
        }
    }
    @IBAction func nightSwitchAct(_ sender: Any) {
        if nightSwitchOut.isOn{
            defaults.setValue(nightTxtV.text!, forKey: "nightAlarm")
            defaults.setValue(true, forKey: "nightAlarmOn")
        }else{
            defaults.setValue(false, forKey: "nightAlarmOn")
        }
    }
    @IBOutlet weak var morningSwitchOut: UISwitch!
    @IBOutlet weak var nightSwitchOut: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        prepareDatePicker()
        prepareTxtFlds()
        prepareSwitches()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentTxtFld = textField
        timePicker.date = Date()
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
        let strDate = formateTheDate(myDate: Date())
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
        currentTxtFld.text = formateTheDate(myDate: sender.date)
        if (currentTxtFld.tag == 1 && morningSwitchOut.isOn){
            defaults.setValue(formateTheDate(myDate: sender.date), forKey: "morningAlarm")
        }else if (currentTxtFld.tag == 2 && nightSwitchOut.isOn){
            defaults.setValue(formateTheDate(myDate: sender.date), forKey: "nightAlarm")
        }
        print(currentTxtFld)
      }
    
    func formateTheDate(myDate: Date) -> String{
        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .full
        dateFormatter.dateFormat = "h:mm a"
        let stringDate = dateFormatter.string(from: myDate)
        print(stringDate)
        return stringDate
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
