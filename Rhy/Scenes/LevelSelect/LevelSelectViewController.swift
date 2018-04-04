//
//  LevelSelectViewController.swift
//  Rhy
//
//  Created by Roman Abuzyarov on 24.03.2018.
//  Copyright (c) 2018 Roman Abuzyarov. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol LevelSelectDisplayLogic: class
{
    func displayLevels(viewModel: LevelSelect.Something.ViewModel)
}

class LevelSelectViewController: UIViewController, LevelSelectDisplayLogic
{
    var interactor: LevelSelectBusinessLogic?
    var router: (NSObjectProtocol & LevelSelectRoutingLogic & LevelSelectDataPassing)?
    
    @IBOutlet weak var collectionView: UICollectionView!
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup()
    {
        let viewController = self
        let interactor = LevelSelectInteractor()
        let presenter = LevelSelectPresenter()
        let router = LevelSelectRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    private func registerNibs(){
        self.collectionView.register(UINib(nibName: "LevelSelectCell", bundle: nil), forCellWithReuseIdentifier: ReuseIdentifiers.LevelSelectCell)
        self.collectionView.register(UINib(nibName: "NewLevelCell", bundle: nil), forCellWithReuseIdentifier: ReuseIdentifiers.NewLevelCell)
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if let flow = collectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            flow.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width - (8*2), height: 100)
        }
        
        registerNibs()
        requestLevels()
    }
    
    // MARK: Do something
    
    //@IBOutlet weak var nameTextField: UITextField!
    
    func requestLevels()
    {
        let request = LevelSelect.Something.Request()
        interactor?.loadLevels(request: request)
    }
    
    var levels : [Level]?
    
    func displayLevels(viewModel: LevelSelect.Something.ViewModel)
    {
        levels = viewModel.levels
        collectionView.reloadData()
    }
}

extension LevelSelectViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row != 0{
            guard let item = levels?[indexPath.row - 1] else {return}
            guard let destination = storyboard?.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController else {return}
            destination.level = item
            destination.songId = (interactor as? LevelSelectDataStore)?.songId ?? ""
            
            show(destination, sender: self)
        }
        else{
            router?.routeToPreLevelCreate(segue: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (levels?.count ?? 0) + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifiers.NewLevelCell, for: indexPath) as? NewLevelCell else { return UICollectionViewCell() }
            
            return cell
        }
        else {
            guard let item = levels?[indexPath.row - 1] else { return UICollectionViewCell() }
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifiers.LevelSelectCell, for: indexPath) as? LevelSelectCell else {return UICollectionViewCell()}
            
            cell.fill(with: item)
            
            return cell
        }
    }
}
