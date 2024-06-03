//
//  Extentions.swift
//  My Score
//
//  Created by admin on 16.04.2024.
//

import UIKit

extension UIImageView{
    
    func loadImageFromURL(_ url: URL) {
        // Создаем URLSession
        let session = URLSession.shared
        
        // Создаем задачу для загрузки данных по URL
        let task = session.dataTask(with: url) { (data, response, error) in
            // Проверяем наличие ошибок
            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
                return
            }
            
            // Проверяем, получены ли данные
            guard let data = data else {
                print("No data received")
                return
            }
            
            // Создаем изображение из данных
            if let image = UIImage(data: data) {
                // Обновляем интерфейс в главном потоке
                DispatchQueue.main.async {
                    // Устанавливаем изображение в UIImageView
                    self.image = image
                }
            } else {
                print("Failed to create UIImage from data")
            }
        }
        
        // Запускаем задачу
        task.resume()
    }
}

