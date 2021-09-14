//
//  detailViewController.swift
//  azkary
//
//  Created by aly hassan on 13/09/2021.
//

import UIKit

class detailViewController: UIViewController {

    
    
    var myKvPairs : KeyValuePairs =  ["":1]


    
    var currentZekrIndex = 0
    
    @IBOutlet weak var reps: UILabel!
    var currentRep = 1
    @IBOutlet weak var zekrTxtVw: UITextView!
    @IBAction func nextBtnAct(_ sender: Any) {
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
        updateScreen()
        
        // Do any additional setup after loading the view.
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
