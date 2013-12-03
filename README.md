IBLLinearAlgebra
================

IBL stands for Inquiry Based Learning and is an approach
to teaching that maximizes the time a student spends with
the material.  This project is to create a series of 
Linear Algebra problem-sets to guide students through the
concepts of a one-term first course in linear algebra.

In `problemsets` you will find a document containing
Linear Algebra questions that closely follow the order
of topics presented in *Linear Algebra: A Modern Introduction*
by David Poole.  There is also a short problem-set going over
the basics of complex numbers.


LaTeX Code
----------

A few macros were created to make typesetting these problem-sets
easier.  The first is a new enumerate environment `\begin{Enum}`
which increments the major number each time a new `\begin{Enum}`
environment is started and each `\item` in the Enum increments the
minor number.  If you don't want the major number to increment,
you can use `\begin{Enum}[resume]`.

`\sep` will draw a think line extending to the margin that also
shows the problem number.  This makes it a lot easier to jump
between problems.

`\begin{Def}` is a definition environment that shows the word
*Def* on lines that extend into the margin making it clear where
a definition is located.

At the moment, some of these macros involve a few hacks and 
some manual spacing (with `\vspace{-.5in}` etc.) is needed
to make things look right. This is especially true if
a `Def` ends with an `enumerate` environment or a `\sep`
starts with an enumerate environment.


License
-------

This work is Licensed under the Creative Commons By-Attribution 
Share-Alike license.
