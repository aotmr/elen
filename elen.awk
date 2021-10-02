#!/usr/bin/awk -f

function panic(msg) { print "panic: " msg; exit 1 }
function trace(msg) {}#{ print "trace: " msg }
function error(msg) { print "error: " msg }

function debugState(xt,  i) {
    printf("XT: %-12s | IP:% 4d | Dstk[ ", xt, ip)
    for(i = 1; i <= sp; ++i) printf("%s ", Dstk[i])
    printf(" ] Rstk[  ");
    for(i = 1; i <= rp; ++i) printf("%s ", Rstk[i])
    print "]"
}

# Interpreter Setup

BEGIN {
    delete Mem[0] # memory
    delete Dstk[0] # data stack
    delete Rstk[0] # return stack

    delete Dict[0] # dictionary
    delete Name[0] # location names

    state = 0 # interpreter nest level
    here = 1000 # current position in memory
    ip = 0 # interpreter pointer
    rp = 0 # return stack pointer
    sp = 0 # data stack pointer

    # build set of primitives
    split( \
        "exit ?exit call goto quot lit bind find " \
        "here ,  . .s cr " \
        "+ - 0= 0< "\
        "dup over drop nip >r r> trap", T, " ")
    for (i in T) Prim[T[i]] = 1
    delete T
}

# Inner Interpreter

function doQuot(  len) {
    len = Mem[ip++] # fetch quote length
    if (len == 0) panic("quot trap at " ip)
    Dstk[++sp] = ip # push address of quote
    ip += len # skip over quote contents
}

function doBind(  name, addr) {
    name = Dstk[sp]
    addr = Dstk[sp - 1]
    Dict[name] = addr
    Name[addr] = name
    sp -= 2
}

function doFind(  key) {
    key = Dstk[sp]
    Dstk[sp] = Dict[key]
    Dstk[++sp] = key in Dict
}

function execute(xt,  i, rp0) {
    rp0 = rp;
    while (1) {
        while (xt == +xt) {
            Rstk[++rp] = ip;
            ip = xt;
            debugState(xt);

            if (!ip) panic("out of bounds execution at " ip);
            xt = Mem[ip++];
        }
        debugState(xt);
        # control flow
        if (xt == "exit") ip = Rstk[rp--]
        else if (xt == "?exit") { if (Dstk[sp--]) ip = Rstk[rp--] }
        else if (xt == "call") execute(Dstk[sp--])
        else if (xt == "goto") ip = Dstk[sp--]
        # literals
        else if (xt == "lit") Dstk[++sp] = Mem[ip++]
        else if (xt == "quot") doQuot() # ( -- xt )
        # dictionary
        else if (xt == "bind") doBind() # ( xt name -- )
        else if (xt == "find") doFind() # ( name -- xt flag )
        # compilation
        else if (xt == ",") Mem[here++] = Dstk[sp--]
        else if (xt == "here") Dstk[++sp] = here
        # input, output
        else if (xt == ".") printf("%s ", Dstk[sp--])
        else if (xt == ".s") { for (i = 1; i <= sp; ++i) printf("%s ", Dstk[i]) }
        else if (xt == "cr") print ""
        # arithmetic
        else if (xt == "+") { Dstk[sp - 1] += Dstk[sp]; sp-- }
        else if (xt == "-") { Dstk[sp - 1] -= Dstk[sp]; sp-- }
        else if (xt == "0=") Dstk[sp] = !!Dstk[sp]
        else if (xt == "0<") Dstk[sp] = Dstk[sp] < 0
        # stack
        else if (xt == "dup") { ++sp; Dstk[sp] = Dstk[sp - 1] }
        else if (xt == "over") { ++sp; Dstk[sp] = Dstk[sp - 2] }
        else if (xt == "drop") sp--
        else if (xt == "nip") { Dstk[sp - 1] = Dstk[sp]; sp-- }
        else if (xt == ">r") Rstk[++rp] = Dstk[sp--]
        else if (xt == "r>") Dstk[++sp] = Rstk[rp--]
        else panic("cannot execute primitive " xt);

        if (rp > rp0) xt = Mem[ip++]
        else break
    }
}

# Outer Interpreter

function interpAmper(word,  addr) {
    if (word in Dict) addr = Dict[word]
    else if (word in Prim) addr = litOrPush(word)
    else addr = 0
    litOrPush(addr)
}

function interpColon(word) {
    if (state > 0) panic("cannot nest colon definitions")
    ++state

    Dict[word] = here
    Name[here] = word
}

function interpScolon() {
    --state
    if (state < 0) panic("cannot nest below ground")

    Mem[here++] = "exit"
}

function interpLbrack() {
    Mem[here++] = "quot"
    Dstk[++sp] = here
    Mem[here++] = -1

    ++state
}

function interpRbrack(  quot) {
    --state
    if (state < 0) panic("cannot nest below ground")

    quot = Dstk[sp--]
    Mem[quot] = here - quot # patch up quote length
    Mem[here++] = "exit"
    if (state == 0) Dstk[++sp] = quot + 1
}

function litOrPush(x) {
    if (state > 0) {
        Mem[here++] = "lit";
        Mem[here++] = x;
    } else {
        Dstk[++sp] = x;
    }
}

function compileOrExec(x) {
    if (state > 0) {
        Mem[here++] = x;
    } else {
        execute(x);
    }
}

{
    for (i = 1; i <= NF; i += 1) {
        word = $i
        if (word == "\\") break
        else if (word ~ /^'/) { gsub("_", " ", word); litOrPush(substr(word, 2)) }
        else if (word ~ /^&/) interpAmper(substr(word, 2))
        else if (word ~ /^:/) interpColon(substr(word, 2))
        else if (word == ";") interpScolon()
        else if (word == "[") interpLbrack()
        else if (word == "]") interpRbrack()
        else if (word in Dict) compileOrExec(Dict[word])
        else if (word in Prim) compileOrExec(word)
        else if (word == +word) litOrPush(+word)
        else panic("cannot interpret word " word);
    }
    if (state == 0 && FILENAME == "-") print "ok. "
}

END {
    # print ""
    # print "KEY\tVAL"
    # for (i in Dict) printf("%s\t%s\n", i, Dict[i])
    # print ""
    # n = 0

    # printf("NAME\t ADDR | MEMORY  ..." )
    # for (i in Mem) {
    #     if (i in Name) { 
    #         printf("\n%s\t% 5d | ", Name[i], i)
    #         n = 1
    #     } else if (n > 8) {
    #         printf("...\n\t% 5d | ", i)
    #         n = 0
    #     }
    #     if (Mem[i] in Name) {
    #         printf("#%s\t", Name[Mem[i]])
    #     } else {
    #         printf("'%s\t", Mem[i])
    #     }
    #     ++n
    # }
    # print ""
}