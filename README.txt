README

James Chin + Julia Hou
Period 3

Our project is an offline version of agar.io, the scourge of the APCS classroom.

How it works: 
Use your mouse to control the central blob, Blob 0. The goal is to increase in size, which can be accomplished by eating food or blobs smaller than you. Press space to split your blob into two pieces. 
We have the classes Blob, Piece, Gene, and food. food creates the small, inanimate circles that all blobs can eat. Gene is responsible for encoding the strategy of the blobs. Piece is a subset of the blob’s mass, and this is mostly relevant when the blob splits.

Concepts: 
Using a genetic algorithm, the blobs around you gradually become more intelligent and are more likely to survive. Whenever a blob is eaten, all the other blobs generally evolve away from the characteristics of the dead blob.
Using mergesort, the blobs are ordered from greatest to least size and the top ten blobs are displayed in the top right corner.

Bugs/problems: 
When a blob gets too big, it sometimes produces a bug.
Merging a blob after it splits can produce a similar bug.
The avoid function does not always work in some blobs, resulting in blobs running right into other blobs.