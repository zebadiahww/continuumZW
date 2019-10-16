//
//  SearchableRecord.swift
//  Continuum
//
//  Created by Zebadiah Watson on 10/16/19.
//  Copyright © 2019 Zebadiah Watson. All rights reserved.
//

import UIKit
import CloudKit

protocol SearchableRecord {
  func matches(searchTerm: String) -> Bool
}
