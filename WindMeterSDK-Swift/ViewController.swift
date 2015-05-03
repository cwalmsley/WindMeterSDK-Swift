//
//  ViewController.swift
//  WindMeterSDK-Swift
//
//  Created by Christopher Walmsley on 3/28/15.
//  Copyright (c) 2015 Christopher Walmsley. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate {

    let screenSize: CGRect = UIScreen.mainScreen().bounds
    var sensor: WindMeterSDK? = nil
    var latestWindReading: AnemometerObservation? = nil
    var console = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drawView()
    }
    
    func drawView() {
        println("drawView()")
        
        //Start Button
        var startButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        startButton.titleLabel?.textAlignment = .Center
        startButton.titleLabel?.textColor = UIColor.blackColor()
        startButton.frame = CGRectMake(10, 30.0, (screenSize.width / 2.0) - 10.0, 50.0)
        startButton.setTitle("Start", forState: UIControlState.Normal)
        startButton.titleLabel!.font = UIFont.boldSystemFontOfSize(15)
        startButton.addTarget(self, action: "startAction:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(startButton)
        println("Start Button Added")
        
        //Stop Button
        var stopButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        stopButton.frame = CGRectMake(screenSize.width / 2.0, 30.0, (screenSize.width / 2.0) - 10.0, 50.0)
        stopButton.titleLabel?.textAlignment = .Center
        stopButton.titleLabel?.textColor = UIColor.blackColor()
        stopButton.setTitle("Stop", forState: UIControlState.Normal)
        stopButton.titleLabel!.font = UIFont.boldSystemFontOfSize(15)
        stopButton.addTarget(self, action: "stopAction:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(stopButton)
        println("Stop Button Added")
        
        //Console
        console = UITextView(frame: CGRectMake(10.0, 80.0, screenSize.width, screenSize.height - 80.0))
        console.text = "Screen loaded \n"
        console.delegate = self
        self.view.addSubview(console)
        println("Console Added")
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func startAction(sender: AnyObject) {
        println("startSensor()")
        buildWindSensor()
        sensor?.startListener()
    }
    
    func stopAction(sender: AnyObject) {
        println("stopSensor")
        sensor?.stopListener()
        sensor = nil
    }
    
    func buildWindSensor() {
        println("buildWindSensor()")
   
        sensor = WindMeterSDK()
        
        if self.sensor != nil {
            println("Sensor != Nil sensor = \(self.sensor)")
            sensor?.reportValueChange { (var value) -> Void in
                println("sensor.reportValueChange { (var value) -> Void")
                self.latestWindReading = value
                if self.latestWindReading != nil {
                
                    if self.latestWindReading!.statusCode.intValue == 0 {
                            //statusCode 0 = OK
                        dispatch_async(dispatch_get_main_queue()) {
                            self.console.text = self.console.text.stringByAppendingString("\(self.latestWindReading!.timestamp) :: \(self.latestWindReading!.windSpeed) \n")
                        }
                        
                            println("Windmeter Connected - Speed = \(self.latestWindReading!.windSpeed)")
                    }else{
                        if self.latestWindReading!.statusCode.intValue == 1 {
                            //statusCode 1 = Anemometer Not Connected
                            println("Windmeter Not Connected")
                            self.console.text = self.console.text.stringByAppendingString("Windmeter Not Connected \n")
                        }
                    }
                }
            }
        }else{self.console.text = self.console.text.stringByAppendingString("Sensor == nil")}
    }
    
    
    deinit
    {
        println("deinit")
        // perform the deinitialization
        self.sensor?.destroySensor()
        
    }
    
    

}

