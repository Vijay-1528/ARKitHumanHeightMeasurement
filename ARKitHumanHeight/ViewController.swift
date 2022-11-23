//
//  ViewController.swift
//  ARKitHumanHeight
//
//  Created by VIJAY M on 21/11/22.
//

import UIKit
import ARKit
import RealityKit

class ViewController: UIViewController {

    @IBOutlet weak var readingContainer: UIView!
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var feetReading: UILabel!
    @IBOutlet weak var inchesReading: UILabel!
    @IBOutlet weak var cmReading: UILabel!
    
    var tempLbl = UILabel()
    
    var character: BodyTrackedEntity?
    let characterOffset: SIMD3<Float> = [-1.0, 0, 0] // Offset the character by one meter to the left
    let characterAnchor = AnchorEntity()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.readingContainer.isHidden = true
        sceneView.delegate = self
        sceneView.session.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configure = ARBodyTrackingConfiguration()
        configure.automaticImageScaleEstimationEnabled = true
        sceneView.session.run(configure)
    }

}

extension ViewController: ARSCNViewDelegate, ARSessionDelegate {
//    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
//
//        guard let bodyAnchor = anchor as? ARBodyAnchor
//        else { return }
//
//        let skeleton = bodyAnchor.skeleton
//
//        for (i, joint) in skeleton.definition.jointNames.enumerated() {
//            print(i, joint)
//        }
//
//        let neckJointPos = skeleton.jointModelTransforms[49].columns.3.y    // neck_3_joint
//        let toesJointPos = skeleton.jointModelTransforms[10].columns.3.y    // right_toes_joint
//        let headJointPos = skeleton.jointModelTransforms[51].columns.3.y    // head_joint
//
//        let crown = headJointPos - neckJointPos
//
//        print(headJointPos - toesJointPos)       // 1.6570237 m
//        print((headJointPos - toesJointPos) * 3.281)       // Feet
//        let meterFeet = Measurement(value: Double((headJointPos - toesJointPos)), unit: UnitLength.meters)
//        let firstFeet = meterFeet.converted(to: .feet).unit
//        let secondFeet = meterFeet.converted(to: .feet)
//
//        let crownFt = Measurement(value: Double((crown + (headJointPos - toesJointPos))), unit: UnitLength.meters)
//
// //        print("meterFeet, firstFeet, secondFeet ----------\(meterFeet), \(firstFeet), \(secondFeet), \(secondFeet/2)")
// //
// //        print("bodyAnchor.estimatedScaleFactor --------- \(bodyAnchor.estimatedScaleFactor)")
//
//        print("didAdd Plus crown --------- \(crown + (headJointPos - toesJointPos))")
//
//        print("didAdd Plus crown with ft --------- \(crownFt)")
//
//        DispatchQueue.main.async {
//            self.readingContainer.isHidden = false
//            let roundedHeight = round(Double((crown + (headJointPos - toesJointPos)) * 3.281) * 1000) / 1000.0
//            self.feetReading.text = "\(roundedHeight)".components(separatedBy: ".")[0]
//            let inches = "\(roundedHeight)".components(separatedBy: ".")[1]
//            self.inchesReading.text = inches
//            self.cmReading.text = "\(round(Double((crown + (headJointPos - toesJointPos)) * 100) * 1000) / 1000.0)"
//        }
//    }
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        for anchor in anchors {

            guard let bodyAnchor = anchor as? ARBodyAnchor
            else { return }

            let skeleton = bodyAnchor.skeleton

            for (i, joint) in skeleton.definition.jointNames.enumerated() {
                print(i, joint)
            }

            let neckJointPos = skeleton.jointModelTransforms[49].columns.3.y    // neck_3_joint
            let toesJointPos = skeleton.jointModelTransforms[10].columns.3.y    // right_toes_joint
            let headJointPos = skeleton.jointModelTransforms[51].columns.3.y    // head_joint

            let crown = headJointPos - neckJointPos

//            tempLbl.backgroundColor = UIColor.clear
//            tempLbl.font.withSize(25)
//            tempLbl.textColor = .white
//            tempLbl.text = "100"
//
//            for label in [tempLbl] {
//                label.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//                label.heightAnchor.constraint(equalToConstant: CGFloat(skeleton.jointModelTransforms[51].columns.3.y)).isActive = true
//            }
//            self.sceneView.addSubview(tempLbl)

            print(headJointPos - toesJointPos)       // 1.6570237 m
            print((headJointPos - toesJointPos) * 3.281)       // Feet
            let meterFeet = Measurement(value: Double((headJointPos - toesJointPos)), unit: UnitLength.meters)
            let firstFeet = meterFeet.converted(to: .feet).unit
            let secondFeet = meterFeet.converted(to: .feet)

            let armHeight = skeleton.jointModelTransforms[64].columns.3.y + skeleton.jointModelTransforms[65].columns.3.y + skeleton.jointModelTransforms[66].columns.3.y + skeleton.jointModelTransforms[72].columns.3.y + skeleton.jointModelTransforms[75].columns.3.y + skeleton.jointModelTransforms[76].columns.3.y

            let crownFt = Measurement(value: Double((crown + (headJointPos - toesJointPos))), unit: UnitLength.meters)

            print("meterFeet, firstFeet, secondFeet ----------\(meterFeet), \(firstFeet), \(secondFeet), \(secondFeet/2)")

            print("bodyAnchor.estimatedScaleFactor --------- \(bodyAnchor.estimatedScaleFactor)")

            print("Plus crown --------- \(crown + (headJointPos - toesJointPos))")

            print("Plus crown with ft --------- \(crownFt)")

            print("arms height \(armHeight)")
            print("arms shoulder height \(skeleton.jointModelTransforms[63].columns.3.y)")

            self.readingContainer.isHidden = false
            let roundedHeight = round(Double((crown + (headJointPos - toesJointPos)) * 3.281) * 1000) / 1000.0
            self.feetReading.text = "\(roundedHeight)".components(separatedBy: ".")[0]
            let inches = "0." + "\(roundedHeight)".components(separatedBy: ".")[1]
            self.inchesReading.text = inches
            self.cmReading.text = "\(round(Double((crown + (headJointPos - toesJointPos)) * 100) * 1000) / 1000.0)"

        }
    }
}
