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
        sharingStuff(myUrlStr: "https://apps.apple.com/qa/app/%D8%A7%D8%B0%D9%83%D8%A7%D8%B1-%D8%A7%D9%84%D8%B5%D8%A8%D8%A7%D8%AD-%D9%88-%D8%A7%D9%84%D9%85%D8%B3%D8%A7%D8%A1-%D8%A3%D8%B0%D9%83%D8%A7%D8%B1%D9%83/id1586125732")
    }
    @IBAction func sendReview(_ sender: Any) {
        DispatchQueue.main.async {
            AppStoreReviewManager.requestReviewIfAppropriate()
        }
    }
    @IBOutlet weak var logo: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        bannerUp.adUnitID = "ca-app-pub-9037650239384734/4560384586"
        bannerUp.rootViewController = self
        bannerUp.load(GADRequest())
        
        bannerDown.adUnitID = "ca-app-pub-9037650239384734/7688083135"
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
