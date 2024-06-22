const fs = require("fs")
const config = require("./instructions.json")

const architecture = config.architecture;
const signals = config.signals;
const instructions = config.instructions;

const sourceFile = "./initial_program.asm"

const isNumberLiteral = (val) => {
    const s = ""+val
    return s.length > 0 && "0123456789".includes(s[0])
}

let directiveRecursionCheck = 0
const parseDirectives = (ln) => {
    if(!ln.startsWith("#"))
        return [ln]

    const directive = ln.substring(1).toLowerCase()

    if(directive.startsWith("include "))
    {
        directiveRecursionCheck++

        if(directiveRecursionCheck > 1000)
        {
            console.error("ERR: circular include directive detected")
            return []
        }

        const arg = directive.substring("include ".length)

        const includeContent = fs.readFileSync(arg).toString()

        return includeContent
            .split("\n")
            .map(x => x.trim())
            .map(parseDirectives)
            .flat(1)
    }

    console.warn(`WARN: unknown assembler directive "${directive}" was ignored`)
    return []
}

console.log(`Assembler target: "${sourceFile}"`)

const startTime = new Date().getTime()

const sourceText = fs.readFileSync(sourceFile).toString()
const sourceLines = sourceText.split("\n")

const sanitizedLines = sourceLines
    .map(ln => ln.trim())
    .map(parseDirectives)
    .flat(1)
    .filter(ln => !ln.startsWith("//"))
    .filter(ln => ln.length > 0)

const mergedLines = []

let labels = []
sanitizedLines.forEach(ln => {
    if(ln.startsWith(":"))
    {
        labels.push(ln.substring(1))
        return
    }

    const args = 
        ln.split(" ")
        .map(w => w.trim())
        .filter(w => w.length > 0)
    
    const literal = args.shift()

    mergedLines.push({
        literal,
        args,
        labels: [...labels]
    })

    labels = []
})

const labelMap = {}

mergedLines.forEach((ln, idx) => {
    ln.labels.forEach(lab => {
        if(isNumberLiteral(lab))
        {
            console.warn(`WARN: label "${lab}" is consiedered a numeric literal and will not be replaced correctly`)
        }

        labelMap[lab] = idx
    })
})

const memory = new Array(2**architecture.address).fill(0)
let memoryLastWritten = -1
const memoryWrite = (address, word) => {
    memory[address] = word
    memoryLastWritten = address
}

console.log(`Memory target: mem'${architecture.word}[${memory.length}]`)

if(memory.length < mergedLines.length)
{
    console.error(`ERR: out of memory ${
        mergedLines.length
    }/${
        memory.length
    } words (${
        mergedLines.length/memory.length*100
    }%)`)

    throw "assembly failed"
}

mergedLines.forEach((ln, idx) => {
    const literal = ln.literal
    const args = ln.args.map(a => {
        if(isNumberLiteral(a))
        {
            if(isNaN(+a))
            {
                console.error(`ERR: could not parse numeric literal "${a}". Set to 0 by default`)

                return 0
            }

            return +a
        }

        if(labelMap[a] !== undefined)
        {
            return labelMap[a]
        }

        console.error(`ERR: could not find label "${a}"`)
    })

    // Assuming all instructions/definitions are 0 or 1 argument
    args[0] = args[0] ?? 0

    if(literal == "DW")
    {
        // Define Word

        memoryWrite(idx, args[0])
        return
    }

    if(instructions[literal] !== undefined)
    {
        memoryWrite(
            idx, 
            (instructions[literal].code << architecture.address) + 
            args[0]
        )
        
        return
    }

    console.error(`ERR: could not parse instruction literal "${literal}". Set to instruction 0 by default`)

    memoryWrite(idx, 0)
})

if(memoryLastWritten == -1)
{
    console.log("WARN: memory is empty (did you provide an empty asm file?)")
}
else
{
    console.log(`Memory usage: ${
        memoryLastWritten+1
    }/${
        memory.length
    } words (${
        (memoryLastWritten+1)/memory.length*100
    }%)`)
}

const memoryFile =
    memory.map((word, idx) => 
        //`\`RAM_MEMORY[${idx}] = ${architecture.word}'d${word};`
        `\`RAM_MEMORY[${idx}] = (${
            architecture.word - architecture.address
        }'d${word >> architecture.address} << ${
            architecture.address
        }) + ${architecture.address}'d${
            word & ~(~0 << architecture.address)
        };`
    ).join("\n")

fs.writeFileSync("./meminit_ram.v", memoryFile)

console.log(`Done (${(new Date().getTime() - startTime)/1000} s)`)