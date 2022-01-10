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
public struct EncodingType: OptionSet {
    public let rawValue: UInt
    
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    
    
    ///< mask of type value
    public static let mask: EncodingType = .init(rawValue: 0xFF)
    
    ///< unknown
    public static let unknown: EncodingType = .init(rawValue: 0)
    
    ///< void
    public static let void: EncodingType = .init(rawValue: 1)
    
    ///< bool
    public static let bool: EncodingType = .init(rawValue: 2)
    
    ///< char / BOOL
    public static let int8: EncodingType = .init(rawValue: 3)
    
    ///< unsigned char
    public static let uInt8: EncodingType = .init(rawValue: 4)
    
    ///< short
    public static let int16: EncodingType = .init(rawValue: 5)
    
    ///< unsigned short
    public static let uInt16: EncodingType = .init(rawValue: 6)
    
    ///< int
    public static let int32: EncodingType = .init(rawValue: 7)
    
    ///< unsigned int
    public static let uInt32: EncodingType = .init(rawValue: 8)
    
    ///< long long
    public static let int64: EncodingType = .init(rawValue: 9)
    
    ///< unsigned long long
    public static let uInt64: EncodingType = .init(rawValue: 10)
    
    ///< float
    public static let float: EncodingType = .init(rawValue: 11)
    
    ///< double
    public static let double: EncodingType = .init(rawValue: 12)
    
    ///< long double
    public static let longDouble: EncodingType = .init(rawValue: 13)
    
    ///< id
    public static let object: EncodingType = .init(rawValue: 14)
    
    ///< Class
    public static let `class`: EncodingType = .init(rawValue: 15)
    
    ///< SEL
    public static let SEL: EncodingType = .init(rawValue: 16)
    
    ///< block
    public static let block: EncodingType = .init(rawValue: 17)
    
    ///< void*
    public static let pointer: EncodingType = .init(rawValue: 18)
    
    ///< struct
    public static let `struct`: EncodingType = .init(rawValue: 19)
    
    ///< union
    public static let union: EncodingType = .init(rawValue: 20)
    
    ///< char*
    public static let cString: EncodingType = .init(rawValue: 21)
    
    ///< char[10] (for example)
    public static let cArray: EncodingType = .init(rawValue: 22)
    
    
    ///< mask of qualifier
    public static let qualifierMask: EncodingType = .init(rawValue: 0xFF00)
    
    ///< const
    public static let qualifierConst: EncodingType = .init(rawValue: 1 << 8)
    
    ///< in
    public static let qualifierIn: EncodingType = .init(rawValue: 1 << 9)
    
    ///< inout
    public static let qualifierInout: EncodingType = .init(rawValue: 1 << 10)
    
    ///< out
    public static let qualifierOut: EncodingType = .init(rawValue: 1 << 11)
    
    ///< bycopy
    public static let qualifierBycopy: EncodingType = .init(rawValue: 1 << 12)
    
    ///< byref
    public static let qualifierByref: EncodingType = .init(rawValue: 1 << 13)
    
    ///< oneway
    public static let qualifierOneway: EncodingType = .init(rawValue: 1 << 14)
    
    
    ///< mask of property
    public static let propertyMask: EncodingType = .init(rawValue: 0xFF0000)
    
    ///< readonly
    public static let propertyReadonly: EncodingType = .init(rawValue: 1 << 16)
    
    ///< copy
    public static let propertyCopy: EncodingType = .init(rawValue: 1 << 17)
    
    ///< retain
    public static let propertyRetain: EncodingType = .init(rawValue: 1 << 18)
    
    ///< nonatomic
    public static let propertyNonatomic: EncodingType = .init(rawValue: 1 << 19)
    
    ///< weak
    public static let propertyWeak: EncodingType = .init(rawValue: 1 << 20)
    
    ///< getter=
    public static let propertyCustomGetter: EncodingType = .init(rawValue: 1 << 21)
    
    ///< setter=
    public static let propertyCustomSetter: EncodingType = .init(rawValue: 1 << 22)
    
    ///< @dynamic
    public static let propertyDynamic: EncodingType = .init(rawValue: 1 << 23)
}

