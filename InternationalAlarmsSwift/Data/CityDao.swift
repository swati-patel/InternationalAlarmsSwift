import Foundation

class CityDao {
    static var cityList: [City]?
    static var cityDataList: [[Any]]?
    static var lastRegionID: Int = 0
    static var USACities: [City]?
    static var dbHelper = DatabaseHelper.shared
    
    static let selectCity = "select cityid, countryid, regionid, city, timezonestring from Cities"
    static let numCols = 5
    
    static func getCityListByRegion(regionId: Int) -> [City]? {
        let query = "\(selectCity) where regionid=\(regionId)"
        cityDataList = dbHelper.executeSelectQueryWithNumCols(numCols: numCols, query: query)
        cityList = []
        
        for row in cityDataList ?? [] {
            guard row.count >= 5 else { continue }
            
            let cityId = (row[0] as? NSNumber)?.intValue ?? 0
            let countryId = (row[1] as? NSNumber)?.intValue ?? 0
            let regionId = (row[2] as? NSNumber)?.intValue ?? 0
            let name = row[3] as? String ?? ""
            let timezone = row[4] as? String ?? ""
            
            let city = City(
                cityId: cityId,
                countryId: countryId,
                regionId: regionId,
                name: name,
                timezone: timezone
            )
            cityList?.append(city)
        }
        return cityList
    }
    
    static func getCityListByCountry(countryId: Int) -> [City]? {
        let query = "\(selectCity) where countryid=\(countryId)"
        print("In getCityListByCountry: query: " + query)
        cityDataList = dbHelper.executeSelectQueryWithNumCols(numCols: numCols, query: query)
        cityList = []
        
        for row in cityDataList ?? [] {
            guard row.count >= 5 else { continue }
            
            let name = row[3] as? String ?? ""
            if name == "AOL" {
                continue
            }
            
            let cityId = (row[0] as? NSNumber)?.intValue ?? 0
            let countryId = (row[1] as? NSNumber)?.intValue ?? 0
            let regionId = (row[2] as? NSNumber)?.intValue ?? 0
            let timezone = row[4] as? String ?? ""
            
            let city = City(
                cityId: cityId,
                countryId: countryId,
                regionId: regionId,
                name: name,
                timezone: timezone
            )
            cityList?.append(city)
        }
        return cityList
    }
    
    static func getCityNameById(id: Int) -> String? {
        let query = "\(selectCity) where cityid=\(id)"
        let list = dbHelper.executeSelectQueryWithNumCols(numCols: numCols, query: query)
        
        if let first = list?.first, first.count >= 4 {
            return first[3] as? String
        }
        return nil
    }
    
    static func getCityName(id: Int) -> String? {
        return CityDao.getCityNameById(id: id)
    }
    
    static func getCityNameByCityId(cityIdVal: Int, countryId countryIdVal: Int) -> String? {
        var countryIdVal = countryIdVal
        
        // SPECIAL CASE FOR ZAIRE - OFFICIAL NAME NOW IS Democratic Republic of the Congo
        
        // YES I KNOW I AM HARDCODING THIS.  FEELING V. LAZY.
        if countryIdVal == 272 {
            countryIdVal = 55
        }
        
        let query = "select city from cities where cityid=\(cityIdVal) and countryid=\(countryIdVal)"
        let list = dbHelper.executeSelectQueryWithNumCols(numCols: numCols, query: query)
        
        if let first = list?.first, first.count >= 1 {
            return first[0] as? String
        }
        return nil
    }
    
    static func getCityById(cityId: Int) -> City? {
        let query = "\(selectCity) where cityid=\(cityId)"
        let list = dbHelper.executeSelectQueryWithNumCols(numCols: numCols, query: query)
        
        if let first = list?.first, first.count >= 5 {
            let cityId = (first[0] as? NSNumber)?.intValue ?? 0
            let countryId = (first[1] as? NSNumber)?.intValue ?? 0
            let regionId = (first[2] as? NSNumber)?.intValue ?? 0
            let name = first[3] as? String ?? ""
            let timezone = first[4] as? String ?? ""
            
            return City(
                cityId: cityId,
                countryId: countryId,
                regionId: regionId,
                name: name,
                timezone: timezone
            )
        }
        return nil
    }
    
    static func lookupUSA() {
        if USACities == nil {
            USACities = self.getCityListByCountry(countryId: 254)
        }
    }
}
