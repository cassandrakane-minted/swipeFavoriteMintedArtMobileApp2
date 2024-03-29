//
//  BackgroundAnimationViewController.swift
//  Koloda
//
//  Created by Eugene Andreyev on 7/11/15.
//  Copyright (c) 2015 CocoaPods. All rights reserved.
//

import UIKit
import Koloda
import pop
import Alamofire

// TODO: hookup with backend
private var designInfosOverlayViews: [OverlayView] = []

private let numberOfCards: UInt = UInt(designInfosOverlayViews.count)
private let frameAnimationSpringBounciness: CGFloat = 9
private let frameAnimationSpringSpeed: CGFloat = 16
private let kolodaCountOfVisibleCards = 2
private let kolodaAlphaValueSemiTransparent: CGFloat = 0.1


class BackgroundAnimationViewController: UIViewController {

    @IBOutlet weak var kolodaView: CustomKolodaView!

    //MARK: Lifecycle
    override func viewDidLoad() {
        getBackendData(setDisplayInfos)
    }
    
    private func getBackendData(completionHandler: (designInfo: [[String : String]]) -> ()) {
        Alamofire.request(.GET, "http://424b91e6.ngrok.io/api/hack_designs")
            .responseJSON {response in
                completionHandler(designInfo: response.result.value as! [[String : String]])
        }
    }
    
    private func setDisplayInfos(info: [[String : String]]) {
        let designInfos = info
        designInfosOverlayViews = constructOverlayViews(designInfos)
        
        struct defaultsKeys {
            static let keyOne = "designInfos"
            static let keyTwo = "currentIndex"
        }
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(designInfos, forKey: defaultsKeys.keyOne)
        defaults.setInteger(0, forKey: defaultsKeys.keyTwo)
        
        defaults.synchronize()
        
        super.viewDidLoad()
        kolodaView.alphaValueSemiTransparent = kolodaAlphaValueSemiTransparent
        kolodaView.countOfVisibleCards = kolodaCountOfVisibleCards
        kolodaView.delegate = self
        kolodaView.dataSource = self
        kolodaView.animator = BackgroundKolodaAnimator(koloda: kolodaView)

        self.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
    }
    
    private func constructOverlayViews(infos: [[String: String]]) -> [OverlayView] {
        var designOverlayViews: [OverlayView] = []
        for info in infos {
            let designOverlayView = OverlayView()
            designOverlayView.designInfo = info
            designOverlayViews.append(designOverlayView)
        }
        return designOverlayViews
    }

    //MARK: IBActions
    @IBAction func leftButtonTapped() {
        kolodaView?.swipe(SwipeResultDirection.Left)
    }

    @IBAction func rightButtonTapped() {
        kolodaView?.swipe(SwipeResultDirection.Right)
    }

    @IBAction func undoButtonTapped() {
        kolodaView?.revertAction()
    }
}

//MARK: KolodaViewDelegate
extension BackgroundAnimationViewController: KolodaViewDelegate {

    func kolodaDidRunOutOfCards(koloda: KolodaView) {
        kolodaView.resetCurrentCardIndex()
    }

    func koloda(koloda: KolodaView, didSelectCardAtIndex index: UInt) {
        UIApplication.sharedApplication().openURL(NSURL(string: "")!)
    }

    func kolodaShouldApplyAppearAnimation(koloda: KolodaView) -> Bool {
        return true
    }

    func kolodaShouldMoveBackgroundCard(koloda: KolodaView) -> Bool {
        return false
    }

    func kolodaShouldTransparentizeNextCard(koloda: KolodaView) -> Bool {
        return true
    }

    func koloda(kolodaBackgroundCardAnimation koloda: KolodaView) -> POPPropertyAnimation? {
        let animation = POPSpringAnimation(propertyNamed: kPOPViewFrame)
        animation.springBounciness = frameAnimationSpringBounciness
        animation.springSpeed = frameAnimationSpringSpeed
        return animation
    }
}

