//
//  PhotoCollectionViewCell.swift
//  Notes
//
//  Created by Kateryna Kozlova on 22/07/2019.
//  Copyright © 2019 Kateryna Kozlova. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell
{
    @IBOutlet weak var photoImageView: UIImageView!
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
}
