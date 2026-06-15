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

in 
{
    add = addition;
    sub = substraction;
    mul = multiplication;
    div = division;
    pow = power;
}
