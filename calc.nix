let 

    addition = a: b:
        a + b;
    
    substraction= a: b:
        a - b;

    multiplication = a: b:
        a * b;

    division = a: b:
        a / b;

    powerAccumulation = base: exponent: curr_value:
        if exponent == 0
        then curr_value
        else powerAccumulation base (exponent - 1) (curr_value * base);

    power = base: pow:
        powerAccumulation base pow 1;

    getPriority = op:
        if op == "^" then 3
        else if op == "*" || op == "/" then 2
        else if op == "+" || op == "-" then 1
        else 0;

    calculateONP = token_list:
        builtins.foldl' (stack: token:
        if builtins.isInt token || builtins.isFloat token
        then
            [ token ] ++ stack
        else
            let
                a = builtins.head stack;
                b = builtins.head (builtins.tail stack);

                rest_of_stack = builtins.tail (builtins.tail stack);

                result = if token == "+" then (addition a b)
                    else if token == "-" then (substraction a b)
                    else if token == "/" then (division a b)
                    else if token == "*" then (multiplication a b)
                    else if token == "^" then (power a b)
                    else 0;

            in
            [ result ] ++ rest_of_stack
        ) [] token_list;

    parseToONP = token_list: input_string: operators:
        0;


in 
{
    add = addition;
    sub = substraction;
    mul = multiplication;
    div = division;
    pow = power;
    onp = calculateONP;
}
