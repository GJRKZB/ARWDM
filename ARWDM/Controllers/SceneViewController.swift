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
    var textNode = SCNNode()
    
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
        
        if dotNodes.count >= 2 {
            for dot in dotNodes {
                dot.removeFromParentNode()
            }
            
            dotNodes = [SCNNode]()
        }
        
        
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
        
        let dot = addDotNode(at: result)
        dot.transform = SCNMatrix4(result.worldTransform)
        
        sceneView.scene.rootNode.addChildNode(dot)
        
    }
    
    private func addDotNode(at result : ARRaycastResult) -> SCNNode{
        let dotGeometry = SCNSphere(radius: 0.005)
        let dotMaterial = SCNMaterial()
        
        dotMaterial.diffuse.contents = UIColor.red
        dotGeometry.materials = [dotMaterial]
        
        let dotNode = SCNNode(geometry: dotGeometry)
        
        dotNode.position = SCNVector3(
        result.worldTransform.columns.3.x,
        result.worldTransform.columns.3.y,
        result.worldTransform.columns.3.z)
        
        dotNodes.append(dotNode)
    
        if dotNodes.count >= 2 {
            calculate()
        }
        
        return dotNode
        
    }
    
    private func calculate() {
        let start = dotNodes[0]
        let end = dotNodes[1]
        
        let distance = sqrt(
            pow(end.position.x - start.position.x, 2) +
            pow(end.position.y - start.position.y, 2) +
            pow(end.position.z - start.position.z, 2)
        )
        
        updateText(text: "\(abs(distance))", atPosition: end.position)
        print(distance)

    }
    
    private func updateText(text: String, atPosition position: SCNVector3) {
        
        textNode.removeFromParentNode()
        
        let textGeometry = SCNText(string: text, extrusionDepth: 1.0)
        textGeometry.firstMaterial?.diffuse.contents = UIColor.red
        textNode = SCNNode(geometry: textGeometry)
        textNode.position = SCNVector3(position.x, position.y + 0.01, position.z)
        textNode.scale = SCNVector3(0.01, 0.01, 0.01)
        
        sceneView.scene.rootNode.addChildNode(textNode)
    }
    
    
   
}
