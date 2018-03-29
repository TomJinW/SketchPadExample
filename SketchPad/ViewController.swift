//
//  ViewController.swift
//  test
//
//  Created by Tom on 2018. 3. 26..
//  Copyright © 2018년 Tom. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func Clear(_ sender: UIButton) {
        UIGraphicsBeginImageContext(imgView.frame.size)
        let context = UIGraphicsGetCurrentContext()
        context?.clear(imgView.frame)
        UIGraphicsEndImageContext()
        imgView.image = UIGraphicsGetImageFromCurrentImageContext()

    }
    
    var startTouch = CGPoint(x: 0, y: 0)
    @IBOutlet weak var imgView: UIImageView!

    func drawLine(from:CGPoint,to:CGPoint){
        UIGraphicsBeginImageContext(imgView.frame.size)
        let context = UIGraphicsGetCurrentContext()
        context?.move(to: from)
        context?.addLine(to: to)
        context?.setLineCap(.round)
        context?.setLineWidth(2.0)
        context?.setBlendMode(.normal)
        context?.setStrokeColor(CGColor(colorSpace: CGColorSpace(name:CGColorSpace.sRGB)!, components: [0.5,0.7,0.3,1])!)

        
        context?.strokePath()
        imgView.image?.draw(in: view.frame)
        imgView.layer.draw(in: context!)
        imgView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            startTouch = touch.location(in: view)
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{
            return
        }
        let location = touch.location(in: view)
        drawLine(from: startTouch, to: location)
        startTouch = location
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func image(_ image:UIImage,didFinishSavingWithError error:NSError?,contextInfo:UnsafeRawPointer){
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    @IBAction func save(_ sender: UIButton) {
        if let image = imgView.image{
            //UIImageWriteToSavedPhotosAlbum(image,nil,nil,nil)
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
}

