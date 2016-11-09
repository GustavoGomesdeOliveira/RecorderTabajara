//
//  ViewController.swift
//  RecorderTabajara
//
//  Created by Gustavo Gomes de Oliveira on 07/11/16.
//  Copyright © 2016 Gustavo Gomes de Oliveira. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate {
    
    var soundRecorder : AVAudioRecorder!
    var soundPlayer : AVAudioPlayer!
    
    var fileName = ""
    var test = [[String:NSData]]()
    var files = Array<NSData>()
    
    var audioURL = Array<URL>()
    var audioName = Array<String>()
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad()  {
        super.viewDidLoad()
        getFiles()
        self.table.reloadData()
        
    }
        
        // Do any additional setup after loading the view, typically from a nib.
        
        

        
        func setUpRecorder() throws{
            
            let recordSetting = [AVFormatIDKey: NSNumber(value: kAudioFormatMPEG4AAC),
                                 AVSampleRateKey: 44100.0,
                                 AVNumberOfChannelsKey: 1] as [String : Any]
            
            
            
            try soundRecorder = AVAudioRecorder(url: getFilreURL() as URL, settings: recordSetting)
            soundRecorder.delegate = self
            soundRecorder.prepareToRecord()
            
        }
        
        
        func getFilreURL() -> NSURL {
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            let fileURL = documentsURL?.appendingPathComponent(fileName)
            let url = NSURL(fileURLWithPath: (fileURL?.path)!)
            print(url)
            return url
            
        }
        
        @IBAction func record(_ sender: UIButton) {
            
            if sender.titleLabel?.text == "Record"{
                
                do {
                    
                    let time = NSDate()
                    fileName =  String(describing: time) + ".m4a"
                    try setUpRecorder()
                    
                } catch {
                    
                    
                }
                
                sender.setTitle("Stop", for: .normal)
                soundRecorder.record()
                
            } else {
                
                sender.setTitle("Record", for: .normal)
                soundRecorder.stop()
                self.table.reloadData()
            }
            
            self.table.reloadData()
            
        }

        
        func preparePlayer() throws{
            
            
            try soundPlayer = AVAudioPlayer(contentsOf: getFilreURL() as URL)
            soundPlayer.delegate = self
            soundPlayer.prepareToPlay()
            soundPlayer.volume = 1.0
        }
        
        func getFiles(){
            
            // Get the document directory url
            let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            do {
                // Get the directory contents urls (including subfolders urls)
                let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [])
                print(directoryContents)
                
                audioURL = directoryContents.filter{ $0.pathExtension == "m4a" }
                
                audioName = audioURL.map{ $0.deletingPathExtension().lastPathComponent }
                
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
            
        }
        
        //tableview
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return audioName.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell:CellTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CellTableViewCell
            
            
            cell.label.text = audioName[indexPath.row]
            
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            do {
                try soundPlayer = AVAudioPlayer(contentsOf: audioURL[indexPath.row])
                soundPlayer.delegate = self
                soundPlayer.prepareToPlay()
                soundPlayer.volume = 1.0
                soundPlayer.play()
            } catch {
                
                print(error)
            }
            
            
            
            
        }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        if item.tag == 1{
            do {
                
                let time = NSDate()
                fileName =  String(describing: time) + ".m4a"
                try setUpRecorder()
                
            } catch {
                
                
            }
        }
        
        

    }
}


