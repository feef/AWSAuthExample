//
//  Result.swift
//  AWSAuthExample
//
//  Created by sharif ahmed on 4/11/18.
//  Copyright © 2018 sharif ahmed. All rights reserved.
//

import Foundation

enum Result<ResultType> {
    case success(ResultType)
    case failure(Error?)
}
