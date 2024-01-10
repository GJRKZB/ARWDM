//
//  ViewController.swift
//  ARWDM
//
//  Created by Robin Konijnendijk on 10/01/2024.
//

import UIKit
import SceneKit
import ARKit

class SceneViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var dotNodes = [SCNNode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: sceneView) else {
            print("No location found")
            return
        }
        
        guard let query = sceneView.raycastQuery(from: location, allowing: .estimatedPlane, alignment: .any) else {
            print("No query found")
            return
        }
        
        guard let result = sceneView.session.raycast(query).first else {
            print("No result found")
            return
        }
        
        let dot = addDotNode()
        
        dot.transform = SCNMatrix4(result.worldTransform)
        
        sceneView.scene.rootNode.addChildNode(dot)
        
    }
    
    private func addDotNode() -> SCNNode {
        let dotGeometry = SCNSphere(radius: 0.005)
        let dotMaterial = SCNMaterial()
        
        dotMaterial.diffuse.contents = UIColor.red
        dotGeometry.materials = [dotMaterial]
        
        let dotNode = SCNNode(geometry: dotGeometry)
        
        return dotNode
        
    }
   
}
