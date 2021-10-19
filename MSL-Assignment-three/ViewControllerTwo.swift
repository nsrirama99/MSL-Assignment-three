//
//  ViewControllerTwo.swift
//  MSL-Assignment-three
//
//  Created by UbiComp on 10/13/21.
//

import UIKit
import SpriteKit

class ViewControllerTwo: UIViewController {
    
    var sendSteps:Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup game scene
        let scene = GameScene(size:view.bounds.size)
        let skView = view as! SKView
        scene.scaleMode = .resizeFill
        skView.showsNodeCount = true
        skView.presentScene(scene)
        print(sendSteps)
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
