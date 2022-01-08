//
//  YYClassInfo.swift
//  YYModel
//
//  Created by lzh on 2022/1/7.
//

import Foundation
import ObjectiveC.runtime

/**
 Type encoding's type.
 */
public struct YYEncodingType: OptionSet {
    public let rawValue: UInt
    
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    
    
    ///< mask of type value
    public static let mask: YYEncodingType = .init(rawValue: 0xFF)
    
    ///< unknown
    public static let unknown: YYEncodingType = .init(rawValue: 0)
    
    ///< void
    public static let void: YYEncodingType = .init(rawValue: 1)
    
    ///< bool
    public static let bool: YYEncodingType = .init(rawValue: 2)
    
    ///< char / BOOL
    public static let int8: YYEncodingType = .init(rawValue: 3)
    
    ///< unsigned char
    public static let uInt8: YYEncodingType = .init(rawValue: 4)
    
    ///< short
    public static let int16: YYEncodingType = .init(rawValue: 5)
    
    ///< unsigned short
    public static let uInt16: YYEncodingType = .init(rawValue: 6)
    
    ///< int
    public static let int32: YYEncodingType = .init(rawValue: 7)
    
    ///< unsigned int
    public static let uInt32: YYEncodingType = .init(rawValue: 8)
    
    ///< long long
    public static let int64: YYEncodingType = .init(rawValue: 9)
    
    ///< unsigned long long
    public static let uInt64: YYEncodingType = .init(rawValue: 10)
    
    ///< float
    public static let float: YYEncodingType = .init(rawValue: 11)
    
    ///< double
    public static let double: YYEncodingType = .init(rawValue: 12)
    
    ///< long double
    public static let longDouble: YYEncodingType = .init(rawValue: 13)
    
    ///< id
    public static let object: YYEncodingType = .init(rawValue: 14)
    
    ///< Class
    public static let `class`: YYEncodingType = .init(rawValue: 15)
    
    ///< SEL
    public static let SEL: YYEncodingType = .init(rawValue: 16)
    
    ///< block
    public static let block: YYEncodingType = .init(rawValue: 17)
    
    ///< void*
    public static let pointer: YYEncodingType = .init(rawValue: 18)
    
    ///< struct
    public static let `struct`: YYEncodingType = .init(rawValue: 19)
    
    ///< union
    public static let union: YYEncodingType = .init(rawValue: 20)
    
    ///< char*
    public static let cString: YYEncodingType = .init(rawValue: 21)
    
    ///< char[10] (for example)
    public static let cArray: YYEncodingType = .init(rawValue: 22)
    
    
    ///< mask of qualifier
    public static let qualifierMask: YYEncodingType = .init(rawValue: 0xFF00)
    
    ///< const
    public static let qualifierConst: YYEncodingType = .init(rawValue: 1 << 8)
    
    ///< in
    public static let qualifierIn: YYEncodingType = .init(rawValue: 1 << 9)
    
    ///< inout
    public static let qualifierInout: YYEncodingType = .init(rawValue: 1 << 10)
    
    ///< out
    public static let qualifierOut: YYEncodingType = .init(rawValue: 1 << 11)
    
    ///< bycopy
    public static let qualifierBycopy: YYEncodingType = .init(rawValue: 1 << 12)
    
    ///< byref
    public static let qualifierByref: YYEncodingType = .init(rawValue: 1 << 13)
    
    ///< oneway
    public static let qualifierOneway: YYEncodingType = .init(rawValue: 1 << 14)
    
    
    ///< mask of property
    public static let propertyMask: YYEncodingType = .init(rawValue: 0xFF0000)
    
    ///< readonly
    public static let propertyReadonly: YYEncodingType = .init(rawValue: 1 << 16)
    
    ///< copy
    public static let propertyCopy: YYEncodingType = .init(rawValue: 1 << 17)
    
    ///< retain
    public static let propertyRetain: YYEncodingType = .init(rawValue: 1 << 18)
    
    ///< nonatomic
    public static let propertyNonatomic: YYEncodingType = .init(rawValue: 1 << 19)
    
    ///< weak
    public static let propertyWeak: YYEncodingType = .init(rawValue: 1 << 20)
    
