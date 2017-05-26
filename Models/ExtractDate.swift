import Mapper

extension Mapper.Transform {

    static func extractDateFromTimeInterval(value: Any?) throws -> Date {
        guard let seconds = value as? Int else {
            throw MapperError.convertibleError(value: value, type: Date.self)
        }
        return Date(timeIntervalSince1970: TimeInterval(seconds))
    }

}
