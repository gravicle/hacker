import Mapper

extension Int32: Convertible {

    public static func fromMap(_ value: Any) throws -> Int32 {
        guard let integerValue = value as? Int else {
            throw MapperError.convertibleError(value: value, type: Int32.self)
        }

        return Int32(integerValue)
    }

}
