//
//  ViewController.swift
//  music player
//
//  Created by Andrew Mekhail on 3/11/19.
//  Copyright © 2019 Andrew Mekhail. All rights reserved.
//


import UIKit
import AVFoundation
class ViewController: UIViewController
{
    
    var audioplayer : AVAudioPlayer!
    var isPlaying = false
    var timer:Timer!
    var progress_time :Timer!
    var order: String!
    var song_name :String!
    var myArray : [String]!
    var final_name :String!
    var PlayList : [String] = [" "]
    var  indexOfSong :Int!
    var NewSong : String!
    var urlArray : [String] = [" "]
    
    @IBOutlet weak var progress: UIProgressView!
    
    @IBOutlet weak var PlayedTime: UILabel!
    
    //lazy var fileURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("txt")
    
    @IBOutlet weak var texttoread: UITextView!

    @IBAction func read(_ sender: UIButton)
    {
         print("done")

    }
    
    
    @IBAction func PlayorPause(_ sender: Any)
    {
        if isPlaying {
            audioplayer.pause()
            isPlaying = false
        } else {
            audioplayer.play()
            isPlaying = true
            
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
            progress_time=Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.updateProgressView), userInfo: nil, repeats: true)
            progress.setProgress(Float(audioplayer.currentTime/audioplayer.duration), animated: false)
        }
    
    }
    
    @IBAction func Stop(_ sender: Any)
    {
        audioplayer.stop()
        audioplayer.currentTime = 0
        isPlaying = false
        progress.progress=0
    }
    
    
    @objc func updateTime ()
    {
        let currentTime = Int(audioplayer.currentTime)
        let minutes = currentTime/60
        let seconds = currentTime - minutes * 60
        
        PlayedTime.text = String(format: "%02d:%02d", minutes,seconds) as String
    }
    
    @IBAction func Next(_ sender: Any)
    {
        if indexOfSong == 0 || indexOfSong < PlayList.count
        {
            indexOfSong += 1
            NewSong = PlayList[ indexOfSong]
            let path = Bundle.main.path( forResource:NewSong, ofType: "mp3")!
            let url = URL(fileURLWithPath: path )
            do {
                audioplayer =  try AVAudioPlayer(contentsOf: url)
                audioplayer.play()
                
            }
            catch
            {
                print("can't load file")
                // can't load file
            }
            
        }
    }
    
    @IBAction func previous(_ sender: Any)
    {
        if indexOfSong != 0 || indexOfSong > 0
        {
            indexOfSong -= 1
            NewSong = PlayList[ indexOfSong]
            
            let path = Bundle.main.path( forResource:NewSong, ofType: "mp3")!
            let url = URL(fileURLWithPath: path )
            do {
                audioplayer =  try AVAudioPlayer(contentsOf: url)
                 audioplayer.play()
            
              }
            catch
            {
                print("can't load file")
                // can't load file
            }
            
        }
        
        
        
    }
    
    @objc func updateProgressView ()
    {
        if audioplayer.isPlaying
       {
       progress.setProgress(Float(audioplayer.currentTime/audioplayer.duration), animated: true)
        }
        
    }

    override func viewDidLoad()
    {
         super.viewDidLoad()
          // Do any additional setup after loading the view, typically from a nib.
        
        let fm = FileManager.default
    
        
        do {
            let items = try fm.contentsOfDirectory(atPath: "/Users/dora/Desktop/My music" )
        
            for item in items
              {
              var making_names  = item.components(separatedBy: ".")
               let SongName = making_names[0]
              PlayList.append( SongName )
              urlArray.append (item)
               urlArray.remove(at: 0)
                
                
                print(urlArray)
                print("Found \(item)")
              }
            PlayList.remove(at: 0)
            print(PlayList)
         }
      catch
         {
            // failed to read directory – bad permissions, perhaps?
         }
        
        
        let fileURL = "/Users/dora/Desktop/test2.txt"
        do {
            // Read file content
            let   contents = try NSString(contentsOfFile: fileURL, encoding: String.Encoding.utf8.rawValue)
            myArray = contents.components(separatedBy: " ")
            order  = myArray[0]
            myArray.remove(at: 0)
            song_name = myArray.joined(separator:" ")

          }
        catch
            {
               print("An error took place: \(error)")
            }
    for song in PlayList
        {
            if  song_name == song
            {
            print("found the song")
            indexOfSong = PlayList.firstIndex(of: song_name)
            let path = Bundle.main.path( forResource:song_name, ofType: "mp3")!
            let url = URL(fileURLWithPath: path )
                do {
                    audioplayer =  try AVAudioPlayer(contentsOf: url)
                    break
                }
                catch
                {
                    print("can't load file")
                    // can't load file
                }
            }
            else
            {
                print( song_name, " is not found" )
        
            }
        }
       
    }
}

    




