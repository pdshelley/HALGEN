/// Issues a single `nop` instruction.
@inlinable
@inline(__always)
public func noOpperation() {
    _noOpperation()
}

/// Runs a critical section wrapper used by generated 16-bit register accessors.
///
/// CPUCore and Interrupts are intentionally outside the current HALGEN pass, so this
/// template keeps the API available without toggling global interrupt state yet.
@inlinable
@inline(__always)
public func atomic<T>(block: () -> T) -> T {
    block()
}
