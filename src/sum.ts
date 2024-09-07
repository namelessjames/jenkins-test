type SumProps = {
    a: number;
    b: number;
};

function sum({a,b}: SumProps):number{  
    return a + b;
}

export { sum };
