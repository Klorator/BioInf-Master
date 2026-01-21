// Some definitions presupposed by pandoc's typst output.
#let blockquote(body) = [
  #set text( size: 0.92em )
  #block(inset: (left: 1.5em, top: 0.2em, bottom: 0.2em))[#body]
]

#let horizontalrule = line(start: (25%,0%), end: (75%,0%))

#let endnote(num, contents) = [
  #stack(dir: ltr, spacing: 3pt, super[#num], contents)
]

#show terms: it => {
  it.children
    .map(child => [
      #strong[#child.term]
      #block(inset: (left: 1.5em, top: -0.4em))[#child.description]
      ])
    .join()
}

// Some quarto-specific definitions.

#show raw.where(block: true): set block(
    fill: luma(230),
    width: 100%,
    inset: 8pt,
    radius: 2pt
  )

#let block_with_new_content(old_block, new_content) = {
  let d = (:)
  let fields = old_block.fields()
  fields.remove("body")
  if fields.at("below", default: none) != none {
    // TODO: this is a hack because below is a "synthesized element"
    // according to the experts in the typst discord...
    fields.below = fields.below.abs
  }
  return block.with(..fields)(new_content)
}

#let empty(v) = {
  if type(v) == str {
    // two dollar signs here because we're technically inside
    // a Pandoc template :grimace:
    v.matches(regex("^\\s*$")).at(0, default: none) != none
  } else if type(v) == content {
    if v.at("text", default: none) != none {
      return empty(v.text)
    }
    for child in v.at("children", default: ()) {
      if not empty(child) {
        return false
      }
    }
    return true
  }

}

// Subfloats
// This is a technique that we adapted from https://github.com/tingerrr/subpar/
#let quartosubfloatcounter = counter("quartosubfloatcounter")

#let quarto_super(
  kind: str,
  caption: none,
  label: none,
  supplement: str,
  position: none,
  subrefnumbering: "1a",
  subcapnumbering: "(a)",
  body,
) = {
  context {
    let figcounter = counter(figure.where(kind: kind))
    let n-super = figcounter.get().first() + 1
    set figure.caption(position: position)
    [#figure(
      kind: kind,
      supplement: supplement,
      caption: caption,
      {
        show figure.where(kind: kind): set figure(numbering: _ => numbering(subrefnumbering, n-super, quartosubfloatcounter.get().first() + 1))
        show figure.where(kind: kind): set figure.caption(position: position)

        show figure: it => {
          let num = numbering(subcapnumbering, n-super, quartosubfloatcounter.get().first() + 1)
          show figure.caption: it => {
            num.slice(2) // I don't understand why the numbering contains output that it really shouldn't, but this fixes it shrug?
            [ ]
            it.body
          }

          quartosubfloatcounter.step()
          it
          counter(figure.where(kind: it.kind)).update(n => n - 1)
        }

        quartosubfloatcounter.update(0)
        body
      }
    )#label]
  }
}

