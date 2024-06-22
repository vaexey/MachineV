const fs = require("fs")
const config = require("./instructions.json")

const architecture = config.architecture;
const signals = config.signals;
const instructions = config.instructions;

const encodeSignals = (cycle) => {
    let bits = new Array(architecture.signals).fill(0);

    cycle.forEach(sig => {
        const idx = signals.indexOf(sig)

        if(idx == -1)
        {
            console.warn(`WARN: Signal "${sig}" does not exist in signal list`)
            return;
        }

        bits[idx] = 1;
    })

    return bits.reverse().join("");
}

const checkFlagMatch = (expression, flags) => {
    if(expression == "*")
        return true;
    
    let flagEval = 
        architecture.flags.literals.split("")
        .reverse().map((k,i) => {
            if(k == "*")
                return ""
            else
                return `let ${k} = ${!!+flags[i]};`
        }).join("")
    
    const result = eval(flagEval + expression);

    if(result !== true && result !== false)
        console.warn(`WARN: indeterminate expression "${expression}" result "${result}"`)

    return result;
}


const lengthsMap = 
    new Array(architecture.instructions * (2**architecture.flags.count))
    .fill('0')
// const instructionMap = 
//     new Array(architecture.instructions * (2**architecture.flags.count))
//     .fill(null).map(_ => new Array(architecture.cycles).fill('0'))

const instructionMap =
    new Array(lengthsMap.length * architecture.cycles)
    .fill('0')

const instructionMapComments = {}

const startTime = new Date().getTime()

console.log(`Instruction generator target: map'${
        architecture.signals
    }[${
        instructionMap.length
    }][${
        architecture.cycles
    }]`)

const parsedCodes = []
const parsedSignatures = []

Object.keys(instructions).forEach(key => {
    const instr = instructions[key]
    const code = +instr.code;
    const candidates = Object.keys(instr).filter(k => k.toLowerCase() != "code")

    console.log(`Instruction "${key}" has ${candidates.length} candidate(s)`)

    if(code === undefined || isNaN(code))
    {
        console.error(`ERR: omitting instruction "${key}" because code is invalid`)
        return
    }

    if(code >= architecture.instructions)
    {
        console.error(`ERR: omitting instruction "${key}" because code does not fit in instruction table`)
        return
    }

    if(parsedCodes.includes(code))
    {
        console.warn(`WARN: instruction "${key}" overwrites code ${code}`)
    }

    const baseSignature = code << (architecture.flags.count + Math.log2(architecture.cycles))
    instructionMapComments[baseSignature] = `// Instruction ${key} :: ${code}\n`

    for(let flags = 0; flags < (2**architecture.flags.count); flags++)
    {
        const flagBits = 
            flags.toString(2)
            .padStart(architecture.flags.count, '0')
            .split("")
            .reverse()

        const matches = []

        candidates.forEach(expr => {
            const match = checkFlagMatch(expr, flagBits)

            if(match)
                matches.push(expr)
        })

        if(matches.length == 0)
            continue;
        
        if(matches.length > 1)
            console.warn(`WARN: instruction "${key}" has ${matches.length} matching candidates for flag value ${flags}. Using the first match "${matches[0]}"`)

        const signature = 
            (
                (code << architecture.flags.count)
                + flags
            ) << Math.log2(architecture.cycles)
        
        const sigs = [...instr[matches[0]]]
        const instrLength = sigs.length;

        //console.log(`Registering "${key}" @ ${instrLength}c to ${signature} (${code} :: ${flags})`)

        while(sigs.length < architecture.cycles)
            sigs.push([])

        const encoded = sigs.map(cycle => 
            encodeSignals(cycle)
        )
        
        if(parsedSignatures.includes(signature))
        {
            console.warn(`WARN: instruction "${key}" overwrites signature ${signature}`)
        }

        lengthsMap[signature >> Math.log2(architecture.cycles)] = instrLength

        encoded.forEach((bit, i) => {
            const memIndex = 
                signature + i
            
            instructionMap[memIndex] = bit
        })

        parsedSignatures.push(signature)
    }

    parsedCodes.push(code)
})

const undefinedInstructions = {}
instructionMap.forEach((iv, i) => {
    if(i % architecture.cycles != 0)
        return

    if(iv == '0')
    {
        const code = i >> (architecture.flags.count + Math.log2(architecture.cycles))
        const flags = 
            i >> Math.log2(architecture.cycles) 
            & ~(~0 << architecture.flags.count)

        let existing = undefinedInstructions[code]

        if(!existing)
            existing = {
                flags: []
            };
        
        existing.flags.push(flags)

        undefinedInstructions[code] = existing
    }
})

Object.keys(undefinedInstructions).forEach(id => {
    const baseSignature = id << 
        (architecture.flags.count + Math.log2(architecture.cycles))

    if(undefinedInstructions[id].flags.length == (2**architecture.flags.count))
    {
        instructionMapComments[baseSignature] = 
            `// WARN: Undefined instruction (${
                id
            }) segment from ${
                baseSignature
            } to ${
                baseSignature + 2**architecture.flags.count - 1
            }\n`
    }
    else
    {
        undefinedInstructions[id].flags.forEach(f => {
            instructionMapComments[baseSignature + (f << Math.log2(architecture.cycles))] = 
                `// WARN: Undefined single signature for ${id} @ ${f}\n`
        })
    }
})

const undefinedInstructionsString =
    Object.keys(undefinedInstructions)
    .map(id => `${
        id
    } :: (${
        undefinedInstructions[id].flags.length == (2**architecture.flags.count) ?
        "*" :
        undefinedInstructions[id].flags.join(";")
    })`)
    .join(", ")

if(undefinedInstructionsString != "")
{
    console.warn("WARN: Some instruction signatures remain unassigned:")
    console.warn("WARN: " + undefinedInstructionsString)
}

const autoGeneratedHeader = 
    "// File auto-generated by instructions.js\n" +
    "// Architecture definition:\n" +
    `// ${architecture.signals} signals\n` +
    `// ${architecture.flags.count} flags\n` +
    `// ${architecture.cycles} max cycles\n` +
    `// ${architecture.instructions} available instructions\n` +
    `// Word is ${architecture.word} bits long of which ${architecture.address} bits are address\n`

const signalMapFile =
    autoGeneratedHeader + 
    instructionMap.map((iv, i) => 
        (instructionMapComments[i] ?? "") + 
        `\`SIGNALS_MAP[${i}] = ${architecture.signals}'b${iv};`
    ).join("\n")

const lengthsMapFile =
    autoGeneratedHeader + 
    lengthsMap.map((iv, i) =>
        `\`LENGTHS_MAP[${i}] = ${iv};`
    ).join("\n")

fs.writeFileSync("./meminit_signals.v", signalMapFile)
fs.writeFileSync("./meminit_lengths.v", lengthsMapFile)

console.log(`Done (${(new Date().getTime() - startTime)/1000} s)`)