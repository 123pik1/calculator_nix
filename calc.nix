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
        else if op == "(" || op == ")" then -1
        else 0;

    calculateONP = token_list:
    let 
        finalStack = builtins.foldl' (stack: token:
        if getPriority token == 0
        then
            [ (builtins.fromJSON token) ] ++ stack
        else
            let
                b = builtins.head stack;
                a = builtins.head (builtins.tail stack);

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
    in
        builtins.head finalStack;

    divideTokens = string:
        let 
            cleared_text = builtins.replaceStrings [" "] [""] string;
          splitted = builtins.split "(\\+|-|\\*|/|\\^|\\(|\\))" cleared_text;
        in
            builtins.filter (x: x!= "") (
                builtins.map (x: if builtins.isList x 
                then builtins.head x
                else x)
                splitted
            );

    manageOutputAndOperators = newToken: operators: currentOutput:
    if getPriority newToken == 0 then
        {
            output =  currentOutput ++ [ newToken ];
            operators = operators;
        }
    else if newToken == "(" then
        {
            output = currentOutput;
            operators = [ newToken ] ++ operators;
        }
    else if newToken == ")" then
        let
            top = builtins.head operators;
            rest = builtins.tail operators;
        in
            if top == "(" then
                { output = currentOutput; operators = rest; } # Nawiasy się kasują
            else
                manageOutputAndOperators newToken rest (currentOutput ++ [ top ])
    else
    if operators == [] then
        {
            output = currentOutput;
            operators = [newToken];
        }
    else
        let
            topOperator = builtins.head operators;
            restOperators = builtins.tail operators;
        in
        if topOperator == "(" then
            {
                output = currentOutput;
                operators = [ newToken ] ++ operators;
            }
        else if getPriority newToken > getPriority topOperator then
            {
                output = currentOutput;
                operators =  [newToken] ++ operators;
            }
        else
        let 
            newOutput = currentOutput ++ [ topOperator ];
        in
        manageOutputAndOperators newToken restOperators newOutput;


    parseToONP = token_list: operators: output:
        if token_list == []
            then output ++ operators
        else 
            let
                headToken = builtins.head token_list;
                tailTokens = builtins.tail token_list;

                managed = manageOutputAndOperators headToken operators output;
            in
            parseToONP tailTokens managed.operators managed.output
        ;
    
    calc = string:
        calculateONP (parseToONP (divideTokens string) [] []);
    

in 
    calc