// callout rendering
// this is a figure show rule because callouts are crossreferenceable
#show figure: it => {
  if type(it.kind) != str {
    return it
  }
  let kind_match = it.kind.matches(regex("^quarto-callout-(.*)")).at(0, default: none)
  if kind_match == none {
    return it
  }
  let kind = kind_match.captures.at(0, default: "other")
  kind = upper(kind.first()) + kind.slice(1)
  // now we pull apart the callout and reassemble it with the crossref name and counter

  // when we cleanup pandoc's emitted code to avoid spaces this will have to change
  let old_callout = it.body.children.at(1).body.children.at(1)
  let old_title_block = old_callout.body.children.at(0)
  let old_title = old_title_block.body.body.children.at(2)

  // TODO use custom separator if available
  let new_title = if empty(old_title) {
    [#kind #it.counter.display()]
  } else {
    [#kind #it.counter.display(): #old_title]
  }

  let new_title_block = block_with_new_content(
    old_title_block, 
    block_with_new_content(
      old_title_block.body, 
      old_title_block.body.body.children.at(0) +
      old_title_block.body.body.children.at(1) +
      new_title))

  block_with_new_content(old_callout,
    block(below: 0pt, new_title_block) +
    old_callout.body.children.at(1))
}

// 2023-10-09: #fa-icon("fa-info") is not working, so we'll eval "#fa-info()" instead
#let callout(body: [], title: "Callout", background_color: rgb("#dddddd"), icon: none, icon_color: black, body_background_color: white) = {
  block(
    breakable: false, 
    fill: background_color, 
    stroke: (paint: icon_color, thickness: 0.5pt, cap: "round"), 
    width: 100%, 
    radius: 2pt,
    block(
      inset: 1pt,
      width: 100%, 
      below: 0pt, 
      block(
        fill: background_color, 
        width: 100%, 
        inset: 8pt)[#text(icon_color, weight: 900)[#icon] #title]) +
      if(body != []){
        block(
          inset: 1pt, 
          width: 100%, 
          block(fill: body_background_color, width: 100%, inset: 8pt, body))
      }
    )
}



#let article(
  title: none,
  subtitle: none,
  authors: none,
  date: none,
  abstract: none,
  abstract-title: none,
  cols: 1,
  margin: (x: 1.25in, y: 1.25in),
  paper: "us-letter",
  lang: "en",
  region: "US",
  font: "libertinus serif",
  fontsize: 11pt,
  title-size: 1.5em,
  subtitle-size: 1.25em,
  heading-family: "libertinus serif",
  heading-weight: "bold",
  heading-style: "normal",
  heading-color: black,
  heading-line-height: 0.65em,
  sectionnumbering: none,
  pagenumbering: "1",
  toc: false,
  toc_title: none,
  toc_depth: none,
  toc_indent: 1.5em,
  doc,
) = {
  set page(
    paper: paper,
    margin: margin,
    numbering: pagenumbering,
  )
  set par(justify: true)
  set text(lang: lang,
           region: region,
           font: font,
           size: fontsize)
  set heading(numbering: sectionnumbering)
  if title != none {
    align(center)[#block(inset: 2em)[
      #set par(leading: heading-line-height)
      #if (heading-family != none or heading-weight != "bold" or heading-style != "normal"
           or heading-color != black or heading-decoration == "underline"
           or heading-background-color != none) {
        set text(font: heading-family, weight: heading-weight, style: heading-style, fill: heading-color)
        text(size: title-size)[#title]
        if subtitle != none {
          parbreak()
          text(size: subtitle-size)[#subtitle]
        }
      } else {
        text(weight: "bold", size: title-size)[#title]
        if subtitle != none {
          parbreak()
          text(weight: "bold", size: subtitle-size)[#subtitle]
        }
      }
    ]]
  }

  if authors != none {
    let count = authors.len()
    let ncols = calc.min(count, 3)
    grid(
      columns: (1fr,) * ncols,
      row-gutter: 1.5em,
      ..authors.map(author =>
          align(center)[
            #author.name \
            #author.affiliation \
            #author.email
          ]
      )
    )
  }

  if date != none {
    align(center)[#block(inset: 1em)[
      #date
    ]]
  }

  if abstract != none {
    block(inset: 2em)[
    #text(weight: "semibold")[#abstract-title] #h(1em) #abstract
    ]
  }

  if toc {
    let title = if toc_title == none {
      auto
    } else {
      toc_title
    }
    block(above: 0em, below: 2em)[
    #outline(
      title: toc_title,
      depth: toc_depth,
      indent: toc_indent
    );
    ]
  }

  if cols == 1 {
    doc
  } else {
    columns(cols, doc)
  }
}

#set table(
  inset: 6pt,
  stroke: none
)

#show: doc => article(
  title: [ \
Computer lab 1: Introduction to numpy and matplotlib \],
  pagenumbering: "1",
  toc_title: [Table of contents],
  toc_depth: 3,
  cols: 1,
  doc,
)

\#\#
Part 3: Vector and matrix operations
In this part of the lab you will work with matrix/vector-operations, such matrix multiplication, dot products, outer products and linear equation systems in numpy.
First, as before begin with importing numpy
#block[
```python
import numpy as np
```

]
Matrix operations
Create the matrices/vectors: $ A = mat(delim: "(", 2, 4, - 6; 1, 5, 3; 1, 3, 2) \, & B = mat(delim: "(", 1, - 1, 1; 4, 0, - 2; 0, 1, 1) \, & C = mat(delim: "(", 1, 2; 3, 4; 5, 6) \, & x = mat(delim: "(", 1, 2, 3) \, & y = mat(delim: "(", 2, 1, 0) . $ Also, display the matrices and the vectors on the screen so you can see that they are correctly defined.