//MARK: KolodaViewDataSource
extension BackgroundAnimationViewController: KolodaViewDataSource {

    func kolodaNumberOfCards(koloda: KolodaView) -> UInt {
        return numberOfCards
    }

    func koloda(koloda: KolodaView, viewForCardAtIndex index: UInt) -> UIView {
        let designInfo = designInfosOverlayViews[Int(index)].designInfo

        let screenBounds: CGRect = UIScreen.mainScreen().bounds;
        let mainView = UIView(frame: CGRectMake(0, 0, screenBounds.size.width - 20, screenBounds.size.height - 220))

        //get design UIImageView
        var designImage = UIImage()
        let designImageView = UIImageView(frame: CGRectMake(0, 50, mainView.bounds.size.width, mainView.bounds.size.height - 140))
        if let url = NSURL(string: designInfo["designImgUrl"]!) {
            if let data = NSData(contentsOfURL: url) {
                designImage = UIImage(data: data)!
                designImageView.image = designImage
                designImageView.contentMode = UIViewContentMode.ScaleAspectFit
            }
        }

        //get design title UILabel
        let designNameLabel = UILabel(frame: CGRectMake(0, 20, mainView.bounds.size.width, 20))
        designNameLabel.text = designInfo["designName"]
        designNameLabel.textAlignment = NSTextAlignment.Center
        designNameLabel.font = UIFont(name: "Helvetica Neue", size: 20)


        //create UIView for artist attribution
        let artistAttributionView = UIView(frame: CGRectMake(mainView.bounds.size.width / 5, mainView.bounds.size.height - 70, mainView.bounds.size.width / 2, 50))
        let artistAttributionTextView = UIView(frame: CGRectMake(artistAttributionView.bounds.size.width / 3, 0, artistAttributionView.bounds.size.width * (2/3), 50))

        //get artist profile UIImageView
        let artistProfileImageView = UIImageView(frame: CGRectMake(0, 0, 50, 50))
        if let url = NSURL(string: designInfo["artistProfileImgUrl"]!) {
            if let data = NSData(contentsOfURL: url) {
                let artistProfileImage = UIImage(data: data)!
                artistProfileImageView.image = artistProfileImage
                artistProfileImageView.contentMode = UIViewContentMode.ScaleAspectFit;
                artistProfileImageView.layer.cornerRadius = artistProfileImageView.frame.size.width/2
                artistProfileImageView.clipsToBounds = true
            }
        }

        //get artist name UILabel
        let artistNameLabel = UILabel(frame: CGRectMake(0, 0, artistAttributionView.bounds.size.width, 20))
        artistNameLabel.text = "by " + designInfo["artistName"]!
        artistNameLabel.textAlignment = NSTextAlignment.Left
        artistNameLabel.font = UIFont(name: "Helvetica Neue", size: 16)

        //get artist location UILabel
        let artistLocationLabel = UILabel(frame: CGRectMake(0, 30, artistAttributionView.bounds.size.width, 20))
        artistLocationLabel.text = designInfo["artistLocation"]
        artistLocationLabel.textAlignment = NSTextAlignment.Left
        artistLocationLabel.font = UIFont(name: "Helvetica Neue", size: 16)

        //construct artist attribution view
        artistAttributionTextView.addSubview(artistNameLabel)
        artistAttributionTextView.addSubview(artistLocationLabel)
        artistAttributionView.addSubview(artistAttributionTextView)
        artistAttributionView.addSubview(artistProfileImageView)

        //construct main view
        mainView.addSubview(designImageView)
        mainView.addSubview(designNameLabel)
        mainView.addSubview(artistAttributionView)

        return mainView
    }

    func koloda(koloda: KolodaView, viewForCardOverlayAtIndex index: UInt) -> OverlayView? {
        return NSBundle.mainBundle().loadNibNamed("CustomOverlayView",
            owner: self, options: nil)[0] as? OverlayView
    }
}
