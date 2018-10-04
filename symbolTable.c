/*
	The implementation of a symbol table as a singly linked list. 
*/

#include <stdlib.h>
#include "SymbolTable.h" 	// Include the interface function prototypes

// A single entry in the symbol table.
struct symbolNode {
	char *name;		// The identifier name
	double value;	// Value assigned to it
	struct symbolNode *next;	// Pointer to next entry in the list
};
typedef struct symbolNode symbolEntry;

// The symbol table
symbolEntry *symbolTable = NULL;

// Find an entry for the specified id name; returns null if not found
symbolEntry *findEntry (char *id) {
	symbolEntry *found = symbolTable;
	while (found!=NULL && strcmp(id,found->name)) {
		found = found->next;
	}
	return found;
}

// Returns true/false if there is an entry in the table for the specified id name
int isDeclared (char *id) {
	return (findEntry(id) != NULL);
}

// Adds a new entry for the specified id name; returns false if already in the table
int addId (char *id) {
	symbolEntry *newEntry;
	if (isDeclared (id)) return 0;
	newEntry = (symbolEntry*) malloc (sizeof(symbolEntry));
	newEntry->name = id;
	newEntry->value = 0;
	newEntry->next = symbolTable;
	symbolTable = newEntry;
	return 1;
}

// Sets the v parameter to the value associated in the table with the specified id name; returns false if no table entry exists
int getValue (char *id, double *v) {
	symbolEntry *entry = findEntry (id);
	if (entry == NULL) return 0;
	*v = entry->value;
	return 1;
}

// Sets the value associated with the specified id name to v; returns false if no table entry exists
int setValue (char *id, double v) {
	symbolEntry *entry = findEntry (id);
	if (entry == NULL) return 0;
	entry->value = v;
	return 1;
}