/**
 Get the type from a Type-Encoding string.
 
 @discussion See also:
 https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
 https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html
 
 @param typeEncoding  A Type-Encoding string.
 @return The encoding type.
 */
public func EncodingGetType(_ typeEncoding: String?) -> EncodingType {
    guard var type = typeEncoding, !type.isEmpty else { return .unknown }
    
    var qualifier: EncodingType = .unknown
    
    var i = 0
qualloop: for c in type {
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
            break qualloop
        }
        
        i += 1
    }
    
    type = String(type.dropFirst(i))
    
    guard !type.isEmpty else { return qualifier }
    
    
    switch type.first! {
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
public struct ClassIvarInfo {
    
    ///< ivar opaque struct
    public var ivar: Ivar
    
    ///< Ivar's name
    public var name: String?
    
    ///< Ivar's offset
    public var offset: Int
    
    ///< Ivar's type encoding
    public var typeEncoding: String?
    
    ///< Ivar's type
    public var type: EncodingType = .unknown
    
    
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
            self.type = EncodingGetType(self.typeEncoding)
        }
    }
}

/**
 Method information.
 */
public struct ClassMethodInfo {
    
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

/**
 Property information.
 */
public struct ClassPropertyInfo {
    
    ///< property's opaque struct
    public var property: objc_property_t
    
    ///< property's name
    public var name: String
    
    ///< property's type
    public var type: EncodingType
    
    ///< property's encoding value
    public var typeEncoding: String?
    
    ///< property's ivar name
    public var ivarName: String?
    
    ///< may be nil
    public var cls: AnyClass?
    
    ///< may nil
    public var protocols: [String]?
    
    ///< getter (nonnull)
    public var getter: Selector?
    
    ///< setter (nonnull)
    public var setter: Selector?
    
    
    /**
     Creates and returns a property info object.

     @param property property opaque struct
     @return A new object, or nil if an error occurs.
     */
    public init?(property: objc_property_t?) {
        guard let property = property else { return nil }
        
        self.property = property
        
        let name = property_getName(property)
        self.name = String(cString: name)
        
        var type: EncodingType = .unknown
        var attrCount: UInt32 = 0
        let attrs = property_copyAttributeList(property, &attrCount)
        for i in 0..<Int(attrCount) {
            switch [Character](String(cString: attrs![i].name))[0] {
            case "T": // Type encoding
                if let value = attrs?[i].value {
                    self.typeEncoding = String(cString: value)
                    type = EncodingGetType(typeEncoding)
                    
                    if type.intersection(.mask) == .object && !String(cString: value).isEmpty {
                        let scanner = Scanner(string: typeEncoding!)
                        if !scanner.scanString("@\"", into: nil) {
                            continue
                        }
                        
                        var clsName: NSString? = nil
                        if scanner.scanUpToCharacters(from: .init(charactersIn: "\"<"), into: &clsName) {
                            if let clsName = clsName as String?, !clsName.isEmpty {
                                self.cls = objc_getClass(clsName) as? AnyClass
                            }
                        }
                        
                        var protocols = [String]()
                        while scanner.scanString("<", into: nil) {
                            var protoco: NSString? = nil
                            if scanner.scanUpTo(">", into: &protoco) {
                                if let protoco = protoco as String?, !protoco.isEmpty {
                                    protocols.append(protoco)
                                }
                                scanner.scanString(">", into: nil)
                            }
                        }
                        
                        self.protocols = protocols
                    }
                }
            case "V": // Instance variable
                if let value = attrs?[i].value {
                    self.ivarName = String(cString: value)
                }
            case "R":
                type = type.union(.propertyReadonly)
            case "C":
                type = type.union(.propertyCopy)
            case "&":
                type = type.union(.propertyRetain)
            case "N":
                type = type.union(.propertyNonatomic)
            case "D":
                type = type.union(.propertyDynamic)
            case "W":
                type = type.union(.propertyWeak)
            case "G":
                type = type.union(.propertyCustomGetter)
                if let value = attrs?[i].value {
                    self.getter = Selector(String(cString: value))
                }
            case "S":
                type = type.union(.propertyCustomSetter)
                if let value = attrs?[i].value {
                    self.setter = Selector(String(cString: value))
                }
            default:
                break
            }
        }
        
        if attrs != nil {
            free(attrs)
        }
        
        self.type = type
        
        if !self.name.isEmpty {
            if getter == nil {
                getter = Selector(self.name)
            }
            if setter == nil {
                setter = Selector("set\(self.name.first?.uppercased() ?? "")\(self.name.dropFirst())")
            }
        }
    }
}

/**
 Class information for a class.
 */
public class YYClassInfo {
    
