//
//  SchoolsModel.swift
//  nycschools
//
//  Created by Jportdev on 6/12/21.
//

import Foundation
/*
  The modal was simple as I only need 2 fields for the first call.
  dbn - which is the school identifier and was require field to make the second call
  school_name - pretty self identifying.
 */
class SchoolModel: Codable {
    var dbn: String
    var school_name: String
    
    init (_dbn: String, _school_name: String) {
        self.dbn = _dbn
        self.school_name = _school_name
        
    }
}
