//
//  ViewController.swift
//  DADemo1
//
//  Created by Dejan on 07/08/2017.
//  Copyright © 2017 Dejan. All rights reserved.
//

import UIKit
import BBPortal

class ViewController: UIViewController {

    private struct Constants {
        static let GroupID = "group.agostini.tech.DAAppGroupDemo"
        static let SliderPortalID = "SliderPortal"
        static let SegmentPortalID = "SegmentPortal"
        
        static let SliderKey = "SliderKey"
    }
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var sliderLabel: UILabel!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var segmentedControlLabel: UILabel!
    
    private var sliderPortal: BBPortalProtocol?
    private var segmentPortal: BBPortalProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPortals()
    }
    
    private func setupPortals() {
        setupSliderPortal()
        setupSegmentPortal()
    }
    
    private func setupSliderPortal() {
        sliderPortal = BBPortal(withGroupIdentifier: Constants.GroupID, andPortalID: Constants.SliderPortalID)
        sliderPortal?.onDataAvailable = {
            (data) in
            
            guard let dict = data as? [String: Any?], let value = dict[Constants.SliderKey] as? Float else {
                return
            }
            
            DispatchQueue.main.async {
                self.sliderLabel.text = "Received slider value: \(value)"
                self.slider.setValue(value, animated: true)
            }
        }
    }
    
    private func setupSegmentPortal() {
        segmentPortal = BBPortal(withGroupIdentifier: Constants.GroupID, andPortalID: Constants.SegmentPortalID)
        segmentPortal?.onDataAvailable = {
            (data) in
            
            guard let value = data as? Int else {
                return
            }
            
            DispatchQueue.main.async {
                self.segmentedControlLabel.text = "Received segment value: \(value)"
                self.segmentedControl.selectedSegmentIndex = value
            }
        }
    }

    @IBAction func sliderValueChanged(_ sender: UISlider) {
        sliderPortal?.send(data: [Constants.SliderKey: sender.value], onCompleted: { (error) in
            if let anError = error {
                print("Something went wrong when sending data: ", anError)
            }
        })
    }
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        segmentPortal?.send(data: sender.selectedSegmentIndex, onCompleted: { (error) in
            if let anError = error {
                print("Something went wrong when sending data: ", anError)
            }
        })
    }
}