    ///< class object
    public var cls: AnyClass
    
    ///< super class object
    public var superCls: AnyClass?
    
    ///< class's meta class object
    public var metaCls: AnyClass?
    
    ///< whether this class is meta class
    public var isMeta: Bool
    
    ///< class name
    public var name: String
    
    ///< super class's class info
    public var `super`: YYClassInfo?
    
    ///< ivars
    public var ivarInfos: [String : ClassIvarInfo]?
    
    ///< methods
    public var methodInfos: [String : ClassMethodInfo]?
    
    ///< properties
    public var propertyInfos: [String : ClassPropertyInfo]?
    
    
    public init?(class cls: AnyClass?) {
        guard let cls = cls else { return nil }
        
        self.cls = cls
        self.superCls = class_getSuperclass(cls)
        self.isMeta = class_isMetaClass(cls)
        
        if !isMeta {
            self.metaCls = objc_getMetaClass(class_getName(cls)) as? AnyClass
        }
        
        self.name = NSStringFromClass(cls)
        
        self.update()
        
        self.super = YYClassInfo.classInfo(with: superCls)
    }
    
    func update() {
        self.ivarInfos = nil
        self.methodInfos = nil
        self.propertyInfos = nil
        
        let cls = self.cls
        var methodCount: UInt32 = 0
        
        if let methods = class_copyMethodList(cls, &methodCount) {
            var methodInfos = [String: ClassMethodInfo]()
            for i in 0..<Int(methodCount) {
                let info = ClassMethodInfo(method: methods[i])
                if let name = info?.name {
                    methodInfos[name] = info
                }
            }
            self.methodInfos = methodInfos
            free(methods)
        }
        
        var propertyCount: UInt32 = 0
        if let properties = class_copyPropertyList(cls, &propertyCount) {
            var propertyInfos = [String: ClassPropertyInfo]()
            for i in 0..<Int(propertyCount) {
                let info = ClassPropertyInfo(property: properties[i])
                if let name = info?.name {
                    propertyInfos[name] = info
                }
            }
            self.propertyInfos = propertyInfos
            free(properties)
        }
        
        var ivarCount: UInt32 = 0
        if let ivars = class_copyIvarList(cls, &ivarCount) {
            var ivarInfos = [String: ClassIvarInfo]()
            for i in 0..<Int(ivarCount) {
                let info = ClassIvarInfo(ivar: ivars[i])
                if let name = info?.name {
                    ivarInfos[name] = info
                }
            }
            self.ivarInfos = ivarInfos
            free(ivars)
        }
        
        if ivarInfos == nil {
            self.ivarInfos = [:]
        }
        if methodInfos == nil {
            self.methodInfos = [:]
        }
        if propertyInfos == nil {
            self.propertyInfos = [:]
        }
        
        self.needUpdate = false
    }
    
    
    /**
     If the class is changed (for example: you add a method to this class with
     'class_addMethod()'), you should call this method to refresh the class info cache.

     After called this method, `needUpdate` will returns `YES`, and you should call
     'classInfoWithClass' or 'classInfoWithClassName' to get the updated class info.
     */
    public func setNeedUpdate() {
        self.needUpdate = true
    }
    
    
    /**
     If this method returns `YES`, you should stop using this instance and call
     `classInfoWithClass` or `classInfoWithClassName` to get the updated class info.

     @return Whether this class info need update.
     */
    public var needUpdate: Bool = false
    
    static var classCache: [String: YYClassInfo] = [:]
    static var metaCache: [String: YYClassInfo] = [:]
    
