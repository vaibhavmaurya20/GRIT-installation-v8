# GRIT Language Specification v8

## Syntax

### Indentation
GRIT uses Python-style significant indentation. 4 spaces per level.
Tab characters are not supported.

### Comments
```grit
# This is a line comment
fn main
    # Comments can appear anywhere
    println("hello")  # inline comment
```

### Identifiers
Letters, digits, underscores. Must start with letter or underscore.
`my_var`, `_internal`, `count2`, `CamelCase`

### Keywords
`fn`, `let`, `mut`, `if`, `else`, `while`, `for`, `in`, `match`,
`return`, `true`, `false`, `struct`, `enum`, `impl`, `pub`,
`and`, `or`, `not`, `then`

## Types

```grit
fn typed_fn x:int y:str z:bool -> int
    0
```

### Primitive types
- `int` — 64-bit signed integer
- `float` — 64-bit float
- `str` — UTF-8 string
- `bool` — boolean

### Array types
- `[int]` — array of integers
- `[str]` — array of strings
- `[[str]]` — nested array

## Expressions

### Literals
```grit
42          // integer
3.14        // float  
"hello"     // string
true        // boolean
false       // boolean
```

### Binary operators (precedence, high to low)
```
**          // power (right-assoc)
* / %       // multiplicative
+ -         // additive
<< >>       // bit shift
&           // bitwise AND
^           // bitwise XOR
|           // bitwise OR
== != < <= > >=  // comparison
&&          // logical AND
||          // logical OR
.. ..=      // range
```

### Unary operators
```
-x          // negation
!x          // logical not
```

### If expression (inline)
```grit
let max = if a > b then a else b
```

### Function call
```grit
println("hello")
add(3, 4)
obj.method()
```

### Array indexing
```grit
arr[0]
arr[i]
```

### Field access
```grit
point.x
point.y
```

## Statements

### Let binding
```grit
let x = 42              // immutable
let mut y = 10          // mutable
let z: int = 5          // with type annotation (optional)
```

### Assignment
```grit
x = 42
x += 1
x -= 1
x *= 2
x /= 2
x %= 3
```

### If/else
```grit
if condition
    body
else if other_condition
    other_body
else
    default_body
```

### While loop
```grit
while condition
    body
```

### For loop
```grit
for item in array
    println(item)
```

### Return
```grit
fn f x:int -> int
    if x < 0
        return 0
    x * 2
```

### Match expression
```grit
match result
    Ok(v) => v
    Err(e) => 0
```

## Functions

### Basic function
```grit
fn name param1:type1 param2:type2 -> return_type
    body
```

### Inline function
```grit
fn double x:int -> int => x * 2
fn identity x:int -> int => x
```

### Multiple return (via arrays)
```grit
fn divmod a:int b:int -> [int]
    [a / b, a % b]
```

### Structs
```grit
struct Point
    x: int
    y: int

fn make_point x:int y:int -> Point
    Point { x: x, y: y }
```

## Standard Library (built-ins)

```grit
println(x)          // print + newline
print(x)            // print without newline
to_string(x)        // any → str
len(arr)            // [T] → int
push(arr, x)        // [T] → [T] (append)
append(a, b)        // [T] → [T] (concat)
read_file(path)     // str → Ok(str)/Err(str)
write_file(path, s) // str str → Ok(int)/Err(str)
args()              // → [str]
shell(cmd)          // str → {code, stdout, stderr}
```
