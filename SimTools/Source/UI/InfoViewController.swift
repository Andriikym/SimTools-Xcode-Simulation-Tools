/**
*  SimTools
*  Copyright (c) Andrii Myk 2020
*  Licensed under the MIT license (see LICENSE file)
*/

import Cocoa

class InfoViewController: NSViewController {
    
    // MARK: - Outlets

    @IBOutlet weak var infoLabel: NSTextField!
    
    // MARK: - Private properties

    private var simManager = SimManager.shared
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        refresh()
    }
    
    // MARK: - Actions
    
    @IBAction func onRefresh(_ sender: Any) {
        refresh()
    }
    
    // MARK: - Private

    private func refresh() {
        simManager.refresh { error in
            if let error = error {
                self.infoLabel.stringValue = error.description
                return
            }
            
            self.updateSimulatorStateInfo()
        }
    }
    
    private func updateSimulatorStateInfo() {
        let runnedSimCount = simManager.bootedSimulators?.count ?? 0

        simManager.isSimulatorAppRunned { result in
            let text: String
            
            switch result {
            case .success(let value):
                text = value ? "Simulator is runned. \(runnedSimCount) booted" : "Simulator is not runned"
            case .failure(let error):
                text = error.description
            }
            
            self.infoLabel.stringValue = text
        }
    }
}
