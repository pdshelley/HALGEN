//
//  HALGENCodeFormat.swift
//  SwiftAVRGenerator
//
//  Created by Friso De Backer on 06/03/2026.
//

import SwiftBasicFormat
import SwiftSyntax

final class HALGENCodeFormat: BasicFormat {
    override func requiresNewline(between first: TokenSyntax?, and second: TokenSyntax?) -> Bool {
        if sharesCompactImplicitAccessorBlock(first: first, second: second) {
            return false
        }

        return super.requiresNewline(between: first, and: second)
    }

    private func sharesCompactImplicitAccessorBlock(first: TokenSyntax?, second: TokenSyntax?) -> Bool {
        guard
            let firstAccessorBlock = compactImplicitAccessorBlock(containing: first),
            let secondAccessorBlock = compactImplicitAccessorBlock(containing: second)
        else {
            return false
        }

        return firstAccessorBlock.id == secondAccessorBlock.id
    }

    private func compactImplicitAccessorBlock(containing token: TokenSyntax?) -> AccessorBlockSyntax? {
        guard let token else {
            return nil
        }

        return token.ancestorOrSelf { syntax in
            guard
                let accessorBlock = syntax.as(AccessorBlockSyntax.self),
                let accessors = accessorBlock.accessors.as(AccessorDeclListSyntax.self),
                !accessors.isEmpty,
                accessors.allSatisfy({ $0.body == nil })
            else {
                return nil
            }

            return accessorBlock
        }
    }
}
