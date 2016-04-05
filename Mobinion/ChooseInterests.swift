//
//  ChooseInterests.swift
//  Mobinion
//
//  Created by Mohammed Shaneeb on 3/23/16.
//  Copyright © 2016 Novateurglow. All rights reserved.
//

import UIKit

class ChooseInterests: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource
{
//    @IBOutlet weak var backBtn: UIBarButtonItem!
    @IBOutlet weak var navTitle: UINavigationItem!
//    @IBOutlet weak var addBtn: UIBarButtonItem!
    
    @IBOutlet weak var searchHeaderImage: UIImageView!
    @IBOutlet weak var searchBarField: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let reuseIdentifier = "Cell"
    let recipePhotos: [String] = ["angry_birds_cake.jpg",
                                  "creme_brelee.jpg",
                                  "egg_benedict.jpg",
                                  "full_breakfast.jpg",
                                  "green_tea.jpg",
                                  "ham_and_cheese_panini.jpg",
                                  "ham_and_egg_sandwich.jpg",
                                  "hamburger.jpg",
                                  "instant_noodle_with_egg.jpg",
                                  "japanese_noodle.jpg",
                                  "mushroom_risotto.jpg",
                                  "noodle_with_bbq.jpg",
                                  "starbucks_coffee.jpg",
                                  "thai_shrimp_cake.jpg",
                                  "vegetable_curry.jpg",
                                  "white_chocolate_donut.jpg"]
    
    var selectedPhotos = [String]()
    
    var sharing: Bool = false
    {
        didSet
        {
            collectionView.allowsMultipleSelection = sharing
            collectionView.selectItemAtIndexPath(nil, animated: true, scrollPosition: .None)
            selectedPhotos.removeAll(keepCapacity: false)
        }
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        [collectionView.registerClass(InterestsCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")]
        let nib:UINib = UINib(nibName: "InterestsCollectionViewCell", bundle: nil)
        collectionView.registerNib(nib, forCellWithReuseIdentifier: "Cell")
        
        [collectionView.registerClass(InterestsCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header")]
        let nib2:UINib = UINib(nibName: "InterestsCollectionReusableView", bundle: nil)
        collectionView.registerNib(nib2, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header")
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return recipePhotos.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! InterestsCollectionViewCell
        
        let image = UIImage(named: recipePhotos[indexPath.row])
        cell.viewWithTag(100)
        cell.intImg.image = image
        cell.intImg.clipsToBounds=true
        cell.intImg.layer.cornerRadius=10.0
        
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        if sharing
        {
//            var photo: [String] = [recipePhotos[indexPath.section],
//                                   recipePhotos[indexPath.row]]
            
//            selectedPhotos.append(photo)
            
        }
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath)
    {
        if sharing
        {
            
        }
    }
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        if sharing
        {
            return true
        }
        
        return false
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView
    {
        switch kind
        {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "Header", forIndexPath: indexPath) as! InterestsCollectionReusableView
            
            headerView.headerLabel.text = "CHOOSE TOPICS"
            headerView.headerLabel.font=UIFont (name: "Helvetica Neue", size: 20.0)
            return headerView
            
        default:
            assert(false, "Unexpected data element")
        }
    }
    
//    @IBAction func backBtn(sender: UIBarButtonItem)
//    {
////        print("back pressed!!!")
//        self.navigationController?.popViewControllerAnimated(true)
//    }
    
    @IBAction func backBtn(segue: UIStoryboardSegue)
    {
        print("back pressed!!!")
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func addBtn(sender: AnyObject)
    {
        if selectedPhotos.isEmpty
        {
            
        }
        
        sharing = !sharing
    }
}

