//
//  InitialViewController.swift
//  ARWDM
//
//  Created by Robin Konijnendijk on 10/01/2024.
//

import UIKit
import ARKit

class InitialViewController: UIViewController {
    @IBOutlet var startARBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        
    }
    
    @IBAction func startARBtnPressed(_ sender: UIButton) {
        if ARWorldTrackingConfiguration.isSupported {
            self.performSegue(withIdentifier: "startAR", sender: self)
        } else {
            showAlert()
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "AR Not Supported", message: "Your divice does not support AR", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    

}
