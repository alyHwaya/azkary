//
//  detailViewController.swift
//  azkary
//
//  Created by aly hassan on 13/09/2021.
//

import UIKit
import FBSDKCoreKit
import GoogleMobileAds

class detailViewController: UIViewController {

    
    @IBOutlet weak var bannerDown: GADBannerView!
    @IBOutlet weak var bannerUp: GADBannerView!
    var myKvPairs : KeyValuePairs =  ["":1]


    
    var currentZekrIndex = 0
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var reps: UILabel!
    var currentRep = 1
    @IBOutlet weak var zekrTxtVw: UITextView!
    @IBAction func nextBtnAct(_ sender: Any) {
        AppEvents.logEvent(.completedTutorial)
        nextZekr()
    }
    @IBAction func previousBtnAct(_ sender: Any) {
        currentZekrIndex -= 1
        if currentZekrIndex < 0{
            currentZekrIndex = 0
        }
        updateScreen()
    }
    
    func nextZekr(){
        currentZekrIndex += 1
        if currentZekrIndex == myKvPairs.count{
            currentZekrIndex = myKvPairs.count - 1
        }
        updateScreen()
    }
    func updateScreen(){
        currentRep = myKvPairs[currentZekrIndex].value
        reps.text = "\(currentRep)"
        zekrTxtVw.text = myKvPairs[currentZekrIndex].key
    }
    
    @IBAction func repsBtnAct(_ sender: Any) {
        currentRep -= 1
        reps.text = "\(currentRep)"
        if currentRep == 0 {
            nextZekr()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bannerUp.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerUp.rootViewController = self
        bannerUp.load(GADRequest())
        
        bannerDown.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerDown.rootViewController = self
        bannerDown.load(GADRequest())
        updateScreen()
        
        // Do any additional setup after loading the view.
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
    
   

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
