//
//  UserEnum.swift
//  RobsJobs
//
//  Created by MacBook on 6/13/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import Foundation

enum JsonData: String{
    case id = "id"
    case data = "data"
    case curr_employment_sector = "curr_employment_sector"
    case city = "city"
    case province
    case edu_level
    case employment_type
    case sectors
    case birthdate
    case image
    case skills
    case bio
    case portofolio
    case email
    case name
    case mobile_number
    case salary
    case salary_min = "salary_min"
    case salary_max
    case distance
    case emp_status
    case kompetensi
    case jurusan
    case experience
}

enum API_ROBSJOBS: String{
    case api = "http://api.robsjobs.co/api/v1"
//    case api_dev = "http://apidev.robsjobs.co/api/v1"
}
