//
//  ViewController.swift
//  downloader
//
//  Created by Ryan Kelly on 3/30/15.
//  Copyright (c) 2015 ThreeGuys. All rights reserved.
//

import UIKit



class ViewController: UIViewController {

    var latencyCounter: Double = 0
    var samples: [Double] = [0]
    var speedSamples: [Double] = [0]
    var speedArray: [Double] = [0]
    var speedCounter: Double = 0
    var speedSum: Double = 0
    let url = NSURL(string: "http://web.mit.edu/21w.789/www/papers/griswold2004.pdf")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        latencyLabel.text = "Latency: "
        throughputLabel.text = "Throughput: "
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet weak var latencyLabel: UILabel!
    @IBOutlet weak var throughputLabel: UILabel!
    @IBAction func downloadButton(sender: AnyObject) {
        //println(self.latencyCounter)
        let speedTimer = NSTimer.scheduledTimerWithTimeInterval(1,target:self, selector: "speedTest", userInfo: nil, repeats:true)
        let latencyTimer = NSTimer.scheduledTimerWithTimeInterval(0.001,target:self, selector: "latencyIncrease", userInfo: nil, repeats:true)
        
        let destination = Request.suggestedDownloadDestination(directory: .DocumentDirectory, domain: .UserDomainMask)
        download(.GET, "http://web.mit.edu/21w.789/www/papers/griswold2004.pdf", destination)
            .progress { (bytesRead, totalBytesRead, totalBytesExpectedToRead) in
                if totalBytesRead != 0{
                    latencyTimer.invalidate()
                }
                if totalBytesRead == totalBytesExpectedToRead {
                    speedTimer.invalidate()
                }
                self.samples.append(Double(totalBytesRead))
                //println(totalBytesRead)
            
                //println("Latency: \(self.latencyCounter)")
            }
            .response{ (request, response, _, error) in
                //println(response)
                var ind = Double(self.speedArray.count)
                
                println("Latency: \(self.latencyCounter) ms")
                println("samples: \(self.speedCounter)")
                //println(self.samples)
                println(self.speedArray)
                //println(self.speedSamples)
                if ind > 1{
                    for i in self.speedArray {
                        self.speedSum += i
                    }
                    let speed = self.speedSum/(ind-1)
                    println("Network speed is: \(speed*0.008) kbps")
                    self.latencyLabel.text = ("Latency: \(self.latencyCounter) ms")
                    self.throughputLabel.text = ("Throughput: \(speed*0.008) kbps")
                }
        }
    }
    @IBAction func resetButton(sender: AnyObject) {
        self.latencyCounter = 0
        latencyLabel.text = "Latency: "
        throughputLabel.text = "Throughput: "
        
    }
    
    func latencyIncrease(){
        latencyCounter++
    }
    func speedTest(){
        var speedInd = self.speedArray.count
        var sampleInd = self.samples.count
        var speedSamplesInd = self.speedSamples.count
        //println(self.samples[ind-1])
        //println(self.samples[ind-2])
            //println(self.samples[ind-1])
            //println(self.samples[ind-2])
        self.speedArray.append(self.samples[sampleInd-1] - self.speedSamples[speedSamplesInd-1])
        self.speedSamples.append(self.samples[sampleInd-1])
        speedCounter++
        //println("BYTES \(timer.userInfo!)")
        //samples.append(byteTest)
        //println("TEST")
    }
}

