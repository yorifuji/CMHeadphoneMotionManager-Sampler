//
//  ViewController.swift
//  CMHeadphoneMotionManager-Sampler
//
//  Created by yorifuji on 2020/09/28.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {

    let hmm = CMHeadphoneMotionManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        if !hmm.isDeviceMotionAvailable {
            print("current device does not supports the headphone motion manager.")
            return
        }

//        if !hmm.isDeviceMotionActive {
//            print("the headphone motion manager is not active.")
//            return
//        }

//        hmm.startDeviceMotionUpdates()

        hmm.startDeviceMotionUpdates(to: .main) { (motion, error) in
            if let motion = motion {
                print(motion)
            }
            if let error = error {
                print(error)
            }
        }
    }


}