    ///< getter=
    public static let propertyCustomGetter: YYEncodingType = .init(rawValue: 1 << 21)
    
    ///< setter=
    public static let propertyCustomSetter: YYEncodingType = .init(rawValue: 1 << 22)
    
    ///< @dynamic
    public static let propertyDynamic: YYEncodingType = .init(rawValue: 1 << 23)
}

/**
 Get the type from a Type-Encoding string.
 
 @discussion See also:
 https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
 https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html
 
 @param typeEncoding  A Type-Encoding string.
 @return The encoding type.
 */
public func _YYEncodingGetType(_ typeEncoding: String?) -> YYEncodingType {
    guard var type = typeEncoding, !type.isEmpty else { return .unknown }
    
    var qualifier: YYEncodingType = .unknown
    
    var i = 0
    for c in type {
        switch c {
        case "r":
            qualifier = qualifier.union(.qualifierConst)
        case "n":
            qualifier = qualifier.union(.qualifierIn)
        case "N":
            qualifier = qualifier.union(.qualifierInout)
        case "o":
            qualifier = qualifier.union(.qualifierOut)
        case "O":
            qualifier = qualifier.union(.qualifierBycopy)
        case "R":
            qualifier = qualifier.union(.qualifierByref)
        case "V":
            qualifier = qualifier.union(.qualifierOneway)
        default:
            break
        }
        
        i += 1
    }
    
    type = String(type.dropFirst(i))
    
    guard !type.isEmpty else { return qualifier }
    
    
    switch type {
    case "v":
        return qualifier.union(.void)
    case "B":
        return qualifier.union(.bool)
    case "c":
        return qualifier.union(.int8)
    case "C":
        return qualifier.union(.uInt8)
    case "s":
        return qualifier.union(.int16)
    case "S":
        return qualifier.union(.uInt16)
    case "i":
        return qualifier.union(.int32)
    case "I":
        return qualifier.union(.uInt32)
    case "l":
        return qualifier.union(.int32)
    case "L":
        return qualifier.union(.uInt32)
    case "q":
        return qualifier.union(.int64)
    case "Q":
        return qualifier.union(.uInt64)
    case "f":
        return qualifier.union(.float)
    case "d":
        return qualifier.union(.double)
    case "D":
        return qualifier.union(.longDouble)
    case "#":
        return qualifier.union(.class)
    case ":":
        return qualifier.union(.SEL)
    case "*":
        return qualifier.union(.cString)
    case "^":
        return qualifier.union(.pointer)
    case "[":
        return qualifier.union(.cArray)
    case "(":
        return qualifier.union(.union)
    case "{":
        return qualifier.union(.struct)
    case "@":
        if type.count == 2 && [Character](type)[1] == "?" {
            return qualifier.union(.block)
        } else {
            return qualifier.union(.object)
        }
    default:
        return qualifier
    }
}

/**
 Instance variable information.
 */
public struct YYClassIvarInfo {
    
    ///< ivar opaque struct
    public var ivar: Ivar
    
    ///< Ivar's name
    public var name: String?
    
    ///< Ivar's offset
    public var offset: Int
    
    ///< Ivar's type encoding
    public var typeEncoding: String?
    
    ///< Ivar's type
    public var type: YYEncodingType = .unknown
    
    
    /**
     Creates and returns an ivar info object.

     @param ivar ivar opaque struct
     @return A new object, or nil if an error occurs.
     */
    public init?(ivar: Ivar?) {
        guard let ivar = ivar else { return nil }
        
        self.ivar = ivar
        
        if let name = ivar_getName(ivar) {
            self.name = String(cString: name)
        }
        
        self.offset = ivar_getOffset(ivar)
        
        if let typeEncoding = ivar_getTypeEncoding(ivar) {
            self.typeEncoding = String(cString: typeEncoding)
            self.type = _YYEncodingGetType(self.typeEncoding)
        }
    }
}

/**
 Method information.
 */
public struct YYClassMethodInfo {
    
    ///< method opaque struct
    public var method: Method
    
    ///< method name
    public var name: String
    
    ///< method's selector
    public var sel: Selector
    
    ///< method's implementation
    public var imp: IMP
    
    ///< method's parameter and return types
    public var typeEncoding: String?
    
