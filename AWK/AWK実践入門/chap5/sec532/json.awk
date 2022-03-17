##=================================================================
## JSON.awk
## このプログラムは、Apache2.0ライセンスで配布されている以下のプログラムが含まれています。
##-----------------------------------------------------------------
## Software: JSON.awk - a practical JSON parser written in awk
## Author: step- on github.com
## License: This software is licensed under the MIT or the Apache 2 license.
## Project home: https://github.com/step-/JSON.awk.git
## Credits: This software includes major portions of JSON.sh, a pipeable JSON
##   parser written in Bash, retrieved on 20130313
##   https://github.com/dominictarr/JSON.sh
##=================================================================

BEGIN {
    BRIEF=1;
    STREAM=1;
}

{ # main loop: process each file in turn
    reset() # See important application note in reset()

    tokenize($0)
    if (0 == parse()) {
        apply(JPATHS, NJPATHS)
    }
}

##=================================================================
## 関数定義
##=================================================================

##-----------------------------------------------------------------
##
##-----------------------------------------------------------------

function apply (ary, size,   i) {
    for (i=1; i<size; i++)
        print ary[i]
}

function get_token() {
    TOKEN = TOKENS[++ITOKENS] # for internal tokenize()
    return ITOKENS < NTOKENS
}

function parse_array(a1,   idx,ary,ret) {
    idx=0
    ary=""
    get_token()
    if (TOKEN != "]") {
        while (1) {
            if (ret = parse_value(a1, idx)) {
                return ret
            }
            idx=idx+1
            ary=ary VALUE
            get_token()
            if (TOKEN == "]") {
                break
            } else if (TOKEN == ",") {
                ary = ary ","
            } else {
                report(", or ]", TOKEN ? TOKEN : "EOF")
                return 2
            }
            get_token()
        }
    }
    if (1 != BRIEF) {
        VALUE=sprintf("[%s]", ary)
    } else {
        VALUE=""
    }
    return 0
}

function parse_object(a1,   key,obj) {
    obj=""
    get_token()
    if (TOKEN != "}") {
        while (1) {
            if (TOKEN ~ /^".*"$/) {
                key=TOKEN
            } else {
                report("string", TOKEN ? TOKEN : "EOF")
                return 3
            }
            get_token()
            if (TOKEN != ":") {
                report(":", TOKEN ? TOKEN : "EOF")
                return 4
            }
            get_token()
            if (parse_value(a1, key)) {
                return 5
            }
            obj=obj key ":" VALUE
            get_token()
            if (TOKEN == "}") {
                break
            } else if (TOKEN == ",") {
                obj=obj ","
            } else {
                report(", or }", TOKEN ? TOKEN : "EOF")
                return 6
            }
            get_token()
        }
    }
    if (1 != BRIEF) {
        VALUE=sprintf("{%s}", obj)
    } else {
        VALUE=""
    }
    return 0
}

function parse_value(a1, a2,   jpath,ret,x) {
    jpath=(a1!="" ? a1 "," : "") a2
    if (TOKEN == "{") {
        if (parse_object(jpath)) {
            return 7
        }
    } else if (TOKEN == "[") {
        if (ret = parse_array(jpath)) {
            return ret
        }
    } else if (TOKEN ~ /^(|[^0-9])$/) {
        report("value", TOKEN!="" ? TOKEN : "EOF")
        return 9
    } else {
        VALUE=TOKEN
    }
    if (! (1 == BRIEF && ("" == jpath || "" == VALUE))) {
        x=sprintf("%s %s", jpath, VALUE)
        if(0 == STREAM) {
            JPATHS[++NJPATHS] = x
        } else {
            print x
        }
    }
    return 0
}

function parse(   ret) {
    get_token()
    if (ret = parse_value()) {
        return ret
    }
    if (get_token()) {
        report("EOF", TOKEN)
        return 11
    }
    return 0
}

function report(expected, got,   i,from,to,context) {
    from = ITOKENS - 10; if (from < 1) from = 1
    to = ITOKENS + 10; if (to > NTOKENS) to = NTOKENS
    for (i = from; i < ITOKENS; i++)
        context = context sprintf("%s ", TOKENS[i])
    context = context "<<" got ">> "
    for (i = ITOKENS + 1; i <= to; i++)
        context = context sprintf("%s ", TOKENS[i])
    scream("expected <" expected "> but got <" got "> at input token " ITOKENS "\n" context)
}

function reset() {
    TOKEN=""; delete TOKENS; NTOKENS=ITOKENS=0
    delete JPATHS; NJPATHS=0
    VALUE=""
}

function scream(msg) {
    FAILS[FILENAME] = FAILS[FILENAME] (FAILS[FILENAME]!="" ? "\n" : "") msg
    msg = FILENAME ": " msg
    print msg >"/dev/stderr"
}

function tokenize(a1,   SPACE) {
    SPACE="[[:space:]]+"

    gsub(/\"[^[:cntrl:]\"\\]*((\\[^u[:cntrl:]]|\\u[0-9a-fA-F]{4})[^[:cntrl:]\"\\]*)*\"|(-)?(0|[1-9][0-9]*)([.][0-9]*)?([eE][+-]?[0-9]*)?|null|false|true|[[:space:]]+|./, "\n&", a1)
    gsub("\n" SPACE, "\n", a1)
    sub(/^\n/, "", a1)
    ITOKENS=0
    return NTOKENS = split(a1, TOKENS, /\n/)
}
