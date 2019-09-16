//
//  GalleryViewController.swift
//  Notes
//
//  Created by Kateryna Kozlova on 21/07/2019.
//  Copyright © 2019 Kateryna Kozlova. All rights reserved.
//

import UIKit
import Photos

class GalleryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCollectionViewCell
        cell.photoImageView.image = photos[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "PhotoViewerVC") as! PhotoViewerViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            tempImage = pickedImage
            photos.append(pickedImage)
            PhotoViewerViewController.photos.append(pickedImage)
            collectionView.reloadData()
        }
        dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
        
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    var photos: [UIImage] = [#imageLiteral(resourceName: "first.jpeg"), #imageLiteral(resourceName: "second.jpeg"), #imageLiteral(resourceName: "third.jpg"), #imageLiteral(resourceName: "fourth.jpg"), #imageLiteral(resourceName: "fifth.jpeg"), #imageLiteral(resourceName: "sixth.jpg"), #imageLiteral(resourceName: "seventh.jpeg"), #imageLiteral(resourceName: "eighth.jpeg"), #imageLiteral(resourceName: "ninth.jpeg"), #imageLiteral(resourceName: "tenth.jpeg")]
    var imagePicker = UIImagePickerController()
    var tempImage: UIImage?

    override func viewDidLoad()
    {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addButtonTapped(sender:)))
    }
    
    @objc func addButtonTapped(sender: UIBarButtonItem)
    {
        present(imagePicker, animated: true, completion: nil)
        
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
