//
//  SongSearchPresenter.swift
//  Rhy
//
//  Created by Roman Abuzyarov on 08.03.2018.
//  Copyright (c) 2018 Roman Abuzyarov. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol SongSearchPresentationLogic
{
    func presentSearchResults(response: SongSearch.Search.Response)
    func presentRecent(response: SongSearch.Recent.Response)
    func presentSongs(response: SongSearch.Songs.Response)
}

class SongSearchPresenter: SongSearchPresentationLogic
{
    weak var viewController: SongSearchDisplayLogic?
    
    // MARK: Do something
    
    func presentSearchResults(response: SongSearch.Search.Response)
    {
        let viewModel = SongSearch.Search.ViewModel(items:
            response.items.map {
                SongItem(from: $0)
        })
        DispatchQueue.main.async {
            self.viewController?.displaySearchResults(viewModel: viewModel)
        }
    }
    
    func presentRecent(response: SongSearch.Recent.Response)
    {
        let viewModel = SongSearch.Recent.ViewModel(items:
            response.items.map {
                SongItem(from: $0)
        })
        DispatchQueue.main.async {
            self.viewController?.displayRecent(viewModel: viewModel)
        }
    }
    
    func presentSongs(response: SongSearch.Songs.Response)
    {
        let viewModel = SongSearch.Songs.ViewModel(items:
            response.items.map {
                SongItem(from: $0)
        })
        DispatchQueue.main.async {
            self.viewController?.displaySongs(viewModel: viewModel)
        }
    }
}


struct SongItem{
    var artistName: String
    var name: String
    var albumName: String
    var id: String
    var url: URL
    
    init(from item: MediaItem){
        artistName = item.artistName
        name = item.name
        albumName = item.albumName
        id = item.identifier
        let size = CGSize(width: item.artwork.width, height: item.artwork.height)
        url = item.artwork.imageURL(size: size)
    }
}
