/// Issues a single `nop` instruction.
@inlinable
@inline(__always)
public func noOperation() {
    _noOpperation()
}

/// Issues a single `nop` instruction.
@available(*, deprecated, renamed: "noOperation()")
@inlinable
@inline(__always)
public func noOpperation() {
    noOperation()
}
/// Runs a critical section wrapper used by generated 16-bit register accessors.
@inlinable
@inline(__always)
public func atomic<T>(block: () -> T) -> T {
    if !cpuCore.globalInterruptEnable {
        return block()
    }

    _cli()
    let result = block()
    _sei()

    return result
}
