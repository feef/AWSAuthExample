//
//  ResultGeneratingOperation.swift
//  AWSAuthExample
//
//  Created by sharif ahmed on 4/11/18.
//  Copyright © 2018 sharif ahmed. All rights reserved.
//

import Foundation

protocol ResultGeneratingOperation {
    associatedtype ResultType
    var onComplete: (Result<ResultType>) -> Void { get }
}
