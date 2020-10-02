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
    var writer: MotionWriter?
    var begin: Date?

    @IBOutlet weak var dirText: UITextField!
    @IBOutlet weak var durationText: UITextField!
    @IBOutlet weak var button: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        if !hmm.isDeviceMotionAvailable {
            print("current device does not supports the headphone motion manager.")
        }
        // handle start device motion
        hmm.startDeviceMotionUpdates(to: .main) { (motion, error) in
            if let motion = motion {
//                print(motion)
                if let writer = self.writer {
                    writer.write(motion)
                    let duration = Int(self.durationText.text!)!
                    if duration > 0 {
                        let now = Date()
                        if now.timeIntervalSince(self.begin!) > Double(duration) {
                            self.stop()
                            _ = self.start(self.dirText.text!)
                        }
                    }
                }
            }
            if let error = error {
                print(error)
            }
        }

    }

    @IBAction func onButtonTap(_ sender: Any) {
        if self.writer == nil && start(dirText.text!) {
            button.setTitle("stop", for: .normal)
        }
        else {
            stop()
            button.setTitle("start", for: .normal)
        }
    }
}

extension ViewController {

    func start(_ dirName: String) -> Bool {

        // Document dir in app sandbox.
        let document = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

        // create directory
        do {
            try FileManager.default.createDirectory(
                at: document.appendingPathComponent(dirName, isDirectory: true),
                withIntermediateDirectories: true,
                attributes: nil)
        } catch let error {
            print(error)
            return false
        }

        // generate file path
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd_HHmmss"
        let filename = formatter.string(from: Date()) + ".csv"
        let fileUrl1 = document.appendingPathComponent(dirName, isDirectory: true)
        let fileUrl = fileUrl1.appendingPathComponent(filename)
        print(fileUrl.absoluteURL)

        // setup writer
        writer = MotionWriter()
        writer?.open(fileUrl)
        begin = Date()

        return true
    }

    func stop() {
        if let writer = self.writer {
            writer.close()
            self.writer = nil
        }
    }
}

