//
//  UtilFun.swift
//  moled
//
//  Created by aly hassan on 12/02/2021.
//

import Foundation
import UIKit
import Network
let defaults = UserDefaults.standard
let monitor = NWPathMonitor()
var isInternetConnected = true
// http://clothesshopapi2.azurewebsites.net/img/products/
// "http://hwayadesigns-001-site3.itempurl.com/img/products/"
class UtilFun{
    // oooo
    public static func midlineHorizontalRect(superView: UIView, widthToScreen : CGFloat, heightToWidth: CGFloat, yToScreen : CGFloat, midLineVertical : Bool) -> CGRect{
        let scrWidth = superView.frame.size.width
        let scrHeight = superView.frame.size.height
        let vwWidth = scrWidth * widthToScreen
        let rectX = scrWidth/2 - vwWidth/2
        let rectHeight = vwWidth * heightToWidth
        var rectY = scrHeight * yToScreen
        if midLineVertical {
            rectY = scrHeight/2 - rectHeight/2
        }
        let theRect = CGRect(x: rectX, y: rectY, width: vwWidth, height: rectHeight)
        
        return theRect
    }
    
    public static  func makeTransform(vw: UIView, scaleX : CGFloat, scaleY : CGFloat, translationX : CGFloat, translationY : CGFloat) -> CGAffineTransform{
        
        let originalTransformVw = vw.transform
        let scaledTransformVw = originalTransformVw.scaledBy(x: scaleX, y: scaleY)
        let scaledAndTranslatedTransformVw = scaledTransformVw.translatedBy(x: translationX, y: translationY)
        return scaledAndTranslatedTransformVw
    }
    
    public static func registerWithApi(urlStr : String, dic : Dictionary<String, String>) -> String{
        
        var result = ""
        if defaults.value(forKey: "netConnection") as! Bool{
        let jsonData = try! JSONSerialization.data(withJSONObject: dic, options: [])
        let session = URLSession.shared
        let url = URL(string: urlStr)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = session.uploadTask(with: request, from: jsonData)  { data, response, error in
            // Do something...
            print(data)
            let statusCode = (response as! HTTPURLResponse).statusCode
            if statusCode != 200 {
            print("The status is: \(statusCode)")
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print(dataString)
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                var jsonAsDic = [String : Any]()
                var ModelState = [String : [String]]()
                jsonAsDic = json as! [String : Any]
                ModelState = jsonAsDic["ModelState"] as! [String : [String]]
                let msg = ModelState[""]?[1]
                result = msg ?? "Something went wrong!"
                print("The json \(String(describing: msg))")
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
            }else{
                result = "Yup, You registered successfuly!"
            }
            print(error)
        }
        task.resume()
    }else{
        UtilFun.simpleAlertActionSheet(title: "", msg: "You need internet connection!", sender: self)
    }
        return result
        
    }
    public static   func printFonts() {
        let fontFamilyNames = UIFont.familyNames
        for familyName in fontFamilyNames {
            print("------------------------------")
            print("Font Family Name = [\(familyName)]")
            let names = UIFont.fontNames(forFamilyName: familyName)
            print("Font Names = [\(names)]")
        }
    }
    
    public static func monitorInternet(sender : UIViewController){
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                DispatchQueue.main.async {
                    //self.wifiSignal.image = UIImage(named: "wifi.png")
                    if !isInternetConnected{
                    simpleAlertActionSheet(title: "Internet connection OK", msg: "", sender: sender)
                        isInternetConnected = true
                    }
//                    if sender == homeViewController(){
//                        let vc  = homeViewController()
//                        vc.getDataFromApi()
//                    }
//                    if sender == loggedOutViewController(){
//                        let vc  = loggedOutViewController()
//                        vc.logOut()
//
//                    }
                }
                defaults.set(true, forKey: "netConnection")
                
            } else if path.status == .unsatisfied{
                print("No connection.")

                DispatchQueue.main.async {
                    //self.wifiSignal.image = UIImage(named: "noWifi.png")
                    isInternetConnected = false
                    simpleAlertActionSheet(title: "Check connection", msg: "All data displayed need internet connection to be uptodate.", sender: sender)
//                    let alert = UIAlertController(title: "Check connection", message: "All data displayed need internet connection to be uptodate.", preferredStyle: .alert)
//                    let cancelBtn = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//                    alert.addAction(cancelBtn)
//                    sender.present(alert, animated: true, completion: {
//                        //
//                    })
                }
                defaults.set(false, forKey: "netConnection")
            }else if path.status == .requiresConnection{
                DispatchQueue.main.async {
                simpleAlertActionSheet(title: "Connecting to internet", msg: "", sender: sender)
                }
            }
            
            print(path.isExpensive)
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
    