#block[
```python
# Enter your code here
A = np.array([[2, 4, -6], [1, 5, 3], [1, 3, 2]])
print(A)
B = np.array([[1, -1, 1], [4, 0, -2], [0, 1, 1]])
print(B)
C = np.array([[1, 2], [3, 4], [5, 6]])
print(C)
x = np.array([1, 2, 3])
print(x)
y = np.array([2, 1, 0])
print(y)
```

#block[
```
[[ 2  4 -6]
 [ 1  5  3]
 [ 1  3  2]]
[[ 1 -1  1]
 [ 4  0 -2]
 [ 0  1  1]]
[[1 2]
 [3 4]
 [5 6]]
[1 2 3]
[2 1 0]
```

]
]
Matrix and vector addition/subtraction
Matrix addition and subtraction is straightforward, and follow standard linear algebra rules. Both addition and subtraction are are defined by elementwise addition/subtraction, i.e.~$A + B$ takes every element of $A$ and add the corresponding element of $B$.
Try it out in Python, calculate x+y, A+B, A-B and A+C (note, it's correct that the last operation generates an error):
#block[
```python
# Enter your code here
print(x + y)
print(A + B)
print(A - B)
# print(A+C)
```

#block[
```
[3 3 3]
[[ 3  3 -5]
 [ 5  5  1]
 [ 1  4  3]]
[[ 1  5 -7]
 [-3  5  5]
 [ 1  2  1]]
```

]
]
What was the result of the last operation (A+C), and why?

Matrix and vector multiplication
There are two different kinds of matrix/vector multiplication, the standard matrix multiplication (from linear algebra) and elementwise multiplication. Standard matrix multiplication is based on dot products, so for example the result of $A dot.op B$ would be $ A dot.op B = mat(delim: "(", 18, - 8, - 12; 21, 2, - 6; 13, 1, - 3) $ The first element in the resulting matrix, element (1,1), is the dot product between $A$'s first row and $B$'s first column, element (1,2) is the dot product of $A$'s first row and $B$'s 2nd column, and so forth. The dot product between $x$ and $y$, i.e.~$x^T y$ in linear algebra notation, will be equal to 4 (check it out!).
In numpy the functions np.dot(x,y) will calculate the dot product between 1-D vectors, and np.matmul(A,B) will calculate standard matrix multiplication. Try it out for $x$, $y$, $A$ and $B$!

#block[
```python
# Enter your code here
print(np.dot(x, y))
print(np.matmul(A, B))
```

#block[
```
4
[[ 18  -8 -12]
 [ 21   2  -6]
 [ 13   1  -3]]
```

]
]
For 2D vectors (for example a column vector in numpy) np.dotis equivalent to np.matmul (as opposed to dot, matmul does not allow multiplication with scalars).

When you work with standard multiplication, the dimensions must fit. Use np.matmul and try $B dot.op C$ and $C dot.op B$. Try to figure out why one works and the other doesn't.
#block[
```python
# Enter your code here
print(np.matmul(B, C))
# print(np.matmul(C,B))
```

#block[
```
[[ 3  4]
 [-6 -4]
 [ 8 10]]
```

]
]
The operator \@ was introduced in Python 3.5 and is equivalent with matmul. Repeat the matrix and vector operations above, but use the \@-operator instead (for example A\@B):

#block[
```python
# Enter your code here
print(x @ y)
print(A @ B)
print(B @ C)
```

#block[
```
4
[[ 18  -8 -12]
 [ 21   2  -6]
 [ 13   1  -3]]
[[ 3  4]
 [-6 -4]
 [ 8 10]]
```

]
]
When we work with regression analysis, the matrix multiplication $A^T A$ will play a crucial role. $A^T$ stands for 'A-transpose'. In numpy, the transpose of a matrix $A$ is computed with np.transpose(A) or alternatively A.T. Transpose your matrix $C$ and figure out what the transpose of a matrix does. Use both methods, np.transpose and .T:
#block[
```python
# Enter your code here
print(np.transpose(C))
print(C.T)
```

#block[
```
[[1 3 5]
 [2 4 6]]
[[1 3 5]
 [2 4 6]]
```

]
]
What dimension will $C^T C$ have? Try to figure out first, and then do the calculation in Python:
#block[
```python
# Enter your code here
print(C.T @ C)
```

#block[
```
[[35 44]
 [44 56]]
```

]
]
Elementwise multiplication is performed in numpy through the function np.multiply or the symbol \*. Use both to calculate elementwise multiplication of $A$ and $B$, $x$ and $y$ and $A$ and $C$. Try to figure out how it works (by looking at the matrices and comparing with the results). \
#block[
```python
# Enter your code here
print(np.multiply(A, B))
print(x * y)
```

