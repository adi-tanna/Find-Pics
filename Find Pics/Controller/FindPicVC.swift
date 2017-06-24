//
//  FindPicVC.swift
//  Find Pics
//
//  Created by Aditya Tanna on 6/21/17.
//  Copyright © 2017 Tanna Inc. All rights reserved.
//

import UIKit
import AVFoundation

class FindPicVC: UIViewController, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, AVAudioPlayerDelegate {
    
    let columns: CGFloat = 2.0
    
    let inset: CGFloat = 10.0
    
    let spacing: CGFloat = 10.0
    
    let lineSpacing: CGFloat = 10.0
    
    let strCellIdentifier = "cellIamge"
    
    let charactersData = Characters.loadCharacters()
    
    var player : AVAudioPlayer?
    
    var isRandom = false
    
    var isMute = false
    
    @IBOutlet var collectionImages: UICollectionView!
    
    @IBOutlet var btnSearch: UIBarButtonItem!
    
    @IBOutlet var btnMuteUnmute: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        playBackgroundMusic()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: ReachabilityChangedNotification,object: getAppDelegate().reachability)
        do{
            try getAppDelegate().reachability?.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    //MARK:- Button Action Events
    @IBAction func btnSearchTapped(_ sender: UIBarButtonItem) {
        addSearchbar()
        navigationItem.rightBarButtonItem = nil
    }
    
    @IBAction func btnMuteUnmuteTapped(_ sender: UIButton) {
        if sender.isSelected{
            sender.isSelected = false
            self.player?.volume = 0.5
            isMute = false
        }else{
            sender.isSelected = true
            self.player?.volume = 0.0
            isMute = true
        }
    }
    
    
    //MARK-:- Helper Function
    func setupView() {
        let nib = UINib(nibName: "ImageCollectionCell", bundle: nil)
        
        collectionImages.register(nib, forCellWithReuseIdentifier: strCellIdentifier)
        
        let refreshControl = UIRefreshControl()
        
        refreshControl.addTarget(self, action: #selector(refreshControlDidFire), for: .valueChanged)
        
        collectionImages?.refreshControl = refreshControl
    }
    
    func addSearchbar() {
        
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search Images Here"
        searchBar.showsCancelButton = false
        searchBar.tintColor = UIColor.white
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
        navigationItem.titleView = searchBar
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem = nil

    }
    
    func refreshControlDidFire() {
        isRandom = true
        collectionImages?.reloadData()
        collectionImages?.refreshControl?.endRefreshing()
    }
    
    func playBackgroundMusic(){
        guard let urlMusic = Bundle.main.url(forResource: "background_music", withExtension: "mp3") else{
            return
        }
        do{
            player = try AVAudioPlayer(contentsOf: urlMusic)
            
            player?.delegate = self;
            
            player?.play()
            if isMute{
                self.player?.volume = 0.0
            }else{
                self.player?.volume = 0.5
            }
            
        }catch (let error){
            print(error)
        }
    }
    
    //MARK:- Call API to search images
    func callAPItoSearchImages(_ strSearchText: String, complition:(([AnyObject])-> Void)?) {
        
        let strUrl = ""
        /*
        callWebService(strUrl, parameters: nil, methodHttp: .get, completion: { (response) in
            
        }, failure: { (error) in
            print(error)
        })
        */
    }

    //MARK: - Notification Handler Methods
    func reachabilityChanged(note: NSNotification) {
        
        let reachability = note.object as! Reachability
        
        if reachability.isReachable {
            if reachability.isReachableViaWiFi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
            
        }else {
            self.showAlertWithErrorMsg("Looks like you are not connected to Internet")
        }
    }
    
    //MARK:- AVAudioPlayer Delegate Method
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playBackgroundMusic()
    }
    

    //MARK:- Search Bar Delegate Methods
    public func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool{
        searchBar.showsCancelButton = true
        return true
    }
    
    public func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool{
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        return true
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        
    }
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        
        let strSearchText = searchBar.text
        
        print("Images to be searched: \(strSearchText ?? "")")
        
        searchBar.text = ""
        searchBar.resignFirstResponder()
        navigationItem.titleView = nil
        navigationItem.leftBarButtonItem = btnSearch
        navigationItem.rightBarButtonItem = btnMuteUnmute
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
        searchBar.text = ""
        searchBar.resignFirstResponder()
        navigationItem.titleView = nil
        navigationItem.leftBarButtonItem = btnSearch
        navigationItem.rightBarButtonItem = btnMuteUnmute
    }
    
    //MARK:- UICollectionView Data Source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return charactersData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: strCellIdentifier, for: indexPath) as? ImageCollectionCell
        
        cell?.character =  charactersData[indexPath.item]
        
        return cell!
    }
    
    //MARK:- UICollectionViewDelegate FlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = Int((collectionView.frame.width / columns) - (inset + spacing))
        
        var randomSize: Int
        if isRandom == true {
            randomSize = 64 * Int(arc4random_uniform(UInt32(3)) + 1)
        } else {
            randomSize = width
        }
        
        return CGSize(width: randomSize, height: randomSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return lineSpacing
    }
}
