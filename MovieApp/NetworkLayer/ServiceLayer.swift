//
//  ServiceLayer.swift
//  MovieApp
//
//  Created by Madan on 20/11/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import Foundation




class ServiceLayer {
    
    let defaulatSession = URLSession(configuration: .default)
    var dataTask:URLSessionDataTask? = nil
    
    func formateURL(urlString:String?) -> String{
        
        if let urlString = urlString{
            let completeURLString = GlobalConstants.kBaseURL + urlString + GlobalConstants.kAPIKEY
            return completeURLString
        }
        return ""
    }
    
    func servcieRequestMovies(urlString: String, withCompletion completion: @escaping (Movies?, String?) -> Void)
    {
        cancelReuest()
        guard let url = URL(string: formateURL(urlString: urlString)) else {
            return
        }
        print(url)
        let request = RequestFactory.request(method: .GET, url: url)
        
        dataTask = defaulatSession.dataTask(with:request, completionHandler: { (data: Data?, response: URLResponse?,
            error: Error?) -> Void in
            
            if let error = error{
                completion(nil, error.localizedDescription)
                return
            }
            
            guard let data = data else {
                completion(nil, nil)
                return
            }
            
            do{
                let movies = try JSONDecoder().decode(Movies.self, from: data)
                completion(movies,nil)
            }
            catch let err{
                print(err.localizedDescription)
                return
            }
        })
        dataTask?.resume()
    }
    
    
    
    func servcieRequestDetails(urlString: String, withCompletion completion: @escaping (Details?, String?) -> Void)
    {
        cancelReuest()
        guard let url = URL(string: formateURL(urlString: urlString)) else {
            return
        }
        print(url)
        let request = RequestFactory.request(method: .GET, url: url)
        
        dataTask = defaulatSession.dataTask(with:request, completionHandler: { (data: Data?, response: URLResponse?,
            error: Error?) -> Void in
            
            if let error = error{
                completion(nil, error.localizedDescription)
                return
            }
            
            guard let data = data else {
                completion(nil, nil)
                return
            }
            
            do{
                let moviesDetails = try JSONDecoder().decode(Details.self, from: data)
                completion(moviesDetails,nil)
            }
            catch let err{
                print(err.localizedDescription)
                assertionFailure("Error decoding Photo: \(err)")
                return
            }
        })
        dataTask?.resume()
    }
    
    
    func servcieRequestCollection(urlString: String, withCompletion completion: @escaping (CollectionMovies?, String?) -> Void)
    {
        cancelReuest()
        guard let url = URL(string: formateURL(urlString: urlString)) else {
            return
        }
        print(url)
        let request = RequestFactory.request(method: .GET, url: url)
        
        dataTask = defaulatSession.dataTask(with:request, completionHandler: { (data: Data?, response: URLResponse?,
            error: Error?) -> Void in
            
            if let error = error{
                completion(nil, error.localizedDescription)
                return
            }
            
            guard let data = data else {
                completion(nil, nil)
                return
            }
            
            do{
                let collectionList = try JSONDecoder().decode(CollectionMovies.self, from: data)
                print(collectionList)
                completion(collectionList,nil)
            }
            catch let err{
                print(err.localizedDescription)
                return
            }
        })
        dataTask?.resume()
    }
    func cancelReuest()  {
        if let dataTask = dataTask{
            dataTask.cancel()
        }
        dataTask = nil
    }
    
}
