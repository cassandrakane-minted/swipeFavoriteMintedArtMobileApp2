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

// TODO: hookup with backend
private let temporaryDesignInfos: Array = [
    [
        "artistName": "Annie Walker",
        "designName": "Wreath of love",
        "artistLocation": "Dallas, Texas",
        "designImgUrl": "http://cdn4.minted.com/2016/08/03/17/02/18/cb486bcb453fc7893124cd1cfc34c615",
        "artistProfileImgUrl": "http://cdn3.minted.com/files/content/designers/200_687294_5532e1dea8b00.jpg"
    ],
    [
        "artistName": "Melissa Casey",
        "designName": "Merry & Happy Holiday",
        "artistLocation": "Batavia, Illinois",
        "designImgUrl": "http://cdn4.minted.com/2016/08/03/16/59/53/9e23a509d96119c0e0ffaa60b1a59e95",
        "artistProfileImgUrl": "http://cdn3.minted.com/files/content/designers/200_294616_54bbe16b42144.jpg"
    ],
    [
        "artistName": "Alexandra Dzh",
        "designName": "Holiday decorations",
        "artistLocation": "Vienna, Austria",
        "designImgUrl": "http://cdn4.minted.com/2016/08/03/21/31/43/6b38bbd0098e62838a2d4dd1141a6bd4",
        "artistProfileImgUrl": "http://cdn3.minted.com/files/content/designers/200_598545_5550ebacedd75.jpg"
    ],
    [
        "artistName": "Belia Simm",
        "designName": "Holiday Gifts",
        "artistLocation": "Fishkill, New York",
        "designImgUrl": "http://cdn4.minted.com/2016/08/05/04/35/49/2d1c8bdc6079baf35ad0d35f73eba9e5",
        "artistProfileImgUrl": "http://cdn3.minted.com/files/content/designers/200_1025994_25d5e6cad5cd8.jpg"
    ],
    [
        "artistName": "Ampersand Design Studio",
        "designName": "Paint Strokes",
        "artistLocation": "Kansas City",
        "designImgUrl": "http://cdn4.minted.com/2016/08/03/16/59/05/48794b9de5b2b566f4ed69de1345ffe1",
        "artistProfileImgUrl": "http://cdn3.minted.com/files/content/designers/200_163057_50b3ba9db67cc.jpg"
    ],
    [
        "artistName": "Alexandra Dzh",
        "designName": "Holiday pattern",
        "artistLocation": "Vienna, Austria",
        "designImgUrl": "http://cdn4.minted.com/2016/08/03/21/00/49/cf256295e4e5919071c764dac8590fb2",
        "artistProfileImgUrl": "http://cdn3.minted.com/files/content/designers/200_598545_5550ebacedd75.jpg"
    ],
    [
        "artistName": "Melissa Casey",
        "designName": "Shining Star",
        "artistLocation": "Batavia, Illinois",
        "designImgUrl": "http://cdn4.minted.com/2016/08/04/17/27/53/5d8186c5b860cc95af7895b676b3b1fd",
        "artistProfileImgUrl": "http://cdn3.minted.com/files/content/designers/200_294616_54bbe16b42144.jpg"
    ],
    [
        "artistName": "Kristen Smith",
        "designName": "Christmas Crest",
        "artistLocation": "Augusta, Georgia",
        "designImgUrl": "http://cdn4.minted.com/2016/08/03/17/39/40/476f1ee53014ea70f490caefe8bc33c4",
        "artistProfileImgUrl": "http://cdn3.minted.com/files/content/designers/200_52505_551186d47bcc9.jpg"
    ],
    [
        "artistName": "Karidy Walker",
        "designName": "Let's be Jolly",
        "artistLocation": "Anacortes, Washington",
        "designImgUrl": "http://cdn4.minted.com/2016/08/03/16/59/19/2b89a6fcf965865156ee94be305af0f6",
        "artistProfileImgUrl": "http://cdn3.minted.com/files/content/designers/200_382687_a5ff5e1d70443.jpg"
    ],
    [
        "artistName": "jeanne smith",
        "designName": "All I Want for Christmas",
        "artistLocation": "San Diego, California",
        "designImgUrl": "http://cdn4.minted.com/2016/08/03/19/05/48/1771bb09f9fe1e20df760abeb1403184",
        "artistProfileImgUrl": "http://cdn3.minted.com/files/content/designers/200_276464_7939b3b2b85db.jpg"
    ]
]

private let numberOfCards: UInt = UInt(temporaryDesignInfos.count)
private let frameAnimationSpringBounciness: CGFloat = 9
private let frameAnimationSpringSpeed: CGFloat = 16
private let kolodaCountOfVisibleCards = 2
private let kolodaAlphaValueSemiTransparent: CGFloat = 0.1


class BackgroundAnimationViewController: UIViewController {

    @IBOutlet weak var kolodaView: CustomKolodaView!
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        kolodaView.alphaValueSemiTransparent = kolodaAlphaValueSemiTransparent
        kolodaView.countOfVisibleCards = kolodaCountOfVisibleCards
        kolodaView.delegate = self
        kolodaView.dataSource = self
        kolodaView.animator = BackgroundKolodaAnimator(koloda: kolodaView)
        
        self.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
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
        let designInfo = temporaryDesignInfos[Int(index)]
        
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
        designNameLabel.font = UIFont(name: "Courier", size: 20)
    
        
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
        artistNameLabel.text = designInfo["artistName"]
        artistNameLabel.textAlignment = NSTextAlignment.Left
        artistNameLabel.font = UIFont(name: "Courier", size: 16)
        
        //get artist location UILabel
        let artistLocationLabel = UILabel(frame: CGRectMake(0, 30, artistAttributionView.bounds.size.width, 20))
        artistLocationLabel.text = designInfo["artistLocation"]
        artistLocationLabel.textAlignment = NSTextAlignment.Left
        artistLocationLabel.font = UIFont(name: "Courier", size: 16)
        
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
