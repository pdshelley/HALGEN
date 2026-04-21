//
//  GeneratorRegistry.swift
//  SwiftAVRGenerator
//
//  Created by Friso De Backer on 26/02/2026.
//

struct GeneratorRegistry {
    static let allGenerators: [PeripheralGenerator] = [
        UARTGenerator(),
        SPIGenerator(),
        TimerGenerator(),
        ADCGenerator(),
        GPIOGenerator(),
        CPUCoreGenerator()
    ]
}
