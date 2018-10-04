/*
	Definition of the symbol table interface functions.
*/

// Returns true/false if there is an entry in the table for the specified id name
int isDeclared (char *id);
// Adds a new entry for the specified id name; returns false if already in the table
int addId (char *id);
// Sets the v parameter to the value associated in the table with the specified id name; returns false if no table entry exists
int getValue (char *id, double *v);
// Sets the value associated with the specified id name to v; returns false if no table entry exists
int setValue (char *id, double v);