#block[
```
[[ 2 -4 -6]
 [ 4  0 -6]
 [ 0  3  2]]
[2 2 0]
```

]
]
Solving equation systems
An equation system can be expressed as $A x = b$, where $A$ is and $m times n$-matrix, $b$ is $m times 1$ and is the right-hand-side. We solve for the unknowns $x$, whis is $n times 1$.
For example, the equation system
$ {2 x_1 + 4 x_2 - 6 x_3 = 2\
x_1 + 5 x_2 + 3 x_3 = 1\
x_1 + 3 x_2 + 2 x_3 = 0 upright(" can be expressed as ") & mat(delim: "(", 2, 4, - 6; 1, 5, 3; 1, 3, 2) vec(x_1, x_2, x_3) = vec(2, 1, 0) arrow.r.double A x = b $
We can solve this system using solvers that are part of the numpy.linalg library, in this case np.linalg.solve(A,b). Note that the matrix $A$ is already defined, and also the right-hand-side is defined in the array $y$. Solve the system using the solver, and store the solution in a vector $x$. Display the solution on the screen.
#block[
```python
# Enter your code here
A = np.array([[2, 4, -6], [1, 5, 3], [1, 3, 2]])
y = np.array([2, 1, 0])
x = np.linalg.solve(A, y)
print(x)
```

#block[
```
[-1.33333333  0.66666667 -0.33333333]
```

]
]
The algorithm implemented in np.linalg.solve is Gaussian elimination. Another option would be to use the matrix inverse and solve $x = A^(- 1) b$. Inverse of matrix $A$ in numpy is computed with np.linalg.inv(A). Try to solve the system using this method! You should get the same result as with Gaussian elimination (otherwise you've done something wrong).

#block[
```python
# Enter your code here
x_2 = np.linalg.inv(A) @ y
print(x_2)
```

#block[
```
[-1.33333333  0.66666667 -0.33333333]
```

]
]
Which of these two methods should we use? Does it matter which one we choose? Both of them give the same result. The answer is that it does matter, one is much more efficient than the other. To test this, run the code below. The code solves linear equation systems of different dimension, using the two methods and measures the execution time (in seconds). The matrix dimensions vary from 500 (i.e.~a $500 times 500$-matrix) to $N$ with increments of 500. The matrix and right-hand-side is created with random numbers (uniform distribution). Finally the execution time is plotted with dimension on the x-axis and time on the y-axis. You can of course change maximum dimension, $N$, but don't choose it too big, as it will take too much time to run the program.
Run the code, and also go through and try to understand the code. Many of the commands that has been covered in this lab are included in the code (such as np.arange, np.zeros etc.), and it can serve as an example of how they can be used. Note, it will take a little bit of time before the plot shows up (maybe up to a minute).
```python
# Compare execution time when solving a linear equation
# system using Gaussian elimination (np.linalg.solve)
# and inverse (np.linalg.inv)

from time import process_time
import matplotlib.pyplot as plt
import numpy as np

N = 6000  # Maximum matrix size (don't choose too big, not larger than 10000)
# Create vector from 500 to N with increment 500
A_size = np.arange(500, N + 1, 500)

# Preallocate time-vectors
timingGE = np.zeros(len(A_size))
timingI = np.zeros(len(A_size))
for i in range(len(A_size)):
    # Create matrix and rhs (random numbers)
    m = A_size[i]
    A = np.random.rand(m, m)
    b = np.random.rand(m, 1)
    # Solve with Gaussian elimination
    t1_start = process_time()
    x = np.linalg.solve(A, b)
    timingGE[i] = process_time() - t1_start
    # Solve with inverse
    t2_start = process_time()
    x = np.linalg.inv(A) @ b
    timingI[i] = process_time() - t2_start

# Plot the execution times
plt.plot(A_size, timingGE, color="r", label="Gaussian elimination")
plt.plot(A_size, timingI, color="g", label="Inverse")
plt.xlabel("Matrix size")
plt.ylabel("Execution time (s)")
plt.title("Execution time solving linear eq. system")
plt.legend()
plt.grid()
plt.show()
```

#box(image("Lab1_Part3_files/figure-typst/cell-13-output-1.png"))

Based on the graph, what is the conclusion? Which of the two algorithms should we preferably choose?
And that was the end of the lab 1… :-)
```
<hr>
```
