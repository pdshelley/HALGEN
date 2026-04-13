public protocol PartialPort {
    associatedtype PortType: BinaryInteger
    static var dataRegister: PortType { get set }
    static var inputAddress: PortType { get }
}

public protocol Port: PartialPort {
    static var dataDirection: PortType { get set }
}

public protocol Bit {
    associatedtype BitType: BinaryInteger
    associatedtype PinMaskType: BinaryInteger
    static var bit: BitType { get }
}

public extension Bit {
    @inlinable
    @inline(__always)
    static var pinSetMask: PinMaskType {
        1 << bit
    }

    @inlinable
    @inline(__always)
    static var pinClearMask: PinMaskType {
        ~(1 << bit)
    }

    @inlinable
    @inline(__always)
    static var pinDirectionSetMask: PinMaskType {
        1 << bit
    }

    @inlinable
    @inline(__always)
    static var pinDirectionClearMask: PinMaskType {
        ~(1 << bit)
    }

    @inlinable
    @inline(__always)
    static var pinGetMask: PinMaskType {
        1 << bit
    }
}

public protocol PartialPortPin {
    associatedtype PinPartialPort: PartialPort
    associatedtype PinBit: Bit

    static func setValue(_ value: DigitalValue)
    static func value() -> DigitalValue
}

@frozen
public enum DataDirectionFlag: UInt8 {
    case input
    case output
}

public protocol PortPin: PartialPortPin where PinPartialPort == PinPort {
    associatedtype PinPort: Port
    static func setDataDirection(_ direction: DataDirectionFlag)
}

/// Shared behavior for pins backed by a readable and writable port.
public extension PartialPortPin where PinPartialPort.PortType == PinBit.PinMaskType {
    @inlinable
    @inline(__always)
    static func setValue(_ value: DigitalValue) {
        if value == .high {
            PinPartialPort.dataRegister |= PinBit.pinSetMask
        } else {
            PinPartialPort.dataRegister &= PinBit.pinClearMask
        }
    }

    @inlinable
    @inline(__always)
    static func value() -> DigitalValue {
        DigitalValue(PinPartialPort.inputAddress & PinBit.pinGetMask != 0)
    }
}

/// Shared behavior for pins that also expose a data-direction register.
public extension PortPin where PinPort.PortType == PinBit.PinMaskType {
    @inlinable
    @inline(__always)
    static func setDataDirection(_ direction: DataDirectionFlag) {
        switch direction {
        case .input:
            PinPort.dataDirection &= PinBit.pinDirectionClearMask
        case .output:
            PinPort.dataDirection |= PinBit.pinDirectionSetMask
        }
    }
}

public enum DigitalPin<_Port: Port, _Bit: Bit>: PortPin where _Port.PortType == _Bit.PinMaskType {
    public typealias PinPort = _Port
    public typealias PinPartialPort = _Port
    public typealias PinBit = _Bit
}

public enum InputOnlyDigitalPin<_Port: PartialPort, _Bit: Bit>: PartialPortPin where _Port.PortType == _Bit.PinMaskType {
    public typealias PinPartialPort = _Port
    public typealias PinBit = _Bit
}

public enum Bit0: Bit {
    public typealias PinMaskType = UInt8

    @inlinable
    @inline(__always)
    public static var bit: UInt8 { 0 }
}

public enum Bit1: Bit {
    public typealias PinMaskType = UInt8

    @inlinable
    @inline(__always)
    public static var bit: UInt8 { 1 }
}

public enum Bit2: Bit {
    public typealias PinMaskType = UInt8

    @inlinable
    @inline(__always)
    public static var bit: UInt8 { 2 }
}

public enum Bit3: Bit {
    public typealias PinMaskType = UInt8

    @inlinable
    @inline(__always)
    public static var bit: UInt8 { 3 }
}

public enum Bit4: Bit {
    public typealias PinMaskType = UInt8

    @inlinable
    @inline(__always)
    public static var bit: UInt8 { 4 }
}

public enum Bit5: Bit {
    public typealias PinMaskType = UInt8

    @inlinable
    @inline(__always)
    public static var bit: UInt8 { 5 }
}

public enum Bit6: Bit {
    public typealias PinMaskType = UInt8

    @inlinable
    @inline(__always)
    public static var bit: UInt8 { 6 }
}

public enum Bit7: Bit {
    public typealias PinMaskType = UInt8

    @inlinable
    @inline(__always)
    public static var bit: UInt8 { 7 }
}

/// Returns whether the bit at `bit` is set in `register`.
@inlinable
@inline(__always)
public func getRegisterBit(_ register: UInt8, bit: UInt8) -> Bool {
    let bitFilter = UInt8(1) << bit
    return register & bitFilter != 0
}

/// Sets the bit at `bit` in `register` to `value`, leaving the other bits intact.
@inlinable
@inline(__always)
public func setRegisterBit(_ register: UInt8, bit: UInt8, value: Bool) {
}
