//
//  PhotoViewerViewController.swift
//  Notes
//
//  Created by Kateryna Kozlova on 26/07/2019.
//  Copyright © 2019 Kateryna Kozlova. All rights reserved.
//

import UIKit

class PhotoViewerViewController: UIViewController, UIScrollViewDelegate
{
    @IBOutlet weak var scrollView: UIScrollView!
    static var photos: [UIImage] = [#imageLiteral(resourceName: "first.jpeg"), #imageLiteral(resourceName: "second.jpeg"), #imageLiteral(resourceName: "third.jpg"), #imageLiteral(resourceName: "fourth.jpg"), #imageLiteral(resourceName: "fifth.jpeg"), #imageLiteral(resourceName: "sixth.jpg"), #imageLiteral(resourceName: "seventh.jpeg"), #imageLiteral(resourceName: "eighth.jpeg"), #imageLiteral(resourceName: "ninth.jpeg"), #imageLiteral(resourceName: "tenth.jpeg")]
    var imageViews = [UIImageView]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        for photo in PhotoViewerViewController.photos
        {
            let image = photo
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            scrollView.addSubview(imageView)
            imageViews.append(imageView)
        }
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        for (index, imageView) in imageViews.enumerated()
        {
            imageView.frame.size = scrollView.frame.size
            imageView.frame.origin.x = scrollView.frame.width * CGFloat(index)
            imageView.frame.origin.y = 0
        }
        let contentWidth = scrollView.frame.width * CGFloat(imageViews.count)
        scrollView.contentSize = CGSize(width: contentWidth, height: scrollView.frame.height)
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