    /**
     Get the class info of a specified Class.

     @discussion This method will cache the class info and super-class info
     at the first access to the Class. This method is thread-safe.

     @param cls A class.
     @return A class info, or nil if an error occurs.
     */
    public static func classInfo(with cls: AnyClass?) -> YYClassInfo? {
        guard let cls = cls else { return nil }
        
        var info = class_isMetaClass(cls) ? Self.metaCache[NSStringFromClass(cls)] : Self.classCache[NSStringFromClass(cls)]
        
        if let info = info, info.needUpdate {
            info.update()
        }
        
        if info == nil {
            info = YYClassInfo(class: cls)
            if let info = info {
                if info.isMeta {
                    Self.metaCache[NSStringFromClass(cls)] = info
                } else {
                    Self.classCache[NSStringFromClass(cls)] = info
                }
            }
        }
        
        return info
    }
    
    
    /**
     Get the class info of a specified Class.

     @discussion This method will cache the class info and super-class info
     at the first access to the Class. This method is thread-safe.

     @param className A class name.
     @return A class info, or nil if an error occurs.
     */
    public static func classInfo(className: String) -> YYClassInfo? {
        classInfo(with: NSClassFromString(className))
    }
}

// MARK: - objc

extension YYEncodingType {
    init(_ encodingType: EncodingType) {
        self.init(rawValue: encodingType.rawValue)
    }
    
    var encodingType: EncodingType {
        EncodingType(rawValue: rawValue)
    }
}

@objcMembers
public class YYClassInfoGlobal: NSObject {
    public static func YYEncodingGetType(_ typeEncoding: UnsafePointer<CChar>?) -> YYEncodingType {
        YYEncodingType(rawValue: EncodingGetType(String(cString: typeEncoding!)).rawValue)
    }
}

@objcMembers
public class YYClassIvarInfo: NSObject {
    public var ivar: Ivar {
        classIvarInfo.ivar
    }
    public var name: String? {
        classIvarInfo.name
    }
    public var offset: Int {
        classIvarInfo.offset
    }
    public var typeEncoding: String? {
        classIvarInfo.typeEncoding
    }
    public var type: YYEncodingType {
        YYEncodingType(rawValue: classIvarInfo.type.rawValue)
    }
    
    var classIvarInfo: ClassIvarInfo
    
    public init?(ivar: Ivar?) {
        guard let ivar = ivar else { return nil }
        self.classIvarInfo = ClassIvarInfo(ivar: ivar)!
    }
}

@objcMembers
public class YYClassMethodInfo: NSObject {
    public var method: Method {
        classMethodInfo.method
    }
    public var name: String {
        classMethodInfo.name
    }
    public var sel: Selector {
        classMethodInfo.sel
    }
    public var imp: IMP {
        classMethodInfo.imp
    }
    public var typeEncoding: String? {
        classMethodInfo.typeEncoding
    }
    public var returnTypeEncoding: String {
        classMethodInfo.returnTypeEncoding
    }
    public var argumentTypeEncodings: [String]? {
        classMethodInfo.argumentTypeEncodings
    }
    
    var classMethodInfo: ClassMethodInfo
    
    public init?(method: Method?) {
        guard let method = method else { return nil }
        self.classMethodInfo = ClassMethodInfo(method: method)!
    }
}

@objcMembers
class YYClassPropertyInfo: NSObject {
    public var property: objc_property_t {
        classPropertyInfo.property
    }
    public var name: String {
        classPropertyInfo.name
    }
    public var type: YYEncodingType {
        YYEncodingType(rawValue: classPropertyInfo.type.rawValue)
    }
    public var typeEncoding: String? {
        classPropertyInfo.typeEncoding
    }
    public var ivarName: String? {
        classPropertyInfo.ivarName
    }
    public var cls: AnyClass? {
        classPropertyInfo.cls
    }
    public var protocols: [String]? {
        classPropertyInfo.protocols
    }
    public var getter: Selector? {
        classPropertyInfo.getter
    }
    public var setter: Selector? {
        classPropertyInfo.setter
    }
    
    var classPropertyInfo: ClassPropertyInfo
    
    public init?(property: objc_property_t?) {
        guard let property = property else { return nil }
        self.classPropertyInfo = ClassPropertyInfo(property: property)!
    }
}
