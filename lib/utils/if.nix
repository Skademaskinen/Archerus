inputs:

rec {
    baseIf = fallback: condition: value: if condition
        then value
        else fallback;

    setIf = baseIf {};
    strIf = baseIf "";
    fIf = s: v: f: if s ? v then s.${v} else f;
}
