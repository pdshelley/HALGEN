@frozen
public struct DigitalValue {
    public var _value: Bool

    @_transparent
    public init(_ _value: Bool) {
        self._value = _value
    }

    @inlinable
    @inline(__always)
    public static var high: DigitalValue { DigitalValue(true) }

    @inlinable
    @inline(__always)
    public static var low: DigitalValue { DigitalValue(false) }
}

extension DigitalValue: Equatable {
    @inlinable
    @inline(__always)
    public static func == (lhs: DigitalValue, rhs: DigitalValue) -> Bool {
        lhs._value == rhs._value
    }
}

extension DigitalValue: Hashable {
    /// Hashes the essential components of this value by feeding them into the
    /// given hasher.
    ///
    /// - Parameter hasher: The hasher to use when combining the components
    ///   of this instance.
    @inlinable
    @inline(__always)
    public func hash(into hasher: inout Hasher) {
        hasher.combine((self._value ? 1 : 0) as UInt8)
    }
}

extension DigitalValue {
    /// Performs a logical NOT operation on a digital value.
    ///
    /// `high` becomes `low`, and `low` becomes `high`.
    @inlinable
    @inline(__always)
    public static prefix func ! (lhs: DigitalValue) -> DigitalValue {
        DigitalValue(!lhs._value)
    }

    /// Performs a logical AND operation on two digital values.
    ///
    /// The result is `high` only when both operands are `high`.
    @inlinable
    @inline(__always)
    public static func && (lhs: DigitalValue, rhs: DigitalValue) -> DigitalValue {
        DigitalValue(lhs._value && rhs._value)
    }

    /// Performs a logical OR operation on two digital values.
    ///
    /// The result is `high` when either operand is `high`.
    @inlinable
    @inline(__always)
    public static func || (lhs: DigitalValue, rhs: DigitalValue) -> DigitalValue {
        DigitalValue(lhs._value || rhs._value)
    }

    /// Toggles the value from `high` to `low`, or from `low` to `high`.
    @inlinable
    @inline(__always)
    public mutating func toggle() {
        self._value = !self._value
    }
}