    ///< return value's type
    public var returnTypeEncoding: String
    
    ///< array of arguments' type
    public var argumentTypeEncodings: [String]?
    
    
    /**
     Creates and returns a method info object.

     @param method method opaque struct
     @return A new object, or nil if an error occurs.
     */
    public init?(method: Method?) {
        guard let method = method else { return nil }
        
        self.method = method
        
        self.sel = method_getName(method)
        self.imp = method_getImplementation(method)
        
        let name = sel_getName(sel)
        self.name = String(cString: name)

        if let typeEncoding = method_getTypeEncoding(method) {
            self.typeEncoding = String(cString: typeEncoding)
        }
        
        let returnType = method_copyReturnType(method)
        self.returnTypeEncoding = String(cString: returnType)
        free(returnType)
        
        let argumentCount = method_getNumberOfArguments(method)
        if argumentCount > 0 {
            var argumentTypes = [String]()
            for i in 0..<argumentCount {
                let argumentType = method_copyArgumentType(method, i)
                let type = argumentType != nil ? String(cString: argumentType!) : nil
                argumentTypes.append(type ?? "")
                if argumentType != nil {
                    free(argumentType)
                }
            }
            self.argumentTypeEncodings = argumentTypes
        }
    }
}

///**
// Property information.
// */
//open class YYClassPropertyInfo : NSObject {
//
//    ///< property's opaque struct
//    open var property: objc_property_t { get }
//
//    ///< property's name
//    open var name: String { get }
//
//    ///< property's type
//    open var type: YYEncodingType { get }
//
//    ///< property's encoding value
//    open var typeEncoding: String { get }
//
//    ///< property's ivar name
//    open var ivarName: String { get }
//
//    ///< may be nil
//    open var cls: AnyClass? { get }
//
//    ///< may nil
//    open var protocols: [String]? { get }
//
//    ///< getter (nonnull)
//    open var getter: Selector { get }
//
//    ///< setter (nonnull)
//    open var setter: Selector { get }
//
//
//    /**
//     Creates and returns a property info object.
//
//     @param property property opaque struct
//     @return A new object, or nil if an error occurs.
//     */
//    public init(property: objc_property_t)
//}
//
///**
// Class information for a class.
// */
//open class YYClassInfo : NSObject {
//
//    ///< class object
//    open var cls: AnyClass { get }
//
//    ///< super class object
//    open var superCls: AnyClass? { get }
//
//    ///< class's meta class object
//    open var metaCls: AnyClass? { get }
//
//    ///< whether this class is meta class
//    open var isMeta: Bool { get }
//
//    ///< class name
//    open var name: String { get }
//
//    ///< super class's class info
//    open var `super`: YYClassInfo? { get }
//
//    ///< ivars
//    open var ivarInfos: [String : YYClassIvarInfo]? { get }
//
//    ///< methods
//    open var methodInfos: [String : YYClassMethodInfo]? { get }
//
//    ///< properties
//    open var propertyInfos: [String : YYClassPropertyInfo]? { get }
//
//
//    /**
//     If the class is changed (for example: you add a method to this class with
//     'class_addMethod()'), you should call this method to refresh the class info cache.
//
//     After called this method, `needUpdate` will returns `YES`, and you should call
//     'classInfoWithClass' or 'classInfoWithClassName' to get the updated class info.
//     */
//    open func setNeedUpdate()
//
//
//    /**
//     If this method returns `YES`, you should stop using this instance and call
//     `classInfoWithClass` or `classInfoWithClassName` to get the updated class info.
//
//     @return Whether this class info need update.
//     */
//    open func needUpdate() -> Bool
//
//
//    /**
//     Get the class info of a specified Class.
//
//     @discussion This method will cache the class info and super-class info
//     at the first access to the Class. This method is thread-safe.
//
//     @param cls A class.
//     @return A class info, or nil if an error occurs.
//     */
//    public convenience init?(with cls: AnyClass)
//
//
//    /**
//     Get the class info of a specified Class.
//
//     @discussion This method will cache the class info and super-class info
//     at the first access to the Class. This method is thread-safe.
//
//     @param className A class name.
//     @return A class info, or nil if an error occurs.
//     */
//    public convenience init?(className: String)
//}