    public static    func makeActivityIndicator(sender: UIView)-> UIActivityIndicatorView{
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        sender.addSubview(activityIndicator)
            activityIndicator.centerXAnchor.constraint(equalTo: sender.centerXAnchor).isActive = true
            activityIndicator.centerYAnchor.constraint(equalTo: sender.centerYAnchor).isActive = true
        activityIndicator.startAnimating()
        return activityIndicator
    }
    
    public static    let imageCache = NSCache<AnyObject, AnyObject>()
    typealias CompletionHandler = (_ success:Bool, _ image:UIImage?) -> Void
    
    public static func getFileUrl(fileName:String) -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let pathDirectory = paths[0]
        try? FileManager().createDirectory(at: pathDirectory, withIntermediateDirectories: true)
        let path = pathDirectory.appendingPathComponent(fileName)
        return path
    }
    public static func archive (dataBase: String, dataStrForArchive : String){
        let filename = self.getFileUrl(fileName: dataBase + ".txt")
        do {
            try dataStrForArchive.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
        }
    }
    
    
    public static func UnArchive (dataBase: String)-> [[String:Any]]{
        let filename = self.getFileUrl(fileName: dataBase + ".txt")
        var resultDataBase = [[String:Any]]()
        do {
            let contents = try String(contentsOfFile: filename.path)
            print("_______________________\(contents)")
            let data = Data(contents.utf8)
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                var jsonAsDic = [[String : Any]]()
                print("++++++++++++++++++++\(json)")
                
                jsonAsDic = json as! [[String : Any]]
                resultDataBase = jsonAsDic
               
                print("jsonAsDic \(jsonAsDic)")
                
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
            
        } catch {
            // contents could not be loaded
        }
        return resultDataBase
    }
    
    func loadImageUsingCacheWithUrlString(_ urlString:
     String,completionHandler: @escaping CompletionHandler) {
        var image = UIImage()
        //check cache for image first
        if let cachedImage = UtilFun.imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            image = cachedImage
            completionHandler(true, image)
            return
        }
        if urlString == "" {
            completionHandler(false, image)
            return
        }
        //otherwise fire off a new download
        if let url = URL(string: urlString){
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            //download hit an error so lets return out
            if error != nil {
                print(error ?? "")
                completionHandler(false,nil)
                return
            }
            DispatchQueue.main.async(execute: {
                if let downloadedImage = UIImage(data: data!) {
                    image = downloadedImage
                    UtilFun.imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)

                    completionHandler(true,image)
                }
            })
        }
        ).resume()

    }
    }
    public static func simpleAlertActionSheet(title: String, msg: String, sender:Any){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        (sender as AnyObject).present(alert, animated: true, completion: nil)
    }
    
    public static func simpleAlert(msg : String, sender :Any){
        let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
        let cancelBtn = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancelBtn)
        (sender as AnyObject).present(alert, animated: true, completion: {
        })
    }
    
    public static func simpleToast(title: String, msg: String, sender:Any){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .actionSheet)
        (sender as AnyObject).present(alert, animated: true, completion: nil)
    }
    
    public static func spinner(sender: UIView, color: UIColor) -> UIActivityIndicatorView{
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        sender.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: sender.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: sender.centerYAnchor).isActive = true
        activityIndicator.color = .red
        activityIndicator.style = .large
        activityIndicator.startAnimating()
        return activityIndicator
    }
    public static func jsonToString(json: Dictionary<String, Any>)-> String{
        var myStr = String()
        do {
            let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
            myStr = String(data: data1, encoding: String.Encoding.utf8)! // the data will be converted to the string
        } catch let myJSONError {
            print(myJSONError)
        }
        return myStr
    }
    
    public static  func getColor(hexStr: String)-> UIColor{
        let r = Int(hexStr[1..<3], radix: 16)
        let g = Int(hexStr[3..<5], radix: 16)
        let b = Int(hexStr[5..<7], radix: 16)
        let cgR = CGFloat(r ?? 0)/255
        let cgG = CGFloat(g ?? 0)/255
        let cgB = CGFloat(b ?? 0)/255
        let myColor = UIColor(displayP3Red: cgR, green: cgG, blue: cgB, alpha: 1)
        print("r= \(r) g= \(g) b= \(b) --- cgR= \(cgR) cgG= \(cgG) cgB= \(cgB)")
        return myColor
    }
    
}
extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
        
        if let nav = self.navigationController {
            nav.view.endEditing(true)
        }
    }
}

extension String {
    // usage
//    let s = "hello"
//    s[0..<3] // "hel" where 3 is not the number of letters but the position of the last letter in the substring
//    s[3...]  // "lo"
    subscript(_ range: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
        let end = index(start, offsetBy: min(self.count - range.lowerBound,
                                             range.upperBound - range.lowerBound))
        return String(self[start..<end])
    }

    subscript(_ range: CountablePartialRangeFrom<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
         return String(self[start...])
    }
}

