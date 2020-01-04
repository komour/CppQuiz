//
//  QuestionRequest.swift
//  CppQuiz
//
//  Created by Always Strive And Prosper on 04.01.2020.
//  Copyright © 2020 komarov. All rights reserved.
//

import Foundation

enum QuestionError:Error {
    case noDataAvailable
    case canNotProcessData
}

struct QuestionRequest {
    let resourceURL:URL = URL(string: "http://cppquiz.org/static/published.json")!
    
    func getQuestions (completion: @escaping(Result<[QuestionJson], QuestionError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: resourceURL) {data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            do {
                let decoder = JSONDecoder()
                let questionResponse = try decoder.decode(QuestionResponse.self, from: jsonData)
                let questionArray = questionResponse.questions
                completion(.success(questionArray))
            } catch {
                completion(.failure(.canNotProcessData))
            }
        }
        dataTask.resume()
    }
        

}


