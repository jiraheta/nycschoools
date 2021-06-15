//
//  SchoolDetailsModel.swift
//  nycschools
//
//  Created by Jportdev on 6/13/21.
//

import Foundation
/*
  I wish I would have more time I would have included more data from the previous call
  but due to time constrains I figure this would be sufficient to have an idea of my
  coding style.
 */
class SchoolDetailsModel: Codable {
    var dbn: String
    var school_name: String
    var num_of_sat_test_takers: String
    var sat_critical_reading_avg_score: String
    var sat_math_avg_score: String
    var sat_writing_avg_score: String
    
    init (_dbn: String,
          _school_name: String,
          _num_of_sat_test_takers: String,
          _sat_critical_reading_avg_score: String,
          _sat_math_avg_score: String,
          _sat_writing_avg_score: String) {
        self.dbn = _dbn
        self.school_name = _school_name
        self.num_of_sat_test_takers = _num_of_sat_test_takers
        self.sat_critical_reading_avg_score = _sat_critical_reading_avg_score
        self.sat_math_avg_score = _sat_math_avg_score
        self.sat_writing_avg_score = _sat_writing_avg_score
    }
}
