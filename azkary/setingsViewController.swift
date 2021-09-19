//
//  setingsViewController.swift
//  azkary
//
//  Created by aly hassan on 16/09/2021.
//

import UIKit
import StoreKit
import GoogleMobileAds

class setingsViewController: UIViewController {
    @IBOutlet weak var bannerDown: GADBannerView!
    @IBOutlet weak var bannerUp: GADBannerView!
    enum AppStoreReviewManager {
        static func requestReviewIfAppropriate() {
            SKStoreReviewController.requestReview()
        }
    }
    @IBAction func shareBtnAct(_ sender: Any) {
        sharingStuff(myUrlStr: "https://google.com")
    }
    @IBAction func sendReview(_ sender: Any) {
        DispatchQueue.main.async {
            AppStoreReviewManager.requestReviewIfAppropriate()
        }
    }
    @IBOutlet weak var logo: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        bannerUp.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerUp.rootViewController = self
        bannerUp.load(GADRequest())
        
        bannerDown.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerDown.rootViewController = self
        bannerDown.load(GADRequest())

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
    
    func sharingStuff(myUrlStr: String){
        // if you want to share image, messege and url
        //        let myImage = UIImage(named: "copy.png")
        let myMsg = "السلام عليكم - أعجبني هذا التطبيق  ٠"
        let myUrl = URL(string: myUrlStr)
        //        let share = [myImage!, myMsg, myUrl!] as [Any]
        
        // but I will share only url
        let share = [myMsg, myUrl!] as [Any]
        let activityViewController = UIActivityViewController(activityItems: share, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
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
